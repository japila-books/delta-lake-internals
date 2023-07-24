# ClassicMergeExecutor

`ClassicMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for "classic" execution of [MERGE command](index.md) (when requested to [run a merge](MergeIntoCommand.md#runMerge)) when one of the following holds:

* MERGE is not [insert only](index.md#insert-only-merges) (so there are [WHEN MATCHED](MergeIntoCommandBase.md#matchedClauses) or [WHEN NOT MATCHED BY SOURCE](MergeIntoCommandBase.md#notMatchedBySourceClauses) clauses)
* [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is disabled (that would lead to use [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) instead)

??? note "InsertOnlyMergeExecutor"
    When one of the above requirements is not met, [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) is used instead.

With `ClassicMergeExecutor` chosen, [MergeIntoCommand](MergeIntoCommand.md) starts by [finding data files to rewrite](#findTouchedFiles) and, only when there are any `AddFile`s found, requests `ClassicMergeExecutor` to [write out all merge changes to a target delta table](#writeAllChanges).

## Finding (Add)Files to Rewrite { #findTouchedFiles }

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): (Seq[AddFile], DeduplicateCDFDeletes)
```

!!! note "Fun Fact: Synomyms"
    The phrases "touched files" and "files to rewrite" are synonyms.

`findTouchedFiles` [records this merge operation](MergeIntoCommandBase.md#recordMergeOperation) with the following:

Property | Value
---------|------
 `extraOpType` | **findTouchedFiles**
 `status` | **MERGE operation - scanning files for matches**
 `sqlMetricName` | [scanTimeMs](MergeIntoCommandBase.md#scanTimeMs)

`findTouchedFiles` registers an internal `SetAccumulator` with `internal.metrics.MergeIntoDelta.touchedFiles` name.

`findTouchedFiles` creates a non-deterministic UDF that records the names of touched files (adds them to the accumulator).

`findTouchedFiles` determines the [AddFiles](../../OptimisticTransactionImpl.md#filterFiles) and prune non-matching files (`dataSkippedFiles`).
With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) for the [AddFiles](../../OptimisticTransactionImpl.md#filterFiles) matching [getTargetOnlyPredicates](MergeIntoCommandBase.md#getTargetOnlyPredicates). Otherwise, `findTouchedFiles` requests for all the [AddFiles](../../OptimisticTransactionImpl.md#filterFiles) (an _accept-all_ predicate).

`findTouchedFiles` determines the join type (`joinType`).
With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` uses `INNER` join type. Otherwise, it is `RIGHT_OUTER` join.

??? note "Inner vs Right Outer Joins"
    Learn more on [Wikipedia](https://en.wikipedia.org/wiki/Join_(SQL)):

    * [Inner Join](https://en.wikipedia.org/wiki/Join_(SQL)#Inner_join)
    * [Right Outer Join](https://en.wikipedia.org/wiki/Join_(SQL)#Right_outer_join)

`findTouchedFiles` determines the matched predicate (`matchedPredicate`).
When [isMatchedOnly](MergeIntoCommandBase.md#isMatchedOnly), `findTouchedFiles` converts the [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses) to their [condition](DeltaMergeIntoClause.md#condition)s, if defined, or falls back to accept-all predicate and then reduces to `Or` expressions. Otherwise, `findTouchedFiles` uses accept-all predicate for the matched predicate.

`findTouchedFiles` creates a Catalyst expression (`incrSourceRowCountExpr`) that [increments](MergeIntoCommandBase.md#incrementMetricAndReturnBool) the [numSourceRows](MergeIntoCommandBase.md#numSourceRows) metric (and returns `true` value).

`findTouchedFiles` [gets the source DataFrame](MergeIntoMaterializeSource.md#getSourceDF) and adds an extra column `_source_row_present_` for the `incrSourceRowCountExpr` expression that is used to `DataFrame.filter` by (and, more importanly and as a side effect, counts the number of source rows).

`findTouchedFiles` [builds a target plan](MergeIntoCommandBase.md#buildTargetPlanWithFiles) with the `dataSkippedFiles` files (and any `columnsToDrop` to be dropped).

`findTouchedFiles` creates a target DataFrame from the target plan (`targetDF`) with two extra columns:

Column Name | Expression
------------|-----------
 `_row_id_` | `monotonically_increasing_id`
 `_file_name_` | `input_file_name`

`findTouchedFiles` creates a joined DataFrame (`joinToFindTouchedFiles`) with the `sourceDF` and `targetDF` dataframes, the [condition](MergeIntoCommandBase.md#condition) as the join condition, and the join type (INNER or RIGHT OUTER).

`findTouchedFiles` creates `recordTouchedFileName` UDF to record the names of the touched files (based on the `_file_name_` column) and add them to the accumulator (based on the `matchedPredicate` that is in turn based on the conditional [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses)).

`findTouchedFiles` uses the two columns above (`_row_id_` and `_file_name_`) to select from the `joinToFindTouchedFiles` dataframe (`collectTouchedFiles`).

`findTouchedFiles` calculates the frequency of matches per source row.

!!! danger "FIXME Describe how this calculation happens"

`findTouchedFiles` computes `multipleMatchCount` and `multipleMatchSum`.

!!! danger "FIXME Describe how these calculations happen"

`findTouchedFiles`...FIXME (finished at `hasMultipleMatches`)

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
 `extraOpType` | <ul><li>**writeAllUpdatesAndDeletes** for [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge)<li>**writeAllChanges** otherwise</ul>
 `status` | **MERGE operation - Rewriting [filesToRewrite] files**
 `sqlMetricName` | [rewriteTimeMs](MergeIntoCommandBase.md#rewriteTimeMs)

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
