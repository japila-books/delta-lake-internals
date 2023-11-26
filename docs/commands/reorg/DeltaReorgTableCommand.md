---
title: DeltaReorgTableCommand
---

# DeltaReorgTableCommand Leaf Logical Runnable Command

`DeltaReorgTableCommand` is an [OptimizeTableCommandBase](../optimize/OptimizeTableCommandBase.md) that represents [DeltaReorgTable](DeltaReorgTable.md) logical operator at execution.

## Creating Instance

`DeltaReorgTableCommand` takes the following to be created:

* <span id="target"> Target table (`LogicalPlan`)
* <span id="predicates"> `WHERE` predicates

`DeltaReorgTableCommand` is created when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (with a logical query plan with a [DeltaReorgTable](DeltaReorgTable.md) logical operator over a [DeltaTableV2](../../DeltaTableV2.md))

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run` executes a [OptimizeTableCommand](../optimize/OptimizeTableCommand.md) with the following [DeltaOptimizeContext](../optimize/DeltaOptimizeContext.md) and no [zOrderBy](../optimize/OptimizeTableCommand.md#zOrderBy).

DeltaOptimizeContext | Value
---------------------|------
 [isPurge](../optimize/DeltaOptimizeContext.md#isPurge) | `true`
 [minFileSize](../optimize/DeltaOptimizeContext.md#minFileSize) | `0`
 [maxDeletedRowsRatio](../optimize/DeltaOptimizeContext.md#maxDeletedRowsRatio) | `0`
