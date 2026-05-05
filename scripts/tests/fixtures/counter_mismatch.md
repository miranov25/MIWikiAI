---
wiki_id: O2_TestSymbol_Mismatch
title: "Test artifact — counter mismatch"
project: MIWikiAI / ALICE
folder: tests
---

# Test artifact (counter mismatch)

## 4. Per-symbol API

### 4.1 `Foo` (class)

**Defined in:** `Foo.h:L100`
**Signal:** prod_usage_count=10, confidence=high, churn_12m=0, workflows_direct=99, collision=false, uniqueness=unique

In CSV, Foo has workflows_direct=2. So the claim of 99 is wrong — should be flagged.

### 4.2 `Bar` (class)

**Defined in:** `Bar.h:L50`
**Signal:** prod_usage_count=5, confidence=high, churn_12m=0, workflows_direct=1, collision=false, uniqueness=unique

Bar is correct.
