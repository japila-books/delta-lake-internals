---
title: ADD COLUMNS
---

# AlterTableAddColumnsDeltaCommand

`AlterTableAddColumnsDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) that represents `ALTER TABLE ADD COLUMNS` SQL command.

!!! note
    `AlterTableAddColumnsDeltaCommand` is a variant of Spark SQL's [AlterTableAddColumnsCommand]({{ book.spark_sql }}/logical-operators/AlterTableAddColumnsCommand) for Delta Lake to support `ALTER TABLE ADD COLUMNS` command.

    Otherwise, [Spark SQL would throw an AnalysisException]({{ book.spark_sql }}/logical-operators/AlterTableAddColumnsCommand#verifyAlterTableAddColumn).

`AlterTableAddColumnsDeltaCommand` is an [AlterDeltaTableCommand](AlterDeltaTableCommand.md).

## Creating Instance

`AlterTableAddColumnsDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](AlterDeltaTableCommand.md#table)
* <span id="colsToAddWithPosition"> Columns to Add

`AlterTableAddColumnsDeltaCommand` is created when:

* `DeltaCatalog` is requested to [alter a table](../../DeltaCatalog.md#alterTable)

## <span id="IgnoreCachedData"> IgnoreCachedData

`AlterTableAddColumnsDeltaCommand` is an `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData)) logical operator.

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` [starts a transaction](AlterDeltaTableCommand.md#startTransaction) and requests it for the current [Metadata](../../OptimisticTransactionImpl.md#metadata) (of the [DeltaTableV2](#table)).

`run` alters the current schema (creates a new [metadata](../../Metadata.md#schemaString)) and [notifies the transaction](../../OptimisticTransactionImpl.md#updateMetadata).

In the end, `run` [commits the transaction](AlterDeltaTableCommand.md#commit) (as [ADD COLUMNS](../../Operation.md#AddColumns) operation).

---

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.
