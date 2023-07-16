---
title: DeltaMergeIntoMatchedClause
subtitle: WHEN MATCHED Clause
---

# DeltaMergeIntoMatchedClause &mdash; WHEN MATCHED Clause

`DeltaMergeIntoMatchedClause` is an extension of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md) abstraction for [WHEN MATCHED clauses](#implementations).

## Implementations

* [DeltaMergeIntoMatchedDeleteClause](DeltaMergeIntoMatchedDeleteClause.md)
* [DeltaMergeIntoMatchedUpdateClause](DeltaMergeIntoMatchedUpdateClause.md)

??? note "Sealed Trait"
    `DeltaMergeIntoMatchedClause` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
