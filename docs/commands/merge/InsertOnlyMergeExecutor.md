# InsertOnlyMergeExecutor

`InsertOnlyMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [MERGE command](index.md) (when requested to [run a merge](MergeIntoCommand.md#runMerge)) that [only inserts new data](MergeIntoCommandBase.md#isInsertOnly).

`InsertOnlyMergeExecutor` is used only when [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is enabled.

??? note "ClassicMergeExecutor"
    When a MERGE query is neither [insert only](MergeIntoCommandBase.md#isInsertOnly) nor [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is enabled, [ClassicMergeExecutor](ClassicMergeExecutor.md) is used to [run merge](MergeIntoCommand.md#runMerge).

## Writing Out Inserts { #writeOnlyInserts }

```scala
writeOnlyInserts(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filterMatchedRows: Boolean,
  numSourceRowsMetric: String): Seq[FileAction]
```

!!! note "`filterMatchedRows` Argument"
    `writeOnlyInserts` is given `filterMatchedRows` flag when [running a merge](MergeIntoCommand.md#runMerge) for the following conditions:

    `filterMatchedRows` Flag | Condition
    -------------------------|----------
    `true` | An [insert-only merge](MergeIntoCommandBase.md#isInsertOnly) and [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) enabled
    `false` | No files to rewrite ([AddFile](../../AddFile.md)s) from [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles)

`writeOnlyInserts` [records this merge operation](MergeIntoCommandBase.md#recordMergeOperation) with the following:

Property | Value
---------|------
 `extraOpType` | <ul><li>**writeInsertsOnlyWhenNoMatchedClauses** with the given `filterMatchedRows` enabled (see the above note 👆)<li>**writeInsertsOnlyWhenNoMatches** otherwise</ul>
 `status` | **MERGE operation - writing new files for only inserts**
 `sqlMetricName` | [rewriteTimeMs](MergeIntoCommandBase.md#rewriteTimeMs)

??? note "Early Stop Possible"
    With no [WHEN NOT MATCHED THEN INSERT clauses used](MergeIntoCommandBase.md#includesInserts) and the given `filterMatchedRows` flag disabled (see the above note 👆), `writeOnlyInserts` has nothing to do (nothing to insert and so no new files to write).
    
    The [numSourceRowsInSecondScan](MergeIntoCommandBase.md#numSourceRowsInSecondScan) metric is set to `-1`.

    `writeOnlyInserts` returns no [FileAction](../../FileAction.md)s.

`writeOnlyInserts` [creates an Expression to increment the metric](MergeIntoCommandBase.md#incrementMetricAndReturnBool) (by the given `numSourceRowsMetric` name and to return `true` literal) that is used to count the number of rows in the [source dataframe](MergeIntoMaterializeSource.md#getSourceDF).

??? note "What a trick!"
    `writeOnlyInserts` creates a custom Catalyst Expression that is a predicate (returns `true` value) that can and is used in `Dataset.filter` operator.

    At execution time, the `filter` operator requests the custom expression to _do its work_ (i.e., update the metric and return `true`) so, in the end, accepts all the rows and (as a side effect) counts the number of rows. _What a clever trick!_

For a merge with just a single [WHEN NOT MATCHED THEN INSERT clause](MergeIntoCommandBase.md#notMatchedClauses) with a [condition](DeltaMergeIntoClause.md#condition) (_conditional insert_), `writeOnlyInserts` adds `Dataset.filter` with the condition to the source dataframe.

`filterMatchedRows` builds a `preparedSourceDF` DataFrame.

For an [insert-only merge](MergeIntoCommandBase.md#isInsertOnly) (and [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) enabled) (when the given `filterMatchedRows` flag is enabled), `writeOnlyInserts` uses LEFT ANTI join on the [source](#getSourceDF) to find the rows to insert:

1. `filterMatchedRows` splits conjunctive predicates in the [condition](MergeIntoCommandBase.md#condition) to find target-only ones (that reference the target columns only)
1. `filterMatchedRows` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) for the [files](../../OptimisticTransactionImpl.md#filterFiles) matching the target-only predicates
1. `filterMatchedRows` creates a `targetDF` dataframe for the [target plan with the files](MergeIntoCommandBase.md#buildTargetPlanWithFiles)
1. In the end, `filterMatchedRows` performs a LEFT ANTI join on the `sourceDF` and `targetDF` dataframes with the [condition](MergeIntoCommandBase.md#condition) as the join condition

With `filterMatchedRows` disabled, `writeOnlyInserts` leaves the `sourceDF` unchanged.

`writeOnlyInserts` [generateInsertsOnlyOutputDF](#generateInsertsOnlyOutputDF) with the `preparedSourceDF` (that creates an `outputDF` dataframe).

`writeOnlyInserts` prints out the following DEBUG message to the logs:

```text
[extraOpType]: output plan:
[outputDF]
```

`writeOnlyInserts` [writeFiles](MergeIntoCommandBase.md#writeFiles) with the `outputDF` (that gives [FileAction](../../FileAction.md)s).

In the end, `writeOnlyInserts` updates the [performance metrics](MergeIntoCommandBase.md#metrics).

---

`writeOnlyInserts` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) (for an [insert-only merge](MergeIntoCommandBase.md#isInsertOnly) with [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) or when there are no [files to rewrite](ClassicMergeExecutor.md#findTouchedFiles))

### Generating Output DataFrame for Insert-Only Merge { #generateInsertsOnlyOutputDF }

```scala
generateInsertsOnlyOutputDF(
  preparedSourceDF: DataFrame,
  deltaTxn: OptimisticTransaction): DataFrame
```

`generateInsertsOnlyOutputDF` generates the final output dataframe to be [written out](MergeIntoCommandBase.md#writeFiles) to a target delta table.

`generateInsertsOnlyOutputDF` (as part of [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)) is used for [insert-only merges](index.md#insert-only-merges) and makes distinction between single vs many [WHEN NOT MATCHED THEN INSERT](MergeIntoCommandBase.md#notMatchedClauses) merges.

---

`generateInsertsOnlyOutputDF` get the columns names (`targetOutputColNames`) of the [target table](#getTargetOutputCols) (from the [metadata](../../OptimisticTransactionImpl.md#metadata) of the given [OptimisticTransaction](../../OptimisticTransaction.md)).

!!! note "Optimization: Single WHEN NOT MATCHED THEN INSERT Merges"

For just a single [WHEN NOT MATCHED THEN INSERT](MergeIntoCommandBase.md#notMatchedClauses) merge, `generateInsertsOnlyOutputDF` [generateOneInsertOutputCols](#generateOneInsertOutputCols) (from the target output columns) to project the given `preparedSourceDF` on (using `Dataset.select` operator) and returns it. `generateInsertsOnlyOutputDF` finishes early.

`generateInsertsOnlyOutputDF` [appends precomputed clause conditions](MergeOutputGeneration.md#generatePrecomputedConditionsAndDF) to the given `preparedSourceDF` dataframe (with the [WHEN NOT MATCHED clauses](MergeIntoCommandBase.md#notMatchedClauses)).

!!! note
    At this point, we know there are more than one [WHEN NOT MATCHED clauses](MergeIntoCommandBase.md#notMatchedClauses) in this merge.

`generateInsertsOnlyOutputDF` [generates the output columns for this insert-only merge](#generateInsertsOnlyOutputCols) (based on the target output columns and the precomputed [DeltaMergeIntoNotMatchedInsertClause](DeltaMergeIntoNotMatchedInsertClause.md)s).

In the end, `generateInsertsOnlyOutputDF` does "column and filter pruning" of the `sourceWithPrecompConditions` dataframe:

* Leaves the `outputCols` columns only (using `Dataset.select` operator)
* Leaves rows with [\_row_dropped_](MergeIntoCommandBase.md#ROW_DROPPED_COL) column with `false` value only (using `Dataset.filter` operator)

`generateInsertsOnlyOutputDF` drops the [\_row_dropped_](MergeIntoCommandBase.md#ROW_DROPPED_COL) column.

### generateInsertsOnlyOutputCols { #generateInsertsOnlyOutputCols }

```scala
generateInsertsOnlyOutputCols(
  targetOutputColNames: Seq[String],
  insertClausesWithPrecompConditions: Seq[DeltaMergeIntoNotMatchedClause]): Seq[Column]
```

`generateInsertsOnlyOutputDF` uses the given `targetOutputColNames` column names with one extra [_row_dropped_](MergeIntoCommandBase.md#ROW_DROPPED_COL) column (`outputColNames`).

For every `insertClausesWithPrecompConditions` clause, `generateInsertsOnlyOutputDF` creates a collection of the expressions of the [DeltaMergeActions](DeltaMergeIntoClause.md#resolvedActions) and one to [increment numTargetRowsInserted metric](MergeIntoCommandBase.md#incrementMetricAndReturnBool) (`allInsertExprs`).

`generateInsertsOnlyOutputDF` uses the given `insertClausesWithPrecompConditions` clauses to create `allInsertConditions` collection of the [condition](DeltaMergeIntoClause.md#condition)s (if specified) or assumes `true`.

`generateInsertsOnlyOutputDF` uses the `allInsertConditions` and `allInsertExprs` to generate a collection of `CaseWhen` expressions with an `elseValue` based on `dropSourceRowExprs` (`outputExprs`).

!!! note "FIXME A few examples would make the description much easier"

`generateInsertsOnlyOutputDF` prints out the following DEBUG message to the logs (with the generated `CaseWhen`s):

```text
prepareInsertsOnlyOutputDF: not matched expressions
    [outputExprs]
```

In the end, `generateInsertsOnlyOutputDF` takes the `outputExprs` and the `outputColNames` to create `Column`s.

## Logging

`InsertOnlyMergeExecutor` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
