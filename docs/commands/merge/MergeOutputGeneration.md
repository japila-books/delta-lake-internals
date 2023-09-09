# MergeOutputGeneration

`MergeOutputGeneration` is an extension of the [MergeIntoCommandBase](MergeIntoCommandBase.md) abstraction for [merge output generators](#implementations) with logic to transform the merge clauses into expressions that can be evaluated to obtain the (possibly optimized) output of the [merge command](index.md).

## Implementations

* [ClassicMergeExecutor](ClassicMergeExecutor.md)
* [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)

## Appending Precomputed Clause Conditions to Source DataFrame { #generatePrecomputedConditionsAndDF }

```scala
generatePrecomputedConditionsAndDF(
  sourceDF: DataFrame,
  clauses: Seq[DeltaMergeIntoClause]): (DataFrame, Seq[DeltaMergeIntoClause])
```

`generatePrecomputedConditionsAndDF` [rewrites conditional clauses](#rewriteCondition) of all the given [DeltaMergeIntoClause](DeltaMergeIntoClause.md)s

??? note "rewriteCondition"
    [rewriteCondition](#rewriteCondition) populates an internal `preComputedClauseConditions` registry of pairs of a generated column name and a rewritten condition for every conditional clause (i.e., [DeltaMergeIntoClause](DeltaMergeIntoClause.md) with a [condition](DeltaMergeIntoClause.md#condition)).

`generatePrecomputedConditionsAndDF` adds the generated columns (of the conditional clauses) to the given `sourceDF` (to precompute clause conditions).

In the end, `generatePrecomputedConditionsAndDF` returns a pair of the following:

1. The given `sourceDF` with the generated columns
1. The given `clauses` with rewritten conditions

---

`generatePrecomputedConditionsAndDF` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts) (to [generateInsertsOnlyOutputDF](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputDF))

### Rewriting Conditional Clause { #rewriteCondition }

```scala
rewriteCondition[T <: DeltaMergeIntoClause](
  clause: T): T
```

`rewriteCondition` rewrites the [condition](DeltaMergeIntoClause.md#condition) of the given [DeltaMergeIntoClause](DeltaMergeIntoClause.md) to use a column name of the following pattern (with the [clauseType](DeltaMergeIntoClause.md#clauseType)):

```text
_[clauseType]_condition_[index]_
```

`rewriteCondition` adds a pair of the new name and the condition in a local `preComputedClauseConditions` registry (of the owning [generatePrecomputedConditionsAndDF](#generatePrecomputedConditionsAndDF)).

## generateWriteAllChangesOutputCols { #generateWriteAllChangesOutputCols }

```scala
generateWriteAllChangesOutputCols(
  targetOutputCols: Seq[Expression],
  outputColNames: Seq[String],
  noopCopyExprs: Seq[Expression],
  clausesWithPrecompConditions: Seq[DeltaMergeIntoClause],
  cdcEnabled: Boolean,
  shouldCountDeletedRows: Boolean = true): IndexedSeq[Column]
```

`generateWriteAllChangesOutputCols` generates `CaseWhen` expressions for every column in the given `outputColNames`.

`generateWriteAllChangesOutputCols` generates expressions to use in `CaseWhen`s using [generateAllActionExprs](#generateAllActionExprs) followed by [generateClauseOutputExprs](#generateClauseOutputExprs).

`generateWriteAllChangesOutputCols` [generateAllActionExprs](#generateAllActionExprs) for the following [DeltaMergeIntoClause](DeltaMergeIntoClause.md)s separately (among the given `clausesWithPrecompConditions`):

* [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)s
* [DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md)s
* [DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md)s

---

`generateWriteAllChangesOutputCols` [generateAllActionExprs](#generateAllActionExprs) for [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)s only (among the given `clausesWithPrecompConditions`) followed by [generateClauseOutputExprs](#generateClauseOutputExprs) (`matchedExprs`).

`generateWriteAllChangesOutputCols` [generateAllActionExprs](#generateAllActionExprs) for [DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md)s only (among the given `clausesWithPrecompConditions`) followed by [generateClauseOutputExprs](#generateClauseOutputExprs) (`notMatchedExprs`).

`generateWriteAllChangesOutputCols` [generateAllActionExprs](#generateAllActionExprs) for [DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md)s only (among the given `clausesWithPrecompConditions`) followed by [generateClauseOutputExprs](#generateClauseOutputExprs) (`notMatchedBySourceExprs`).

`generateWriteAllChangesOutputCols` creates the following two expressions:

1. `ifSourceRowNull` that is `true` when [\_source_row_present_](MergeIntoCommandBase.md#SOURCE_ROW_PRESENT_COL) is `null`
1. `ifTargetRowNull` that is `true` when [\_target_row_present_](MergeIntoCommandBase.md#TARGET_ROW_PRESENT_COL) is `null`

`generateWriteAllChangesOutputCols` creates a `CaseWhen` expression for every column in the given `outputColNames` as follows:

* `ifSourceRowNull` expression is `true`, use `notMatchedBySourceExprs`
* `ifTargetRowNull` expression is `true`, use `notMatchedExprs`
* Otherwise, use `matchedExprs`

In the end, `generateWriteAllChangesOutputCols` prints out the following DEBUG message to the logs:

```text
writeAllChanges: join output expressions
  [outputCols1]
  [outputCols2]
  ...
```

---

`generateWriteAllChangesOutputCols` is used when:

* `ClassicMergeExecutor` is requested to [write out merge changes](ClassicMergeExecutor.md#writeAllChanges)

### generateAllActionExprs { #generateAllActionExprs }

```scala
generateAllActionExprs(
  targetOutputCols: Seq[Expression],
  clausesWithPrecompConditions: Seq[DeltaMergeIntoClause],
  cdcEnabled: Boolean,
  shouldCountDeletedRows: Boolean): Seq[ProcessedClause]
```

`generateAllActionExprs`...FIXME

### generateClauseOutputExprs { #generateClauseOutputExprs }

```scala
generateClauseOutputExprs(
  numOutputCols: Integer,
  clauses: Seq[ProcessedClause],
  noopExprs: Seq[Expression]): Seq[Expression]
```

`generateClauseOutputExprs` considers the following cases based on the given `clauses`:

ProcessedClauses | Expressions Returned
-----------------|---------------------
 No `clauses` | The given `noopExprs`
 An unconditional clause being the first | The `actions` of the unconditional clause
 One clause | `If` expressions for every action of this clause
 Many clauses | `CaseWhen` expressions

In essence, `generateClauseOutputExprs` translates the given `clauses` into Catalyst `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/)).

---

When there is nothing to update or delete (there are empty `clauses` given), `generateClauseOutputExprs` does nothing and returns the given `noopExprs` expressions.

Otherwise, `generateClauseOutputExprs` checks how many `clauses` are there (and _some other conditions_) to generate the following expressions:

* The `actions` expressions of the only single clause (in `clauses`) when with no `condition`
* For a single clause (in `clauses`), as many `If` expressions as there are `actions`
* Many `CaseWhen` expressions

!!! note
    It is assumed that when the first clause (in `clauses`) is unconditional (no `condition`), it is the only clause.

In the end, `generateClauseOutputExprs` prints out the following DEBUG message to the logs:

```text
writeAllChanges: expressions
  [clauseExprs]
```

## generateCdcAndOutputRows { #generateCdcAndOutputRows }

```scala
generateCdcAndOutputRows(
  sourceDf: DataFrame,
  outputCols: Seq[Column],
  outputColNames: Seq[String],
  noopCopyExprs: Seq[Expression],
  deduplicateDeletes: DeduplicateCDFDeletes): DataFrame
```

`generateCdcAndOutputRows` is used by `ClassicMergeExecutor` to generate `preOutputDF` dataframe that is written out when requested to [write out merge changes](ClassicMergeExecutor.md#writeAllChanges) with [Change Data Feed](../../change-data-feed/index.md) enabled.
The dataframe to write out is as follows:

* Only [\_row_dropped_](MergeIntoCommandBase.md#ROW_DROPPED_COL) rows with `false` value
* No [\_row_dropped_](MergeIntoCommandBase.md#ROW_DROPPED_COL) column (it is dropped from the output)

??? note "Very Position-Sensitive"
    `generateCdcAndOutputRows` makes hard assumptions on which columns are on given positions (and so there are a lot of _magic numbers_ floating around).

    ## noopCopyExprs

    `noopCopyExprs` is a collection of the following expressions:

    * [Target output expressions](MergeIntoCommandBase.md#getTargetOutputCols) (i.e., the [target](MergeIntoCommandBase.md#target) output expressions followed by any new expressions due to schema evolution)
    * An expression to increment [numTargetRowsCopied](MergeIntoCommandBase.md#numTargetRowsCopied) metric
    * `CDC_TYPE_NOT_CDC` literal (with `null` value)

    Hence, `noopCopyExprs.dropRight(2)` gives the [target output expressions](MergeIntoCommandBase.md#getTargetOutputCols) (i.e., the [target](MergeIntoCommandBase.md#target) output expressions followed by any new expressions due to schema evolution)

    ## outputCols

    `outputCols` is an indexed collection that is generated using [generateWriteAllChangesOutputCols](#generateWriteAllChangesOutputCols).
    The names of `outputCols` can be displayed in the [logs](#logging) at DEBUG level. 

    * `outputCols.dropRight(1)`
    * `outputCols(outputCols.length - 2)`

    ## outputColNames

    * `outputColNames.dropRight(1)`

`generateCdcAndOutputRows` drops the last column from the given `outputCols` and adds `_change_type` column with a [special sentinel value](../../change-data-feed/CDCReader.md#CDC_TYPE_NOT_CDC) (`null`).

!!! danger "FIXME What's at the last position?"

!!! danger "FIXME What's at the second last position?"

`generateCdcAndOutputRows` creates a new `_row_dropped_` column that negates the values in the column that is just before `_change_type` column (the second from the end of the given `outputCols`) and becomes the _new second from the end_ (replaces the _former second from the end_).

`generateCdcAndOutputRows` drops two last columns in the given `noopCopyExprs` with the following new columns (in that order):

1. A `false` literal
1. A literal with [update_preimage](../../change-data-feed/CDCReader.md#CDC_TYPE_UPDATE_PREIMAGE) value

`generateCdcAndOutputRows` makes the column names to be aliases from the given `outputColNames` (`updatePreimageCdcOutput`).

`generateCdcAndOutputRows` creates a new column (`cdcArray`) with a `CaseWhen` expression based on the last column of the given `outputCols` (`cdcTypeCol`). Every `CaseWhen` case creates an `array` for the value of the last column (in the given `outputCols`):

* [insert](../../change-data-feed/CDCReader.md#CDC_TYPE_INSERT)
* [update_postimage](../../change-data-feed/CDCReader.md#CDC_TYPE_UPDATE_POSTIMAGE)
* [delete](../../change-data-feed/CDCReader.md#CDC_TYPE_DELETE)

`generateCdcAndOutputRows` creates a new column (`cdcToMainDataArray`) with an `If` expression based on the value of `packedCdc._change_type` column.
If the value is one of the following literals, the `If` expression gives an array with `packedCdc` column and _something extra_:

* [insert](../../change-data-feed/CDCReader.md#CDC_TYPE_INSERT)
* [update_postimage](../../change-data-feed/CDCReader.md#CDC_TYPE_UPDATE_POSTIMAGE)

Otherwise, the `If` expression gives an array with `packedCdc` column alone.

In the end, `generateCdcAndOutputRows` [deduplicateCDFDeletes](#deduplicateCDFDeletes) if [deduplicateDeletes is enabled](DeduplicateCDFDeletes.md#enabled).
Otherwise, `generateCdcAndOutputRows` [packAndExplodeCDCOutput](#packAndExplodeCDCOutput).

---

`generateCdcAndOutputRows` is used when:

* `ClassicMergeExecutor` is requested to [write out merge changes](ClassicMergeExecutor.md#writeAllChanges) (with [Change Data Feed](../../change-data-feed/index.md) enabled)

### packAndExplodeCDCOutput { #packAndExplodeCDCOutput }

```scala
packAndExplodeCDCOutput(
  sourceDf: DataFrame,
  cdcArray: Column,
  cdcToMainDataArray: Column,
  outputColNames: Seq[String],
  dedupColumns: Seq[Column]): DataFrame
```

In essence, `packAndExplodeCDCOutput` explodes `projectedCDC` and `cdcToMainDataArray` columns, and extracts the given `outputColNames` columns from the `packedData` struct.

---

`packAndExplodeCDCOutput` does the following with the given `sourceDf` dataframe (in the order):

1. Selects the given `cdcArray` column under `projectedCDC` alias and all the given `dedupColumns` columns
1. Explodes the `projectedCDC` column (which is the given `cdcArray` column) under `packedCdc` alias alongside all the given `dedupColumns` columns
1. Explodes the given `cdcToMainDataArray` column under `packedData` alias alongside all the given `dedupColumns` columns
1. Selects the given `outputColNames` columns from the `packedData` struct (_flattens_ them using `packedData.[name]` selector) alongside all the given `dedupColumns` columns

### deduplicateCDFDeletes { #deduplicateCDFDeletes }

```scala
deduplicateCDFDeletes(
  deduplicateDeletes: DeduplicateCDFDeletes,
  df: DataFrame,
  cdcArray: Column,
  cdcToMainDataArray: Column,
  outputColNames: Seq[String]): DataFrame
```

!!! note "WHEN NOT MATCHED THEN INSERT Sensitivity"
    `deduplicateCDFDeletes` is sensitive (_behaves differently_) to merges with [WHEN NOT MATCHED THEN INSERT clauses](DeduplicateCDFDeletes.md#includesInserts) (based on the given [DeduplicateCDFDeletes](DeduplicateCDFDeletes.md)).

`deduplicateCDFDeletes` finds out the deduplication columns (`dedupColumns`) that include the following:

* `_target_row_index_`
* `_source_row_index` only when this merge [includes WHEN NOT MATCHED THEN INSERT clauses](DeduplicateCDFDeletes.md#includesInserts)

`deduplicateCDFDeletes` [packAndExplodeCDCOutput](#packAndExplodeCDCOutput) (and creates a new `cdcDf` dataframe).

With [WHEN NOT MATCHED THEN INSERT clauses](DeduplicateCDFDeletes.md#includesInserts), `deduplicateCDFDeletes` overwrites `_target_row_index_` column (in the `cdcDf` dataframe) to be the value of `_source_row_index` column for rows with `null`s.

`deduplicateCDFDeletes` deduplicates rows based on `_target_row_index_` and `_change_type` columns.

In the end, `deduplicateCDFDeletes` drops `_target_row_index_` and `_source_row_index` columns.

## Logging

`MergeOutputGeneration` is an abstract class and logging is configured using the logger of the [implementations](#implementations) (that boils down to [MergeIntoCommand](MergeIntoCommand.md#logging)).
