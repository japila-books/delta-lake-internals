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

`generateWriteAllChangesOutputCols`...FIXME

---

`generateWriteAllChangesOutputCols` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

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

`generateClauseOutputExprs`...FIXME

## generateCdcAndOutputRows { #generateCdcAndOutputRows }

```scala
generateCdcAndOutputRows(
  sourceDf: DataFrame,
  outputCols: Seq[Column],
  outputColNames: Seq[String],
  noopCopyExprs: Seq[Expression],
  deduplicateDeletes: DeduplicateCDFDeletes): DataFrame
```

`generateCdcAndOutputRows`...FIXME

---

`generateCdcAndOutputRows` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

### packAndExplodeCDCOutput { #packAndExplodeCDCOutput }

```scala
packAndExplodeCDCOutput(
  sourceDf: DataFrame,
  cdcArray: Column,
  cdcToMainDataArray: Column,
  outputColNames: Seq[String],
  dedupColumns: Seq[Column]): DataFrame
```

`packAndExplodeCDCOutput`...FIXME

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
* `_source_row_index` only when this merge [includes WHEN NOT MATCHED THEN INSERT clauses](DeduplicateCDFDeletes.md#includesInserts) (based on the given [DeduplicateCDFDeletes](DeduplicateCDFDeletes.md))

`deduplicateCDFDeletes` [packAndExplodeCDCOutput](#packAndExplodeCDCOutput) (that gives a new `cdcDf` dataframe).

With [WHEN NOT MATCHED THEN INSERT clauses](DeduplicateCDFDeletes.md#includesInserts), `deduplicateCDFDeletes` overwrites `_target_row_index_` column (in the `cdcDf` dataframe) to be the value of `_source_row_index` column for rows with `null`s.

`deduplicateCDFDeletes` deduplicates rows based on `_target_row_index_` and `_change_type` columns.

In the end, `deduplicateCDFDeletes` drops `_target_row_index_` and `_source_row_index` columns.
