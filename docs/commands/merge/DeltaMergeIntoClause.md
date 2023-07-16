# DeltaMergeIntoClause

`DeltaMergeIntoClause` is an [extension](#contract) of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) abstraction for [WHEN clauses](#implementations).

## Contract

### Actions { #actions }

```scala
actions: Seq[Expression]
```

`actions` [can only be the following expressions](#verifyActions):

* `UnresolvedStar`
* [DeltaMergeAction](DeltaMergeAction.md)

`actions` is either empty or given when [DeltaMergeIntoClause](#implementations)s are created.

`actions` is empty for the following [DeltaMergeIntoClause](#implementations)s:

* [DeltaMergeIntoMatchedDeleteClause](DeltaMergeIntoMatchedDeleteClause.md)
* [DeltaMergeIntoNotMatchedBySourceDeleteClause](DeltaMergeIntoNotMatchedBySourceDeleteClause.md)

`actions` is given when the following [DeltaMergeIntoClause](#implementations)s are created:

* [DeltaMergeIntoMatchedUpdateClause](DeltaMergeIntoMatchedUpdateClause.md)
* [DeltaMergeIntoNotMatchedInsertClause](DeltaMergeIntoNotMatchedInsertClause.md)
* [DeltaMergeIntoNotMatchedBySourceUpdateClause](DeltaMergeIntoNotMatchedBySourceUpdateClause.md)

### Clause Type { #clauseType }

```scala
clauseType: String
```

String representation of the clause type

DeltaMergeIntoClause | clauseType
---------------------|-----------
[DeltaMergeIntoMatchedUpdateClause](DeltaMergeIntoMatchedUpdateClause.md) | `Update`
[DeltaMergeIntoMatchedDeleteClause](DeltaMergeIntoMatchedDeleteClause.md) | `Delete`
[DeltaMergeIntoNotMatchedInsertClause](DeltaMergeIntoNotMatchedInsertClause.md) | `Insert`
[DeltaMergeIntoNotMatchedBySourceUpdateClause](DeltaMergeIntoNotMatchedBySourceUpdateClause.md) | `Update`
[DeltaMergeIntoNotMatchedBySourceDeleteClause](DeltaMergeIntoNotMatchedBySourceDeleteClause.md) | `Delete`

Used when:

* `DeltaMergeIntoClause` is requested for the [string representation](#toString)
* `MergePredicate` is created
* [PreprocessTableMerge](../../PreprocessTableMerge.md) is executed
* `MergeOutputGeneration` is requested to [generatePrecomputedConditionsAndDF](MergeOutputGeneration.md#generatePrecomputedConditionsAndDF)
* `MergeClauseStats` is created

### Condition { #condition }

```scala
condition: Option[Expression]
```

!!! note
    `condition` is always given when [DeltaMergeIntoClause](#implementations)s are created.

## Implementations

* [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)
* [DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md)
* [DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md)

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

---

`toActions` is used when:

* `DeltaAnalysis` logical resolution rule is [executed](../../DeltaAnalysis.md#apply)
* `DeltaMergeMatchedActionBuilder` is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause), [insertAll](DeltaMergeMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeMatchedActionBuilder.md#addInsertClause)
* `DeltaMergeIntoMatchedUpdateClause` is [created](DeltaMergeIntoMatchedUpdateClause.md#creating-instance)

## <span id="resolvedActions"> resolvedActions

```scala
resolvedActions: Seq[DeltaMergeAction]
```

`resolvedActions`...FIXME

`resolvedActions` is used when:

* [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule is executed
* [MergeIntoCommand](MergeIntoCommand.md) is executed (and requested to [writeInsertsOnlyWhenNoMatchedClauses](MergeIntoCommand.md#writeInsertsOnlyWhenNoMatchedClauses) and [writeAllChanges](MergeIntoCommand.md#writeAllChanges))
