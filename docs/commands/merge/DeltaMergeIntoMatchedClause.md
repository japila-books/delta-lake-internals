# DeltaMergeIntoMatchedClause

`DeltaMergeIntoMatchedClause` is an extension of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md) abstraction for [WHEN MATCHED clauses](#implementations).

## Implementations

* [DeltaMergeIntoDeleteClause](DeltaMergeIntoDeleteClause.md)
* [DeltaMergeIntoUpdateClause](DeltaMergeIntoUpdateClause.md)

??? note "Sealed Trait"
    `DeltaMergeIntoMatchedClause` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
