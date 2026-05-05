---
wiki_id: O2_TestSymbol_BareNameFab
title: "Test artifact — bare-name annotation fabrication (cycle-4 L521 class)"
project: MIWikiAI / ALICE
folder: tests
---

# Test artifact (with bare-name fabrication)

## 4. Per-symbol API

### 4.1 `printKeyValues` (method)

**Signal:** prod_usage_count=10, confidence=high, churn_12m=0, workflows_direct=2, collision=false, uniqueness=unique

The `showProv=true` flag adds a trailing `[CODE|CCDB|RT|RTF|CCDBPRIO|EXIM]` annotation per field.

This is the cycle-4 L521 fabrication pattern: bare-name `RTF`, `CCDBPRIO`, `EXIM` (no `k` prefix)
asserted as runtime annotation states. Real source has only 3 enum values, so annotations are `[CODE|CCDB|RT]`.
v1.3 prefilter must catch this with bare-name term matching.
