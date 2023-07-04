# MergeIntoCommandBase

`MergeIntoCommandBase` is an [extension](#contract) of the `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) abstraction for [merge delta commands](#implementations).

`MergeIntoCommandBase` is a [DeltaCommand](../DeltaCommand.md)

`MergeIntoCommandBase` is a [MergeIntoMaterializeSource](MergeIntoMaterializeSource.md)

## Contract (Subset)

### runMerge { #runMerge }

```scala
runMerge(
  spark: SparkSession): Seq[Row]
```

See:

* [MergeIntoCommand](MergeIntoCommand.md#runMerge)

Used when:

* `MergeIntoCommandBase` is requested to [run](#run)

## Implementations

* [MergeIntoCommand](MergeIntoCommand.md)

## buildTargetPlanWithFiles { #buildTargetPlanWithFiles }

```scala
buildTargetPlanWithFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile],
  columnsToDrop: Seq[String]): LogicalPlan
```

`buildTargetPlanWithFiles`...FIXME

---

`buildTargetPlanWithFiles` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles) and [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)

### buildTargetPlanWithIndex { #buildTargetPlanWithIndex }

```scala
buildTargetPlanWithIndex(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  fileIndex: TahoeFileIndex,
  columnsToDrop: Seq[String]): LogicalPlan
```

`buildTargetPlanWithIndex`...FIXME

## Special Columns

### \_row_dropped_ { #ROW_DROPPED_COL }

`_row_dropped_` column name is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [generateInsertsOnlyOutputDF](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputDF) and [generateInsertsOnlyOutputCols](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputCols)
* `MergeOutputGeneration` is requested to [generateCdcAndOutputRows](MergeOutputGeneration.md#generateCdcAndOutputRows)

!!! note
    It appears that `ClassicMergeExecutor` and `InsertOnlyMergeExecutor` use `_row_dropped_` column to filter out rows when it is `false` followed by dropping the column immediately.

    An "exception" to the behaviour is [MergeOutputGeneration](MergeOutputGeneration.md#generateCdcAndOutputRows) for CDC-aware output generation.

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      spark: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run`...FIXME
