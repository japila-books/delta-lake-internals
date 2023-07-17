---
title: DeltaMergeIntoNotMatchedBySourceClause
subtitle: WHEN NOT MATCHED BY SOURCE Clause
---

# DeltaMergeIntoNotMatchedBySourceClause &mdash; WHEN NOT MATCHED BY SOURCE Clause

`DeltaMergeIntoNotMatchedBySourceClause` is an extension of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md) abstraction for [WHEN NOT MATCHED BY SOURCE clauses](#implementations).

## Implementations

* [DeltaMergeIntoNotMatchedBySourceDeleteClause](DeltaMergeIntoNotMatchedBySourceDeleteClause.md)
* [DeltaMergeIntoNotMatchedBySourceUpdateClause](DeltaMergeIntoNotMatchedBySourceUpdateClause.md)

??? note "Sealed Trait"
    `DeltaMergeIntoNotMatchedBySourceClause` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
