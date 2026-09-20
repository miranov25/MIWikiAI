# MIWikiAI copy/paste delivery convention

## Standard shell setup

Use these environment variables in coder/reviewer instructions:

```bash
export MIWIKIAI="${MIWIKIAI:-$HOME/github/MIWikiAI}"
export Downloads="${Downloads:-$HOME/Downloads}"

source "$MIWIKIAI/scripts/miwikiai_env.sh"
source "$MIWIKIAI/scripts/install_by_md5.sh"
```

Canonical meanings:

```text
$MIWIKIAI            MIWikiAI repository root
$Downloads           browser/download directory
$MIWIKIAI_SCRIPTS    $MIWIKIAI/scripts
$MIWIKIAI_O2         $MIWIKIAI/Alice/code/O2
$MIWIKIAI_O2_REVIEWS $MIWIKIAI/Alice/code/O2/reviews
```

Do not hard-code a user's home directory in handoff instructions.

## Standard reviewed-file installation

The coder/reviewer should provide the **exact expected MD5**.

Example:

```bash
source "$MIWIKIAI/scripts/install_by_md5.sh"

install_by_md5   "$Downloads/TPC_SourceOfTruth_v0_4_1.md"   "$MIWIKIAI/Alice/TPC_SourceOfTruth_v0_4_1.md"   <EXPECTED_MD5>
```

`install_by_md5` verifies the source MD5 before copying, backs up an existing
destination, copies the file, and verifies the destination MD5 again.

If the browser may have created `(1)`, `(2)`, etc.:

```bash
install_newest_by_md5   'TPC_SourceOfTruth_v0_4_1*.md'   "$MIWIKIAI/Alice/TPC_SourceOfTruth_v0_4_1.md"   <EXPECTED_MD5>
```

## Standard reference check

Before a command uses an important installed/reference file:

```bash
check_ref   "$MIWIKIAI/Alice/TPC_SourceOfTruth_v0_4_1.md"   <EXPECTED_MD5>
```

For higher-value references, provide both digests:

```bash
check_ref   "$MIWIKIAI/Alice/TPC_SourceOfTruth_v0_4_1.md"   <EXPECTED_MD5>   <EXPECTED_SHA256>
```

## Handoff-writing rule

For each delivered file, provide:

```text
source filename in $Downloads
destination under $MIWIKIAI
expected MD5
optional SHA-256 for important/canonical references
```

Then give a ready-to-paste `install_by_md5` or `install_newest_by_md5` command.

Keep **byte checks** and **later execution/commit commands** in separate copy/paste blocks.
