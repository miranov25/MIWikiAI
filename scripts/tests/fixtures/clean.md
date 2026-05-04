---
wiki_id: O2_TestSymbol_API
title: "Test artifact — clean"
project: MIWikiAI / ALICE
folder: tests
---

# Test artifact (clean)

## TL;DR

| Symbol | Description |
|---|---|
| `Foo` | a class, prod_usage_count=10 in scope-table summary |
| `Bar` | another class, prod_usage_count=5 |

This scope-table cell mentions prod_usage_count=10 but it is NOT a Signal block.

## 4. Per-symbol API

### 4.1 `Foo` (class)

**Defined in:** `Foo.h:L100`
**Signal:** prod_usage_count=10, workflows_direct=2, churn_12m=0

The class Foo has well-defined behavior.

### 4.2 `Bar` (class)

**Defined in:** `Bar.h:L50`
**Signal:** prod_usage_count=5, workflows_direct=1, churn_12m=0

Bar is also well-behaved.
