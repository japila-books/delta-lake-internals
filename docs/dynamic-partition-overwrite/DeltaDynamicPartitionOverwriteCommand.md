# DeltaDynamicPartitionOverwriteCommand

`DeltaDynamicPartitionOverwriteCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) and a `V2WriteCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/V2WriteCommand/)) for dynamic partition overwrite using [WriteIntoDelta](../commands/WriteIntoDelta.md).

`DeltaDynamicPartitionOverwriteCommand` sets [partitionOverwriteMode](../spark-connector/options.md#partitionOverwriteMode) option as `DYNAMIC` before [write](#run).

!!! note "Workaround"
    `DeltaDynamicPartitionOverwriteCommand` is a workaround of Spark SQL not supporting V1 fallback for dynamic partition overwrite.

## Creating Instance

`DeltaDynamicPartitionOverwriteCommand` takes the following to be created:

* <span id="table"> Delta Table (`NamedRelation`)
* <span id="deltaTable"> [DeltaTableV2](../DeltaTableV2.md)
* <span id="query"> Logical Query Plan (`LogicalPlan`)
* <span id="writeOptions"> Write options (`Map[String, String]`)
* <span id="isByName"> `isByName` flag
* <span id="analyzedQuery"> Analyzed Logical Query Plan (`Option[LogicalPlan]`)

`DeltaDynamicPartitionOverwriteCommand` is created when:

* `DeltaAnalysis` logical resolution rule is requested to [resolve an OverwritePartitionsDynamic on a delta table](../DeltaAnalysis.md#apply) (`INSERT OVERWRITE` with dynamic partition overwrite)

??? note "OverwritePartitionsDynamic Unary Logical Command"
    Learn more about `OverwritePartitionsDynamic` unary logical command in [The Internals of Spark SQL]({{ book.spark_sql }}/logical-operators/OverwritePartitionsDynamic/).

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run`...FIXME
