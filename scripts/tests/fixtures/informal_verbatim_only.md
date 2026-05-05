---
wiki_id: O2_TestSymbol_InformalVerbatimOnly
title: "Test artifact — informal verbatim forms only, no QRC bracket tags (cycle-4 CONV-γ class)"
---

# Test artifact (informal verbatim forms only)

## 4. Per-symbol API

### 4.1 `Foo` (class)

**Signal:** prod_usage_count=10, confidence=high, churn_12m=0, workflows_direct=2, collision=false, uniqueness=unique

Definition:

```cpp
// VERBATIM from mock_source.h L1-L3
enum States {
  kA,
  kB
};
```

Implementation note (verbatim from `mock_source.h` L1-L3):

```cpp
// some implementation here
```

This artifact uses ONLY informal forms (// VERBATIM and prose-form). No QRC-compliant
[VERBATIM <path>:L<a>-L<b>] bracket tags exist. v1.3 prefilter must WARN.
