---
title: ShowDeltaTableColumnsCommand
---

# ShowDeltaTableColumnsCommand Unary Logical Operator

`ShowDeltaTableColumnsCommand` is a [DeltaCommand](DeltaCommand.md) that represents a `ShowColumns` ([Spark SQL]({{ book.spark_sql }}/logical-operators/ShowColumns)) logical command in an analyzed logical query plan after [DeltaAnalysis](../DeltaAnalysis.md#ShowColumns).

`ShowDeltaTableColumnsCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)).

## Creating Instance

`ShowDeltaTableColumnsCommand` takes the following to be created:

* [Child logical operator with a delta table](#child)

`ShowDeltaTableColumnsCommand` is created when:

* `DeltaAnalysis` is requested to [resolve ShowColumns logical operator](../DeltaAnalysis.md#apply) (over a resolved [DeltaTableV2](../DeltaTableV2.md))

### Child Logical Operator with Delta Table { #child }

`ShowDeltaTableColumnsCommand` is given a `ResolvedTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/ResolvedTable)) with a [DeltaTableV2](../DeltaTableV2.md) when [created](#creating-instance).

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run` requests the [DeltaLog](../DeltaTableV2.md#deltaLog) (of the [delta table](#child)) to [update](../SnapshotManagement.md#update).

`run` returns the field names of the [schema](../SnapshotDescriptor.md#schema) of the [delta table](#child).
