---
title: DescribeDeltaHistoryCommand
---

# DescribeDeltaHistoryCommand Leaf Logical Command

`DescribeDeltaHistoryCommand` is a leaf `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) that uses [DeltaHistoryManager](../../DeltaHistoryManager.md) for the [commit history](../../DeltaHistoryManager.md#getHistory) of a delta table.

`DescribeDeltaHistoryCommand` is an executable variant of [DescribeDeltaHistory](DescribeDeltaHistory.md) unary logical operator.

## Creating Instance

`DescribeDeltaHistoryCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="limit"> History Limit
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

`run` requests the [DeltaTableV2](#table) for the [DeltaLog](../../DeltaTableV2.md#deltaLog) that is requested for the [DeltaHistoryManager](../../DeltaLog.md#history).

In the end, `run` requests the [DeltaHistoryManager](../../DeltaHistoryManager.md) for the [commit history](../../DeltaHistoryManager.md#getHistory) (for the latest [limit](#limit) versions).
