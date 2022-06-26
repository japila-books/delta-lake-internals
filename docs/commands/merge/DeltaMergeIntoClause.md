# DeltaMergeIntoClause

`DeltaMergeIntoClause` is an [extension](#contract) of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) abstraction for [WHEN clauses](#implementations).

## Contract

### <span id="actions"> Actions

```scala
actions: Seq[Expression]
```

### <span id="condition"> Condition

```scala
condition: Option[Expression]
```

## Implementations

* [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md)
* [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)

??? note "Sealed Trait"
    `DeltaMergeIntoClause` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

## <span id="verifyActions"> Verifing Actions

```scala
verifyActions(): Unit
```

`verifyActions` goes over the [actions](#actions) and makes sure that they are either `UnresolvedStar`s ([Spark SQL]({{ book.spark_sql }}/expressions/UnresolvedStar)) or [DeltaMergeAction](DeltaMergeAction.md)s.

For unsupported actions, `verifyActions` throws an `IllegalArgumentException`:

```text
Unexpected action expression [action] in [this]
```

`verifyActions` is used when:

* `DeltaMergeInto` is [created](DeltaMergeInto.md#creating-instance)

## <span id="toActions"> toActions

```scala
toActions(
  assignments: Seq[Assignment]): Seq[Expression]
toActions(
  colNames: Seq[UnresolvedAttribute],
  exprs: Seq[Expression],
  isEmptySeqEqualToStar: Boolean = true): Seq[Expression]
```

`toActions` requires that the numbers of `colNames` and `exprs` are the same.

`toActions` creates one of the following expressions based on the given `colNames` and `isEmptySeqEqualToStar` flag:

1. `UnresolvedStar` for no `colNames` and `isEmptySeqEqualToStar` flag enabled
1. [DeltaMergeAction](DeltaMergeAction.md)s (for every pair of column name and expression based on `colNames` and `exprs`, respectively)

`toActions` is used when:

* `DeltaAnalysis` logical resolution rule is [executed](../../DeltaAnalysis.md#apply)
* `DeltaMergeMatchedActionBuilder` is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause), [insertAll](DeltaMergeMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeMatchedActionBuilder.md#addInsertClause)
* `DeltaMergeIntoUpdateClause` is [created](DeltaMergeIntoUpdateClause.md#creating-instance)

## <span id="resolvedActions"> resolvedActions

```scala
resolvedActions: Seq[DeltaMergeAction]
```

`resolvedActions`...FIXME

`resolvedActions` is used when:

* [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule is executed
* [MergeIntoCommand](MergeIntoCommand.md) is executed (and requested to [writeInsertsOnlyWhenNoMatchedClauses](MergeIntoCommand.md#writeInsertsOnlyWhenNoMatchedClauses) and [writeAllChanges](MergeIntoCommand.md#writeAllChanges))
