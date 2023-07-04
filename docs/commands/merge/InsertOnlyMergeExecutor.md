# InsertOnlyMergeExecutor

`InsertOnlyMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [merge command](index.md) that only inserts new data.

`InsertOnlyMergeExecutor` is also a [MergeIntoCommandBase](MergeIntoCommandBase.md).

## writeOnlyInserts { #writeOnlyInserts }

```scala
writeOnlyInserts(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filterMatchedRows: Boolean,
  numSourceRowsMetric: String): Seq[FileAction]
```

`writeOnlyInserts`...FIXME

---

`writeOnlyInserts` is used when:

* `MergeIntoCommand` is requested to [runMerge](MergeIntoCommand.md#runMerge)

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
