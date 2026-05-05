---
wiki_id: O2_TestSymbol_ParaphrasedVerbatim
title: "Test artifact — VERBATIM block paraphrased, not char-exact (cycle-4 CONV-δ class)"
---

# Test artifact (paraphrased VERBATIM)

## 4. Per-symbol API

### 4.1 `EnumTest` (class)

**Signal:** prod_usage_count=10, confidence=high, churn_12m=0, workflows_direct=2, collision=false, uniqueness=unique

The enum is defined here:

[VERBATIM mock_source.h:L1-L3]
```cpp
enum States {
  kA, /* paraphrased comment — does NOT match source */
  kB
};
```

The cited source's L1-L3 has different content (different comment text + extra value).
v1.3 prefilter must diff the block against the source character-by-character and FAIL.
