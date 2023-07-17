---
title: DeltaMergeIntoNotMatchedClause
subtitle: WHEN NOT MATCHED Clause
---

# DeltaMergeIntoNotMatchedClause &mdash; WHEN NOT MATCHED Clause

`DeltaMergeIntoNotMatchedClause` is an extension of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md) abstraction for [WHEN NOT MATCHED clauses](#implementations).

## Implementations

* [DeltaMergeIntoNotMatchedInsertClause](DeltaMergeIntoNotMatchedInsertClause.md)

??? note "Sealed Trait"
    `DeltaMergeIntoNotMatchedClause` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
