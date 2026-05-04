---
wiki_id: O2_TestSymbol_Fabrication
title: "Test artifact — fabrication"
project: MIWikiAI / ALICE
folder: tests
---

# Test artifact (with fabrication)

## 4. Per-symbol API

### 4.1 `Foo` (class)

**Defined in:** `Foo.h:L100`
**Signal:** prod_usage_count=10, workflows_direct=2, churn_12m=0

The enum `EParamProvenance` has values {`kCODE`, `kCCDB`, `kRT`, `kRTF`, `kCCDBPRIO`, `kEXIM`}.

This is a FABRICATION — kRTF, kCCDBPRIO, kEXIM do NOT exist in real source.

The default order is: defaults < CCDB < CLI, but `kCCDBPRIO` flips this. (Also fabricated.)
