#!/usr/bin/env python3
"""
check_links.py v0.2 — MIWikiAI link checker.

WHY v0.2 EXISTS
---------------
v0.1 could not distinguish three failures that print identically:

  (a) the link is genuinely broken;
  (b) the target exists on THIS disk but is not committed, so the link works
      here and is broken for everyone else;
  (c) the checker ran from an incomplete tree, so the target is merely absent.

Measured 2026-08-25: AliceO2_overview.md reported 2 broken links on the
architect's machine and 6 on the coder's. The difference was three links to
Common_utilities.md - present on the architect's disk, UNTRACKED, hence 404
in the repository. Under v0.1 neither party could tell (a) from (b) from (c),
and the coder reported the inflated number as fact.

v0.2 makes that impossible to do silently:

  * failures grouped as BROKEN FRAGMENT / MISSING FILE / UNTRACKED FILE
  * --git checks targets against `git ls-files`, catching case (b)
  * every run prints a RUN FINGERPRINT (root, commit, dirty flag, file counts)
    so two runs are comparable BEFORE their counts are compared
  * a high missing-file ratio raises an explicit incomplete-tree warning

USAGE
    python3 check_links.py ARTIFACT.md [--root DIR] [--git] [--net] [--strict]
    python3 check_links.py --all --root . --git

    --root    directory relative links resolve against (default: artifact dir)
    --git     verify targets are tracked; report untracked separately
    --net     check external URLs over HTTP
    --strict  treat UNTRACKED FILE as failure (default on when --git)
    --all     check every tracked .md under --root

EXIT
    0 clean · 1 broken links · 2 usage/IO error
"""

import argparse
import os
import re
import subprocess
import sys
from collections import Counter, defaultdict

VERSION = "0.2"

LINK_RE = re.compile(r'\[(?P<text>[^\]]*)\]\((?P<url>[^)\s]+)(?:\s+"[^"]*")?\)')
ATX_RE = re.compile(r'^(?P<hashes>#{1,6})\s+(?P<text>.+?)\s*#*\s*$')
FENCE_RE = re.compile(r'^\s*(```|~~~)')

BROKEN_FRAGMENT = 'BROKEN FRAGMENT'
MISSING_FILE = 'MISSING FILE'
UNTRACKED_FILE = 'UNTRACKED FILE'
EXTERNAL_DEAD = 'EXTERNAL UNREACHABLE'


def _git(root, *args):
    try:
        r = subprocess.run(['git', '-C', root, *args],
                           capture_output=True, text=True, timeout=30)
        return r.stdout.strip() if r.returncode == 0 else None
    except Exception:
        return None


def git_context(root):
    top = _git(root, 'rev-parse', '--show-toplevel')
    if not top:
        return None, None, None
    commit = _git(root, 'rev-parse', 'HEAD') or 'unknown'
    dirty = bool(_git(root, 'status', '--porcelain'))
    listing = _git(root, 'ls-files') or ''
    tracked = {os.path.normpath(os.path.join(top, rel))
               for rel in listing.splitlines() if rel}
    return commit, dirty, tracked


def slugify(text):
    s = text.strip().lower()
    s = re.sub(r'`([^`]*)`', r'\1', s)
    s = re.sub(r'\[([^\]]*)\]\([^)]*\)', r'\1', s)
    s = re.sub(r'[*_~]', '', s)
    s = re.sub(r'[^\w\s-]', '', s, flags=re.UNICODE)
    return re.sub(r'\s+', '-', s)


def headings_of(path):
    slugs, seen = set(), Counter()
    try:
        lines = open(path, encoding='utf-8', errors='replace').read().splitlines()
    except OSError:
        return slugs
    in_fence = in_front = False
    for i, line in enumerate(lines):
        if i == 0 and line.strip() == '---':
            in_front = True
            continue
        if in_front:
            if line.strip() == '---':
                in_front = False
            continue
        if FENCE_RE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        m = ATX_RE.match(line)
        if not m:
            continue
        base = slugify(m.group('text'))
        if not base:
            continue
        n = seen[base]
        seen[base] += 1
        slugs.add(base if n == 0 else f'{base}-{n}')
    return slugs


def body_links(path):
    lines = open(path, encoding='utf-8', errors='replace').read().splitlines()
    in_fence = in_front = False
    for i, line in enumerate(lines, 1):
        if i == 1 and line.strip() == '---':
            in_front = True
            continue
        if in_front:
            if line.strip() == '---':
                in_front = False
            continue
        if FENCE_RE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        for m in LINK_RE.finditer(line):
            yield i, m.group('text'), m.group('url')


def check_one(artifact, root, tracked, do_net, cache):
    stats, problems = Counter(), []
    self_slugs = cache.setdefault(artifact, headings_of(artifact))

    for lineno, _t, url in body_links(artifact):
        if url.startswith(('http://', 'https://')):
            stats['external'] += 1
            if do_net:
                import urllib.request
                try:
                    req = urllib.request.Request(
                        url, method='HEAD',
                        headers={'User-Agent': 'MIWikiAI-linkcheck'})
                    code = urllib.request.urlopen(req, timeout=15).status
                    if code >= 400:
                        problems.append((EXTERNAL_DEAD, lineno, url, f'HTTP {code}'))
                    else:
                        stats['ok'] += 1
                except Exception as e:
                    problems.append((EXTERNAL_DEAD, lineno, url, type(e).__name__))
            continue

        if url.startswith('mailto:'):
            stats['mailto'] += 1
            continue

        path_part, _, frag = url.partition('#')

        if not path_part:
            stats['same_file'] += 1
            if frag and frag not in self_slugs:
                problems.append((BROKEN_FRAGMENT, lineno, url,
                                 'no such heading in this file'))
            else:
                stats['ok'] += 1
            continue

        stats['cross_file'] += 1
        target = os.path.normpath(os.path.join(os.path.dirname(artifact), path_part))

        if not os.path.exists(target):
            problems.append((MISSING_FILE, lineno, url, os.path.relpath(target, root)))
            continue

        if tracked is not None and target not in tracked:
            problems.append((UNTRACKED_FILE, lineno, url,
                             f'{os.path.relpath(target, root)} exists here but is NOT committed'))
            continue

        if not frag:
            stats['ok'] += 1
            continue

        slugs = cache.setdefault(target, headings_of(target))
        if frag not in slugs:
            problems.append((BROKEN_FRAGMENT, lineno, url,
                             f'no heading "#{frag}" in {os.path.relpath(target, root)}'))
        else:
            stats['ok'] += 1

    return stats, problems


def run(artifacts, root, use_git, do_net, strict):
    root = os.path.abspath(root)
    commit = dirty = tracked = None
    if use_git:
        commit, dirty, tracked = git_context(root)
        if commit is None:
            print('WARNING: --git requested but this is not a git working tree; '
                  'untracked detection disabled\n', file=sys.stderr)

    md_on_disk = 0
    for dirpath, dirnames, files in os.walk(root):
        dirnames[:] = [d for d in dirnames if d != '.git']
        md_on_disk += sum(1 for f in files if f.endswith('.md'))

    print(f'=== MIWikiAI link check v{VERSION} ===')
    print('--- RUN FINGERPRINT (compare this BEFORE comparing counts) ---')
    print(f'  root             : {root}')
    print(f'  git commit       : {commit or "n/a"}')
    print(f'  working tree     : '
          f'{"DIRTY - uncommitted changes present" if dirty else ("clean" if commit else "n/a")}')
    print(f'  tracked files    : {len(tracked) if tracked is not None else "not checked (use --git)"}')
    print(f'  .md files on disk: {md_on_disk}')
    print(f'  artifacts checked: {len(artifacts)}')
    print('-' * 74)

    cache, grand, by_kind, failed = {}, Counter(), defaultdict(list), []

    for art in artifacts:
        art = os.path.abspath(art)
        if not os.path.isfile(art):
            print(f'ERROR: not a file: {art}', file=sys.stderr)
            return 2
        stats, problems = check_one(art, root, tracked, do_net, cache)
        grand.update(stats)
        rel = os.path.relpath(art, root)
        total = stats['same_file'] + stats['cross_file'] + stats['external'] + stats['mailto']
        hard = [p for p in problems if p[0] != UNTRACKED_FILE or strict]
        flag = 'FAIL' if hard else ('WARN' if problems else ' ok ')
        print(f'[{flag}] {rel} - {total} link(s), {len(problems)} problem(s)')
        for k, ln, url, det in problems:
            by_kind[k].append((rel, ln, url, det))
        if hard:
            failed.append(rel)

    print('-' * 74)

    for kind in (BROKEN_FRAGMENT, MISSING_FILE, UNTRACKED_FILE, EXTERNAL_DEAD):
        items = by_kind.get(kind)
        if not items:
            continue
        print()
        print(f'### {kind}  ({len(items)})')
        if kind == MISSING_FILE:
            print('    Target absent from this tree. Either the link is wrong, or this')
            print('    tree is incomplete. Check the RUN FINGERPRINT before acting.')
        if kind == UNTRACKED_FILE:
            print('    Target exists on THIS disk but is not committed. The link works')
            print('    for you and is broken for everyone else, reviewers included.')
        for rel, ln, url, det in items:
            print(f'  {rel}:{ln}')
            print(f'      {url}')
            print(f'      -> {det}')

    n_missing = len(by_kind.get(MISSING_FILE, []))
    if grand['cross_file'] and n_missing / grand['cross_file'] > 0.3:
        print()
        print(f'!!! INCOMPLETE-TREE WARNING ({n_missing}/{grand["cross_file"]} '
              'cross-file targets missing).')
        print('    A partial checkout produces exactly this pattern. Confirm the RUN')
        print('    FINGERPRINT matches the reference run before reporting these counts.')

    print()
    hard_total = sum(len(v) for k, v in by_kind.items() if k != UNTRACKED_FILE or strict)
    if hard_total:
        print(f'Link check FAILED: {hard_total} problem(s) in {len(failed)} file(s)')
        return 1
    if grand['same_file'] + grand['cross_file'] + grand['external'] == 0:
        print('Link check PASSED - but zero links found. For a cross-referenced wiki')
        print('page that is a vacuous pass, not a clean one.')
        return 0
    print('Link check PASSED')
    return 0


def main():
    ap = argparse.ArgumentParser(description='MIWikiAI link checker')
    ap.add_argument('artifacts', nargs='*')
    ap.add_argument('--root', default=None)
    ap.add_argument('--git', action='store_true')
    ap.add_argument('--net', action='store_true')
    ap.add_argument('--strict', action='store_true', default=None)
    ap.add_argument('--all', action='store_true')
    a = ap.parse_args()

    root = os.path.abspath(a.root) if a.root else (
        os.path.dirname(os.path.abspath(a.artifacts[0])) if a.artifacts else os.getcwd())

    arts = list(a.artifacts)
    if a.all:
        _, _, tracked = git_context(root)
        if tracked is None:
            print('ERROR: --all needs a git working tree', file=sys.stderr)
            sys.exit(2)
        arts = sorted(p for p in tracked if p.endswith('.md'))
    if not arts:
        ap.error('give an artifact, or use --all')

    strict = a.strict if a.strict is not None else a.git
    sys.exit(run(arts, root, a.git, a.net, strict))


if __name__ == '__main__':
    main()
