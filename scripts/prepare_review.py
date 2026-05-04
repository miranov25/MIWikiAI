#!/usr/bin/env python3
"""
prepare_review.py v1.0 — MIWikiAI artifact preprocessor (AST-based)

Replaces v0.x regex-based implementation. Uses mistletoe markdown AST parser
for all structural parsing — no regex against raw text for markdown structure.

Five public check functions, each returning (rc: int, output_text: str):
    check_anchors(artifact_path)
    check_verbatim(artifact_path, source_root)
    check_counters(artifact_path, usage_csv_path)
    check_prose_fabric(artifact_path, source_root, terms=DEFAULT_TERMS)

rc == 0 means PASS (no issues).
rc == 1 means FAIL (issues found, listed in output).
rc == 2 means SKIPPED (input missing).

These functions are called by prepare_review.sh for full bundle assembly,
and by tests/test_prepare_review.py for unit testing.
"""

import argparse
import csv
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import mistletoe
from mistletoe.block_token import (
    Document, Heading, Paragraph, Table, List, CodeFence, ThematicBreak
)
from mistletoe.span_token import RawText, InlineCode, Strong, LineBreak

VERSION = "1.2"

# ---------------------------------------------------------------------------
# AST helpers
# ---------------------------------------------------------------------------

def _text_of(node):
    """Recursively collect raw text content from any AST node, joined."""
    if hasattr(node, 'content') and isinstance(node.content, str):
        return node.content
    parts = []
    for c in (getattr(node, 'children', None) or []):
        parts.append(_text_of(c))
    return ''.join(parts)


def _heading_text(heading):
    """Extract clean text from a Heading node (concatenates inline children)."""
    return _text_of(heading)


def _heading_symbol(heading):
    """Extract the bare symbol name from a per-symbol heading.

    Real artifact format: '### 4.1 `ConfigurableParam` (class)'
    The mistletoe Heading has children including a section-number RawText
    and an InlineCode for the symbol. We pick the FIRST InlineCode child as
    the symbol name, then strip template/parameter parts to bare name.

    Returns None if heading has no InlineCode child.
    """
    inline_codes = []
    for child in (heading.children or []):
        if isinstance(child, InlineCode):
            inline_codes.append(_text_of(child))
    if not inline_codes:
        return None
    raw = inline_codes[0]
    # Strip everything after first '<', '(', whitespace
    m = re.match(r'([A-Za-z_][A-Za-z0-9_]*)', raw)
    return m.group(1) if m else raw


def _slugify_github(text):
    """Convert heading text to GitHub-flavored markdown anchor slug.

    Rules:
      - lowercase
      - drop punctuation except hyphens and word chars
      - replace spaces with hyphens
      - strip backticks (preserve content)
    """
    s = text.lower()
    s = re.sub(r'`([^`]+)`', r'\1', s)
    s = re.sub(r'[^\w\s-]', '', s)
    s = re.sub(r'\s+', '-', s.strip())
    return s


def _walk_paragraphs(doc):
    """Yield (idx, paragraph_node) for each Paragraph in doc.children."""
    for i, child in enumerate(doc.children or []):
        if isinstance(child, Paragraph):
            yield i, child


def _paragraph_has_strong_label(p, label):
    """True if paragraph's first non-empty inline child is Strong containing label."""
    for c in (p.children or []):
        if isinstance(c, Strong):
            return label.rstrip(':') in _text_of(c)
        if hasattr(c, 'content') and c.content.strip() == '':
            continue
        return False
    return False


# ---------------------------------------------------------------------------
# CHECK 1: anchor validation (uses mistletoe AST)
# ---------------------------------------------------------------------------

def check_anchors(artifact_path):
    """Verify every [text](#anchor) link resolves to an existing heading slug."""
    with open(artifact_path, 'r', encoding='utf-8') as f:
        text = f.read()

    doc = Document(text)

    # Collect heading slugs (with -1, -2 disambiguation for repeats)
    slug_seen = {}
    slugs = set()
    for child in doc.children or []:
        if isinstance(child, Heading):
            base = _slugify_github(_heading_text(child))
            if base in slug_seen:
                slug_seen[base] += 1
                slugs.add(f'{base}-{slug_seen[base]}')
            else:
                slug_seen[base] = 0
                slugs.add(base)

    # Extract anchor links via regex on raw text — links are not strictly
    # markdown-AST-only because some authors use HTML/raw <a> too.
    # Pattern: [text](#anchor)
    link_re = re.compile(r'\[([^\]]+)\]\(#([^)]+)\)')
    links = link_re.findall(text)

    out = []
    out.append(f"=== Anchor check for {artifact_path} ===")
    out.append(f"Headings found: {sum(1 for c in doc.children or [] if isinstance(c, Heading))}")
    out.append(f"Anchor links: {len(links)}")
    out.append("")

    broken = [(label, anchor) for label, anchor in links if anchor not in slugs]
    if broken:
        out.append(f"BROKEN ANCHORS: {len(broken)}")
        for label, anchor in broken:
            out.append(f"  [{label}](#{anchor})")
        return 1, '\n'.join(out)

    out.append("OK: all anchor links resolve to existing headings.")
    return 0, '\n'.join(out)


# ---------------------------------------------------------------------------
# CHECK 2: VERBATIM citation accuracy
# ---------------------------------------------------------------------------

# Pattern accepts:
#   VERBATIM `path/to/file.h`:L141-L156
#   VERBATIM `path/to/file.h`:L141-156
#   VERBATIM file.h L141-149
#   [VERBATIM ...] inside brackets
# We do NOT fully migrate to AST here because VERBATIM tags are inline within
# any node type (paragraph, code-fence comment, table cell). The regex is on
# raw text but anchored to "VERBATIM" + filename ending in code extension +
# digit ranges — minimal pattern surface that does not depend on markdown
# structure.
_VERBATIM_RE = re.compile(
    r'VERBATIM[^\]\n]*?'
    r'(?P<path>[A-Za-z0-9_\-./]+\.(?:h|hpp|cxx|cpp|cc|c))'
    r'[\s:`]*L(?P<lstart>\d+)\s*[-:]\s*L?(?P<lend>\d+)',
    re.IGNORECASE
)


def check_verbatim(artifact_path, source_root):
    """Verify every [VERBATIM <file>:Lx-Ly] resolves to existing source + valid range."""
    with open(artifact_path, 'r', encoding='utf-8') as f:
        text = f.read()

    out = []
    out.append(f"=== VERBATIM check for {artifact_path} ===")
    out.append(f"Source root: {source_root}")
    out.append("")

    citations = list(_VERBATIM_RE.finditer(text))
    # Free-text VERBATIM (with no line range) — count for transparency
    all_verbatim = re.findall(r'VERBATIM[^\]\n]*', text)
    free_text = max(0, len(all_verbatim) - len(citations))

    out.append(f"Total VERBATIM tags: {len(all_verbatim)}")
    out.append(f"Verifiable (with file + line range): {len(citations)}")
    out.append(f"Free-text (no line range, not checked): {free_text}")
    out.append("")

    if not source_root or not os.path.isdir(source_root):
        out.append(f"SKIPPED: source root not found at {source_root}")
        return 2, '\n'.join(out)

    errors = 0
    for cit in citations:
        cited_path = cit.group('path')
        l_start = int(cit.group('lstart'))
        l_end = int(cit.group('lend'))
        basename = os.path.basename(cited_path)

        # Find candidates by basename
        try:
            result = subprocess.run(
                ['find', source_root, '-name', basename, '-type', 'f'],
                capture_output=True, text=True, timeout=30
            )
            candidates = [p for p in result.stdout.strip().split('\n') if p]
        except subprocess.TimeoutExpired:
            out.append(f"  TIMEOUT searching for {basename}")
            errors += 1
            continue

        if not candidates:
            out.append(f"  ERROR: no source file matching basename {basename}")
            errors += 1
            continue

        # If multiple candidates, prefer one whose path ends in cited_path
        if len(candidates) > 1:
            preferred = [c for c in candidates if c.endswith(cited_path)]
            if preferred:
                candidates = preferred

        src = candidates[0]
        try:
            with open(src, 'r', encoding='utf-8', errors='replace') as f:
                lines = f.readlines()
        except Exception as e:
            out.append(f"  ERROR: cannot read {src}: {e}")
            errors += 1
            continue

        if l_start < 1 or l_end > len(lines) or l_start > l_end:
            out.append(f"  ERROR: {basename} L{l_start}-{l_end} out of range (file has {len(lines)} lines)")
            errors += 1
            continue

        out.append(f"  OK: {basename} L{l_start}-{l_end} resolved to {src}")

    out.append("")
    if errors:
        out.append(f"VERBATIM check found {errors} error(s).")
        return 1, '\n'.join(out)

    out.append("OK: all verifiable VERBATIM citations resolved.")
    return 0, '\n'.join(out)


# ---------------------------------------------------------------------------
# CHECK 3: counter signals — AST-based, anchored on Signal: Strong label
# ---------------------------------------------------------------------------

# Metric extraction regex applies ONLY to text within an authoritative Signal
# paragraph (selected via AST). It does NOT scan free text.
_METRIC_PATTERNS = {
    'prod_usage_count': re.compile(r'prod_usage_count\s*=\s*(-?\d+)'),
    'workflows_direct': re.compile(r'workflows_direct\s*=\s*(-?\d+)'),
    'churn_12m':        re.compile(r'churn_12m\s*=\s*(-?\d+)'),
}


def _signal_text_from_paragraph(p):
    """Extract the text following the **Signal:** Strong label inside paragraph.

    Returns the concatenated raw text from after the Signal: label until the
    next LineBreak or end of paragraph. Returns None if paragraph has no
    Signal: Strong label.
    """
    children = p.children or []
    found_signal = False
    accum = []
    for c in children:
        if isinstance(c, LineBreak):
            if found_signal:
                break  # Signal value ends at next line break
            continue
        if isinstance(c, Strong):
            stext = _text_of(c)
            if 'Signal' in stext and stext.rstrip().endswith(':'):
                found_signal = True
                continue
        if found_signal:
            accum.append(_text_of(c))
    if not found_signal:
        return None
    return ''.join(accum)


def _find_owning_symbol(doc, paragraph_idx):
    """Walk back from paragraph_idx in doc.children to find the most recent
    level-3 Heading. Return its bare symbol name, or None."""
    for i in range(paragraph_idx - 1, -1, -1):
        node = doc.children[i]
        if isinstance(node, Heading) and node.level == 3:
            return _heading_symbol(node)
    return None


def check_counters(artifact_path, usage_csv_path):
    """Verify Signal: paragraph counter claims match usage.csv entries."""
    out = []
    out.append(f"=== Counter check for {artifact_path} ===")
    out.append(f"usage.csv: {usage_csv_path}")
    out.append("")

    if not os.path.isfile(usage_csv_path):
        out.append(f"SKIPPED: usage.csv not available at {usage_csv_path}")
        return 2, '\n'.join(out)

    with open(artifact_path, 'r', encoding='utf-8') as f:
        text = f.read()

    doc = Document(text)

    # Read CSV with proper quoted-field parser (Python csv handles commas-in-strings)
    usage = {}
    with open(usage_csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            sym = row['symbol']
            try:
                usage[sym] = {
                    'prod_usage_count': int(row.get('prod_usage_count', 0) or 0),
                    'workflows_direct': int(row.get('workflows_direct', 0) or 0),
                    'churn_12m':        int(row.get('churn_12m', 0) or 0),
                }
            except (ValueError, TypeError):
                continue

    # Walk paragraphs, find Signal: blocks
    findings = []
    warnings = []
    checks_done = 0
    signal_blocks = 0

    for idx, paragraph in _walk_paragraphs(doc):
        signal_text = _signal_text_from_paragraph(paragraph)
        if signal_text is None:
            continue
        signal_blocks += 1

        sym = _find_owning_symbol(doc, idx)
        if sym is None:
            warnings.append(
                f"Signal: paragraph #{idx} found but no preceding ### heading")
            continue

        if sym not in usage:
            warnings.append(
                f"symbol '{sym}' (Signal: paragraph #{idx}) not found in usage.csv "
                f"(could be ambiguous-merge or template-removed)")
            continue

        csv_row = usage[sym]
        for metric, regex in _METRIC_PATTERNS.items():
            m = regex.search(signal_text)
            if not m:
                continue  # metric not claimed in this Signal block
            claimed = int(m.group(1))
            actual = csv_row[metric]
            checks_done += 1
            if claimed == actual:
                continue
            # ambiguous-merge sentinel: -1 in either side = expected, don't fail
            if claimed == -1 or actual == -1:
                continue
            findings.append(
                f"  MISMATCH {sym}: {metric} claims {claimed}, usage.csv has {actual}"
            )

    out.append(f"Signal: blocks scanned: {signal_blocks}")
    out.append(f"Metric checks performed: {checks_done}")
    out.append("")

    if warnings:
        for w in warnings:
            out.append(f"  WARN: {w}")
        out.append("")

    for f in findings:
        out.append(f)

    out.append("")
    if findings:
        out.append(f"Counter check found {len(findings)} authoritative-block mismatch(es).")
        return 1, '\n'.join(out)

    out.append("OK: all Signal-block counter claims match usage.csv.")
    return 0, '\n'.join(out)


# ---------------------------------------------------------------------------
# CHECK 4: prose-fabrication — known-fabricated identifier grep
# ---------------------------------------------------------------------------

DEFAULT_FABRICATION_TERMS = ['kCCDBPRIO', 'kRTF', 'kEXIM']


def check_prose_fabric(artifact_path, source_root, terms=None):
    """Detect known-fabricated identifiers (cycle-2 EParamProvenance class).

    v1.1: distinguishes front-matter occurrences (revision_history, changelog,
    known_verify_flags) from main-body prose. Front-matter occurrences are
    documentation-of-prior-fabrication and are ACCEPTABLE. Main-body occurrences
    that assert the identifier exists in source are P0 findings.

    PASS: all occurrences in front-matter
    FAIL: at least one occurrence in main body
    PASS (clean): no occurrences anywhere
    """
    if terms is None:
        terms = DEFAULT_FABRICATION_TERMS

    with open(artifact_path, 'r', encoding='utf-8') as f:
        artifact_text = f.read()

    lines = artifact_text.splitlines()

    # Determine front-matter boundary: opening --- at line 1, closing --- somewhere
    # If the first non-empty line is ---, find the matching closer.
    fm_end = 0  # 0 means no front-matter
    if lines and lines[0].strip() == '---':
        for i in range(1, len(lines)):
            if lines[i].strip() == '---':
                fm_end = i + 1  # 1-indexed inclusive
                break

    # Classify each occurrence by location
    body_hits = []
    fm_hits = []
    for i, line in enumerate(lines, start=1):
        for term in terms:
            if term in line:
                if i <= fm_end:
                    fm_hits.append((i, line, 'front-matter'))
                else:
                    body_hits.append((i, line, 'body'))
                break  # don't double-count if multiple terms in same line

    out = []
    out.append(f"=== Prose-vs-VERBATIM fabrication check for {artifact_path} ===")
    out.append(f"Source root: {source_root}")
    out.append("")
    out.append(f"--- Terms checked: {', '.join(terms)} ---")
    out.append(f"--- Front-matter span: lines 1-{fm_end} ---" if fm_end else "--- No YAML front-matter detected ---")
    out.append("")

    out.append("--- In artifact ---")
    if not body_hits and not fm_hits:
        out.append("OK: no occurrences in artifact.")
    else:
        if fm_hits:
            out.append(f"FRONT-MATTER OCCURRENCES (acceptable — disclosure context): {len(fm_hits)}")
            for i, line, _ in fm_hits[:10]:
                out.append(f"  L{i}: {line.rstrip()[:160]}")
            if len(fm_hits) > 10:
                out.append(f"  ... and {len(fm_hits) - 10} more")
            out.append("")
        if body_hits:
            out.append(f"BODY OCCURRENCES (P0 — fabrication asserted as fact): {len(body_hits)}")
            for i, line, _ in body_hits[:10]:
                out.append(f"  L{i}: {line.rstrip()[:160]}")
            if len(body_hits) > 10:
                out.append(f"  ... and {len(body_hits) - 10} more")
    out.append("")

    # In source root: scan if available
    out.append("--- In source root ---")
    source_hits = []
    if source_root and os.path.isdir(source_root):
        try:
            scan_root = os.path.join(source_root, 'Common', 'Utils')
            if not os.path.isdir(scan_root):
                scan_root = source_root
            term_pattern = '|'.join(terms)
            result = subprocess.run(
                ['grep', '-r', '-l', '-E', term_pattern, scan_root],
                capture_output=True, text=True, timeout=30
            )
            source_hits = [p for p in result.stdout.strip().split('\n') if p]
        except Exception as e:
            out.append(f"  WARN: source scan failed: {e}")

    if source_hits:
        out.append(f"FOUND in source files (these are not fabrications):")
        for h in source_hits[:10]:
            out.append(f"  {h}")
    else:
        out.append("OK: no occurrences in source — confirmed not present.")

    out.append("")
    # Verdict logic
    if body_hits and not source_hits:
        out.append("RESULT: FAIL — fabricated identifiers asserted in main body, not present in source.")
        out.append("These are P0 findings: prose claims something the source does not contain.")
        return 1, '\n'.join(out)
    elif fm_hits and not body_hits:
        out.append("RESULT: PASS — fabricated identifiers appear ONLY in front-matter (revision_history,")
        out.append("changelog, known_verify_flags). These document the prior fabrication and are")
        out.append("acceptable disclosure context. No main-body assertions found.")
        return 0, '\n'.join(out)
    else:
        out.append("RESULT: clean.")
        return 0, '\n'.join(out)


# ---------------------------------------------------------------------------
# CLI / Bundle assembly
# ---------------------------------------------------------------------------

def detect_needs(artifact_path):
    """Auto-detect whether artifact needs source/counter bundled."""
    with open(artifact_path, 'r', encoding='utf-8') as f:
        text = f.read()
    needs_source = bool(re.search(r'VERBATIM[^\]\n]*?\.(?:h|hpp|cxx|cpp|cc|c)', text))
    needs_counter = 'prod_usage_count' in text
    return needs_source, needs_counter


def find_latest(directory, prefix):
    """Find latest version of a versioned file like prefix_v0_5_*.md."""
    if not os.path.isdir(directory):
        return None
    candidates = [f for f in os.listdir(directory) if f.startswith(prefix) and f.endswith('.md')]
    if not candidates:
        return None
    candidates.sort()  # version-sort works for v0_5_1 .. v0_5_4 etc
    return os.path.join(directory, candidates[-1])


def main():
    parser = argparse.ArgumentParser(
        description=f'prepare_review.py v{VERSION} — MIWikiAI artifact preprocessor (AST-based)',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  prepare_review.py --artifact Alice/code/O2/Common_utilities_API.md
  prepare_review.py --artifact <FILE> --no-source --no-counter
  prepare_review.py --check anchors --artifact <FILE>     # run single check, print to stdout
""")

    parser.add_argument('--artifact', required=True,
                        help='Path to artifact .md file')
    parser.add_argument('--out-dir', default='reviewer_bundle',
                        help='Output directory (default: reviewer_bundle/)')
    parser.add_argument('--aliceo2-root',
                        default=os.environ.get('ALICEO2_ROOT', '/Users/miranov25/alicesw/O2'),
                        help='AliceO2 source tree root')
    parser.add_argument('--usage-csv', default='scripts/usage.csv',
                        help='Counter usage.csv path')
    parser.add_argument('--breakdown-tsv', default='scripts/breakdown.tsv',
                        help='Counter breakdown.tsv path')
    parser.add_argument('--governance-dir',
                        default='/Users/miranov25/NOTES/alice-tpc-notes/JIRA/O2-6532/docs/MIWikiAI',
                        help='Governance docs directory (latest QRC + Counter Spec only)')
    parser.add_argument('--no-source', action='store_true', help='Skip source.zip')
    parser.add_argument('--no-counter', action='store_true', help='Skip counter files')
    parser.add_argument('--force-source', action='store_true', help='Force include source')
    parser.add_argument('--force-counter', action='store_true', help='Force include counter')
    parser.add_argument('--source-subtree', default=None,
                        help='Override auto-detection: bundle this AliceO2 subtree (e.g. Common/Utils). '
                             'If not given, script reads upstream: front-matter and zips the common-ancestor directory.')
    parser.add_argument('--extra', action='append', default=[],
                        help='Extra file to include in preprocessed/ (repeatable)')
    parser.add_argument('--check', choices=['anchors', 'verbatim', 'counters', 'prose'],
                        help='Run a single check and print to stdout (no bundle)')

    args = parser.parse_args()

    if not os.path.isfile(args.artifact):
        print(f"ERROR: artifact not found: {args.artifact}", file=sys.stderr)
        return 2

    # Single-check mode (useful for debugging / CI)
    if args.check:
        if args.check == 'anchors':
            rc, out = check_anchors(args.artifact)
        elif args.check == 'verbatim':
            rc, out = check_verbatim(args.artifact, args.aliceo2_root)
        elif args.check == 'counters':
            rc, out = check_counters(args.artifact, args.usage_csv)
        elif args.check == 'prose':
            rc, out = check_prose_fabric(args.artifact, args.aliceo2_root)
        print(out)
        return rc

    # Full bundle assembly
    return _assemble_bundle(args)


def _assemble_bundle(args):
    """Build the reviewer.zip bundle."""
    artifact = args.artifact
    artifact_basename = os.path.basename(artifact)
    artifact_stem = artifact_basename[:-3] if artifact_basename.endswith('.md') else artifact_basename

    # Auto-detect if not forced
    needs_source, needs_counter = detect_needs(artifact)
    if args.force_source: needs_source = True
    if args.no_source:    needs_source = False
    if args.force_counter: needs_counter = True
    if args.no_counter:    needs_counter = False

    print(f"INFO    prepare_review.py v{VERSION}")
    print(f"INFO    Artifact: {artifact}")
    print(f"INFO    Output:   {args.out_dir}")
    print(f"INFO    needs_source={needs_source}, needs_counter={needs_counter}")

    bundle_dir = os.path.join(args.out_dir, f'{artifact_stem}_review_bundle')
    if os.path.isdir(bundle_dir):
        shutil.rmtree(bundle_dir)
    for sub in ['artifact', 'governance', 'counter', 'source', 'preprocessed']:
        os.makedirs(os.path.join(bundle_dir, sub), exist_ok=True)

    # Artifact
    shutil.copy(artifact, os.path.join(bundle_dir, 'artifact', artifact_basename))
    print(f"OK      Copied artifact")

    # Governance
    qrc = find_latest(args.governance_dir, 'MIWikiAI_Quick_Reference_Card_v0_5_')
    if qrc:
        shutil.copy(qrc, os.path.join(bundle_dir, 'governance', os.path.basename(qrc)))
        print(f"INFO    governance: {os.path.basename(qrc)}")
    spec = find_latest(args.governance_dir, 'MIWikiAI_Counter_Spec_v')
    if spec:
        shutil.copy(spec, os.path.join(bundle_dir, 'governance', os.path.basename(spec)))
        print(f"INFO    governance: {os.path.basename(spec)}")

    # Counter
    if needs_counter:
        if os.path.isfile(args.usage_csv):
            shutil.copy(args.usage_csv, os.path.join(bundle_dir, 'counter', 'usage.csv'))
        if os.path.isfile(args.breakdown_tsv):
            shutil.copy(args.breakdown_tsv, os.path.join(bundle_dir, 'counter', 'breakdown.tsv'))
        print(f"OK      Copied counter files")

    # Source.zip — extracted on basis of upstream subtree (or VERBATIM fallback)
    if needs_source and os.path.isdir(args.aliceo2_root):
        _build_source_zip(artifact, args.aliceo2_root,
                          os.path.join(bundle_dir, 'source', 'source.zip'),
                          source_subtree=args.source_subtree)

    # Run checks; track rc per check directly (no output-text re-parsing)
    rc_per_check = {}
    print(f"INFO    Running 4 checks...")

    rc, out = check_anchors(artifact)
    rc_per_check['anchor_check'] = rc
    with open(os.path.join(bundle_dir, 'preprocessed', 'anchor_check.txt'), 'w') as f:
        f.write(out)
    print(f"        anchor_check:           {'PASS' if rc == 0 else 'FAIL' if rc == 1 else 'SKIP'}")

    rc, out = check_verbatim(artifact, args.aliceo2_root)
    rc_per_check['verbatim_check'] = rc
    with open(os.path.join(bundle_dir, 'preprocessed', 'verbatim_check.txt'), 'w') as f:
        f.write(out)
    print(f"        verbatim_check:         {'PASS' if rc == 0 else 'FAIL' if rc == 1 else 'SKIP'}")

    rc, out = check_counters(artifact, args.usage_csv)
    rc_per_check['counter_check'] = rc
    with open(os.path.join(bundle_dir, 'preprocessed', 'counter_check.txt'), 'w') as f:
        f.write(out)
    print(f"        counter_check:          {'PASS' if rc == 0 else 'FAIL' if rc == 1 else 'SKIP'}")

    rc, out = check_prose_fabric(artifact, args.aliceo2_root)
    rc_per_check['prose_fabrication_check'] = rc
    with open(os.path.join(bundle_dir, 'preprocessed', 'prose_fabrication_check.txt'), 'w') as f:
        f.write(out)
    print(f"        prose_fabrication_check: {'PASS' if rc == 0 else 'FAIL' if rc == 1 else 'SKIP'}")

    rc_total = 1 if any(rc == 1 for rc in rc_per_check.values()) else 0

    # Extras
    for extra in args.extra:
        if os.path.isfile(extra):
            shutil.copy(extra, os.path.join(bundle_dir, 'preprocessed', os.path.basename(extra)))
            print(f"OK      Added extra: {extra}")
        else:
            print(f"WARN    Extra not found: {extra}")

    # Summary file (uses rc_per_check, no output-text heuristics)
    _write_summary(bundle_dir, rc_per_check)

    # Manifest
    _write_manifest(bundle_dir, artifact)

    # Zip bundle
    zipfile = f'{args.out_dir}/{artifact_stem}_review_bundle.zip'
    if os.path.isfile(zipfile):
        os.remove(zipfile)
    subprocess.run(['zip', '-rq', os.path.basename(zipfile), os.path.basename(bundle_dir)],
                   cwd=args.out_dir, check=True)
    print(f"OK      Bundle: {zipfile}")

    # Print summary
    print("")
    print("=" * 66)
    print(" Pre-flight summary")
    print("=" * 66)
    with open(os.path.join(bundle_dir, 'preprocessed', 'summary.txt')) as f:
        print(f.read())

    if rc_total == 0:
        print("RESULT: all pre-flight checks PASS. Bundle ready for dispatch.")
    else:
        print("RESULT: at least one check FAILED. Review preprocessed/*.txt before dispatch.")
    print(f"Bundle: {zipfile}")
    print("")
    return rc_total


def _extract_upstream_paths(artifact_path):
    """Read artifact front-matter, extract `title:` fields from `upstream:` block.

    Filters to real-looking source paths only:
      - must contain at least one '/'
      - must end with a recognized C++/code source extension (.h, .hpp, .cxx, .cpp, .cc, .c)
      - drops parenthetical commentary in titles like 'foo.cxx (top caller per ...)'

    Returns list of cleaned relative paths. Empty list if no upstream block or no
    paths matching these criteria (e.g. an upstream block listing only papers/PDFs).
    """
    paths = []
    with open(artifact_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    if not lines or lines[0].strip() != '---':
        return paths

    fm_end = 0
    for i in range(1, len(lines)):
        if lines[i].strip() == '---':
            fm_end = i
            break
    if fm_end == 0:
        return paths

    in_upstream = False
    for i in range(1, fm_end):
        line = lines[i]
        stripped = line.lstrip()
        if line.startswith('upstream:'):
            in_upstream = True
            continue
        if in_upstream:
            if line and line[0] not in ' \t#' and stripped != '':
                in_upstream = False
                continue
            tm = re.match(r'\s+title:\s*"?([^"\n]+?)"?\s*$', line)
            if tm:
                raw = tm.group(1).strip()
                # Drop trailing parenthetical commentary: "foo.cxx (top caller...)" -> "foo.cxx"
                raw = re.sub(r'\s*\([^)]*\)\s*$', '', raw).strip()
                # Filter: must look like a real source path
                if '/' not in raw:
                    continue
                if not re.search(r'\.(h|hpp|cxx|cpp|cc|c)$', raw):
                    continue
                paths.append(raw)
    return paths


def _common_ancestor_subtree(paths):
    """Find the directory subtree that covers the majority of source paths.

    Strategy: pick the longest 2+-component prefix that is shared by more than
    half of the paths. This handles the case where most paths are in the
    primary source tree (e.g. Common/Utils) but a few outliers are caller
    files in other modules (e.g. Detectors/TPC/workflow). The outliers are
    sacrificed — reviewers can fetch them via web_search if needed.

    If no prefix is shared by majority, return ''.

    Examples:
      ['Common/Utils/include/...', 'Common/Utils/src/...']                  -> 'Common/Utils'
      ['Common/Utils/include/...', 'Common/Utils/src/...', 'Detectors/T..'] -> 'Common/Utils' (majority)
      ['CCDB/include/...', 'DataFormats/...']                               -> '' (no majority)
      ['Common/Utils/include/CommonUtils/Foo.h']                            -> 'Common/Utils/include/CommonUtils'
    """
    if not paths:
        return ''

    n = len(paths)
    threshold = n // 2 + 1   # strict majority

    # Generate all 2+-component prefixes for each path, count frequencies
    from collections import Counter
    prefix_counts = Counter()
    for p in paths:
        parts = p.split('/')
        # Drop filename (last component if it has '.')
        if parts and '.' in parts[-1]:
            parts = parts[:-1]
        # Generate all prefixes of length 2 to len(parts)
        for k in range(2, len(parts) + 1):
            prefix_counts['/'.join(parts[:k])] += 1

    # Pick the LONGEST prefix that's shared by majority
    candidates = [(p, c) for p, c in prefix_counts.items() if c >= threshold]
    if not candidates:
        return ''
    # Sort: longest path first, ties broken by frequency
    candidates.sort(key=lambda x: (x[0].count('/'), x[1]), reverse=True)
    return candidates[0][0]


def _build_source_zip(artifact_path, source_root, outzip, source_subtree=None):
    """Bundle source files for review.

    Strategy (v1.2):
      1. If --source-subtree is given (explicit override), zip that subtree.
      2. Else read front-matter `upstream:` block, find common-ancestor directory.
      3. If common ancestor exists, zip the whole subtree (reviewers need this for
         Aspect-E example plausibility — citing files NOT in the artifact).
      4. Fallback: VERBATIM-cited basenames only (v1.1 behavior).
    """
    # Step 1: explicit override
    if source_subtree:
        subtree = source_subtree.strip().strip('/')
        method = f"explicit override --source-subtree {subtree}"
    else:
        # Step 2-3: auto-detect from upstream front-matter
        upstream_paths = _extract_upstream_paths(artifact_path)
        subtree = _common_ancestor_subtree(upstream_paths)
        if subtree:
            method = f"auto-detected from upstream front-matter ({len(upstream_paths)} entries, common ancestor: {subtree})"
        else:
            # Step 4: fallback to VERBATIM-cited files
            subtree = None
            method = "VERBATIM-cited files only (no upstream front-matter or no common ancestor)"

    print(f"INFO    source.zip method: {method}")

    if subtree:
        # Bundle the entire subtree
        full_path = os.path.join(source_root, subtree)
        if not os.path.isdir(full_path):
            print(f"WARN    subtree {full_path} does not exist; skipping source.zip")
            return

        if not os.path.isabs(outzip):
            outzip = os.path.abspath(outzip)
        os.makedirs(os.path.dirname(outzip), exist_ok=True)

        # zip from source_root to preserve relative path structure
        result = subprocess.run(
            ['zip', '-rq', outzip, subtree],
            cwd=source_root,
            capture_output=True, text=True
        )
        if result.returncode == 0:
            # Count files for reporting
            count_result = subprocess.run(
                ['unzip', '-l', outzip],
                capture_output=True, text=True
            )
            # crude file count: lines minus headers
            n_files = max(0, len(count_result.stdout.splitlines()) - 4)
            print(f"OK      source.zip: subtree {subtree} ({n_files} files)")
        else:
            print(f"WARN    source.zip build failed: {result.stderr}")
        return

    # Fallback: v1.1 VERBATIM-basename behavior
    with open(artifact_path, 'r', encoding='utf-8') as f:
        text = f.read()
    basenames = set()
    for m in _VERBATIM_RE.finditer(text):
        basenames.add(os.path.basename(m.group('path')))

    if not basenames:
        return

    found_files = []
    for bn in basenames:
        result = subprocess.run(
            ['find', source_root, '-name', bn, '-type', 'f'],
            capture_output=True, text=True, timeout=30
        )
        for p in result.stdout.strip().split('\n'):
            if p:
                found_files.append(p)

    if not found_files:
        return

    if not os.path.isabs(outzip):
        outzip = os.path.abspath(outzip)
    os.makedirs(os.path.dirname(outzip), exist_ok=True)

    rel_paths = []
    for f in found_files:
        if f.startswith(source_root):
            rel_paths.append(os.path.relpath(f, source_root))

    if not rel_paths:
        return

    with tempfile.NamedTemporaryFile('w', delete=False) as tmpf:
        for rp in rel_paths:
            tmpf.write(rp + '\n')
        tmplist = tmpf.name

    try:
        result = subprocess.run(
            ['zip', '-q', outzip, '-@'],
            stdin=open(tmplist), cwd=source_root,
            capture_output=True, text=True
        )
        if result.returncode == 0:
            print(f"OK      source.zip: {len(rel_paths)} VERBATIM-cited files (fallback mode)")
        else:
            print(f"WARN    source.zip build failed: {result.stderr}")
    finally:
        os.unlink(tmplist)


def _write_summary(bundle_dir, rc_per_check):
    """Write summary.txt deterministically from rc per check."""
    summary_path = os.path.join(bundle_dir, 'preprocessed', 'summary.txt')
    with open(summary_path, 'w') as out:
        out.write("=== Pre-flight summary ===\n")
        from datetime import datetime, timezone
        out.write(f"Date: {datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%MZ')}\n")
        out.write(f"Tool: prepare_review.py v{VERSION}\n")
        for chk in ['anchor_check', 'verbatim_check', 'counter_check', 'prose_fabrication_check']:
            rc = rc_per_check.get(chk, -1)
            if rc == 0:
                out.write(f"PASS: {chk}\n")
            elif rc == 1:
                out.write(f"FAIL: {chk} (review preprocessed/{chk}.txt)\n")
            elif rc == 2:
                out.write(f"SKIP: {chk}\n")
            else:
                out.write(f"MISSING: {chk}\n")


def _write_manifest(bundle_dir, artifact):
    import getpass, socket
    from datetime import datetime, timezone
    with open(os.path.join(bundle_dir, 'MANIFEST.md'), 'w') as f:
        f.write(f"""# Reviewer bundle MANIFEST

**Artifact:** {artifact}
**Built by:** {getpass.getuser()}@{socket.gethostname()}
**Date:** {datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%MZ')}
**Tool:** prepare_review.py v{VERSION} (AST-based)

## Bundle contents

- artifact/{os.path.basename(artifact)}
- governance/        Latest MIWikiAI_QRC + Counter_Spec
- counter/           usage.csv + breakdown.tsv (if needed)
- source/source.zip  Subset of AliceO2 source for VERBATIM citations (if needed)
- preprocessed/      4 mechanical pre-flight check outputs + summary.txt
- preprocessed/<extras>  (optional self-review, prior synthesis)

## How reviewers use this bundle

1. Read MIWikiAI_QRC v0.5.4 (binding governance)
2. Read this artifact
3. Consult preprocessed/summary.txt for pre-flight verdicts
4. If a check shows FAIL, read the corresponding preprocessed/<check>.txt for details
5. Findings the prefilter flagged are CANDIDATE findings; reviewer must
   verify before including in own report
""")


if __name__ == '__main__':
    sys.exit(main())
