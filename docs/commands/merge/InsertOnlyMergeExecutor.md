# InsertOnlyMergeExecutor

`InsertOnlyMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [MERGE command](index.md) (when requested to [run merge](MergeIntoCommand.md#runMerge)) that [only inserts new data](MergeIntoCommandBase.md#isInsertOnly) (with [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) enabled).

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

!!! warning "FIXME Optimization"

With the given `filterMatchedRows` flag enabled, `writeOnlyInserts`...FIXME (`preparedSourceDF`)

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

### generateInsertsOnlyOutputDF { #generateInsertsOnlyOutputDF }

```scala
generateInsertsOnlyOutputDF(
  preparedSourceDF: DataFrame,
  deltaTxn: OptimisticTransaction): DataFrame
```

`generateInsertsOnlyOutputDF`...FIXME

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
