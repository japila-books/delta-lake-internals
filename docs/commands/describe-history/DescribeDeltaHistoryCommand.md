# DescribeDeltaHistoryCommand

`DescribeDeltaHistoryCommand` is a leaf `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) that uses [DeltaHistoryManager](../../DeltaHistoryManager.md) for the [commit history](../../DeltaHistoryManager.md#getHistory) of a delta table.

`DescribeDeltaHistoryCommand` is used for [DESCRIBE HISTORY](../../sql/index.md#DESCRIBE-HISTORY) SQL command.

## Creating Instance

`DescribeDeltaHistoryCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="limit"> Limit
* <span id="output"> Output Schema Attributes

`DescribeDeltaHistoryCommand` is created when:

* `DescribeDeltaHistory` is requested to [convert itself into an executable DescribeDeltaHistoryCommand](DescribeDeltaHistory.md#toCommand)

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` creates a Hadoop `Path` to (the location of) the delta table (based on [DeltaTableIdentifier](../../DeltaTableIdentifier.md)).

`run` creates a [DeltaLog](../../DeltaLog.md#forTable) for the delta table.

`run` requests the `DeltaLog` for the [DeltaHistoryManager](../../DeltaLog.md#history) that is requested for the [commit history](../../DeltaHistoryManager.md#getHistory).
