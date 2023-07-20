# ClassicMergeExecutor

`ClassicMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [MERGE command](index.md) (when requested to [run merge](MergeIntoCommand.md#runMerge)) when one of the following holds:

* MERGE is not [insert only](MergeIntoCommandBase.md#isInsertOnly) (contains `WHEN NOT MATCHED` clauses)
* [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is disabled (that would lead to use [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) instead)

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): (Seq[AddFile], DeduplicateCDFDeletes)
```

`findTouchedFiles` registers an internal `SetAccumulator` with `internal.metrics.MergeIntoDelta.touchedFiles` name.

`findTouchedFiles` creates a non-deterministic UDF that records the names of touched files (adds them to the accumulator).

With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) with [getTargetOnlyPredicates](MergeIntoCommandBase.md#getTargetOnlyPredicates). Otherwise, `findTouchedFiles` requests it to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) with an accept-all predicate.

`findTouchedFiles` determines the join type (`joinType`).
With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` uses `INNER` join type. Otherwise, it is `RIGHT_OUTER` join.

!!! note "FIXME Show the diagrams of the different joins"

`findTouchedFiles` determines the matched predicate (`matchedPredicate`).
When [isMatchedOnly](MergeIntoCommandBase.md#isMatchedOnly), `findTouchedFiles` converts the [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses) to their [condition](DeltaMergeIntoClause.md#condition)s, if defined, or falls back to accept-all predicate and then reduces to `Or` expressions. Otherwise, `findTouchedFiles` uses accept-all predicate for the matched predicate.

`findTouchedFiles`...FIXME (finished at `sourceDF`)

---

`findTouchedFiles` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge)

## Writing Out All Merge Changes (to Delta Table) { #writeAllChanges }

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile],
  deduplicateCDFDeletes: DeduplicateCDFDeletes): Seq[FileAction]
```

`writeAllChanges` [records this merge operation](MergeIntoCommandBase.md#recordMergeOperation) with the following:

Property | Value
---------|------
extraOpType | <ul><li>**writeAllUpdatesAndDeletes** for [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge)<li>**writeAllChanges** otherwise</ul>
status | **MERGE operation - Rewriting [filesToRewrite] files**
sqlMetricName | `rewriteTimeMs`

??? note "CDF Generation"
    `writeAllChanges` asserts that one of the following holds:

    1. CDF generation is disabled (based on the given `DeduplicateCDFDeletes` flag)
    1. [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) is enabled

    Otherwise, `writeAllChanges` reports an `IllegalArgumentException`:

    ```text
    CDF delete duplication is enabled but overall the CDF generation is disabled
    ```

`writeAllChanges` creates a `DataFrame` for the [target plan](#buildTargetPlanWithFiles) with the given [AddFile](../../AddFile.md)s to rewrite (`filesToRewrite`) (and no `columnsToDrop`).

`writeAllChanges` determines the join type based on [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge):

* `rightOuter` when enabled
* `fullOuter` otherwise

??? note "`shouldOptimizeMatchedOnlyMerge` Used Twice"
    [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge) is used twice for the following:

    1. `extraOpType` to [record this merge operation](MergeIntoCommandBase.md#recordMergeOperation)
    1. The join type

    shouldOptimizeMatchedOnlyMerge | extraOpType | joinType
    -------------------------------|-------------|---------
    `true` | **writeAllUpdatesAndDeletes** | RIGHT OUTER
    `false` | **writeAllChanges** | FULL OUTER

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges using [joinType] join:
  source.output: [source]
  target.output: [target]
  condition: [condition]
  newTarget.output: [baseTargetDF]
```

`writeAllChanges` [creates Catalyst expressions to increment SQL metrics](MergeIntoCommandBase.md#incrementMetricAndReturnBool):

Metric Name | valueToReturn
------------|--------------
 [numSourceRowsInSecondScan](MergeIntoCommandBase.md#numSourceRowsInSecondScan) | `true`
 [numTargetRowsCopied](MergeIntoCommandBase.md#numTargetRowsCopied) | `false`

`writeAllChanges` creates a DataFrame (`joinedDF`):

1. `writeAllChanges` adds an extra column `_source_row_index` (with `monotonically_increasing_id` expression) to the [source dataframe](MergeIntoMaterializeSource.md#getSourceDF) (possibly materialized) when the given `DeduplicateCDFDeletes` is enabled and `includesInserts`. The goal is to identify inserted rows during the cdf deleted rows deduplication.
1. `writeAllChanges` adds an extra column `_source_row_present_` (with the expression to increment the [numSourceRowsInSecondScan](MergeIntoCommandBase.md#numSourceRowsInSecondScan) metric) to `sourceDF` (`left`)
1. `writeAllChanges` adds an extra column `_target_row_present_` (with `true` value) to `baseTargetDF` (`targetDF`)
1. With `DeduplicateCDFDeletes` enabled, `writeAllChanges` adds an extra column `_target_row_index_` (with `monotonically_increasing_id` expression) to `targetDF` (`right`)
1. In the end, the left and right DataFrames are joined (using `DataFrame.join` operator) with [condition](MergeIntoCommandBase.md#condition) as the join condition and the determined join type (`rightOuter` or `fullOuter`)

!!! note "FIXME Explain why all the above columns are needed"

`writeAllChanges` [generatePrecomputedConditionsAndDF](#generatePrecomputedConditionsAndDF) with the joined DataFrame and the given merge clauses ([matchedClauses](MergeIntoCommandBase.md#matchedClauses), [notMatchedClauses](MergeIntoCommandBase.md#notMatchedClauses), [notMatchedBySourceClauses](MergeIntoCommandBase.md#notMatchedBySourceClauses)).

`writeAllChanges` generates the output columns (`outputCols`):

1. `writeAllChanges` [determines the target output columns](MergeIntoCommandBase.md#getTargetOutputCols) (`targetOutputCols`)
1. `writeAllChanges` adds one extra `_row_dropped_` possibly with another `_change_type` extra column if [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) to the target output columns (`outputColNames`)
1. `writeAllChanges` adds the expression to increment the [incrNoopCountExpr](#incrNoopCountExpr) metric possibly with another sentinel `null` expression if [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) to the target output columns (`noopCopyExprs`)
1. In the end, `writeAllChanges` [generateWriteAllChangesOutputCols](MergeOutputGeneration.md#generateWriteAllChangesOutputCols)

`writeAllChanges` creates an output DataFrame (`outputDF`) based on [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled):

1. With CDC enabled, `writeAllChanges`...FIXME
1. Otherwise, `writeAllChanges`...FIXME

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges: join output plan:
[outputDF]
```

`writeAllChanges` [writes out](MergeIntoCommandBase.md#writeFiles) the `outputDF` DataFrame (that gives [FileAction](../../FileAction.md)s).

In the end, `writeAllChanges` updates the [metrics](MergeIntoCommandBase.md#metrics).

---

`writeAllChanges` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) (for non [isInsertOnly](MergeIntoCommandBase.md#isInsertOnly) or [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) disabled)

## Logging

`ClassicMergeExecutor` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
