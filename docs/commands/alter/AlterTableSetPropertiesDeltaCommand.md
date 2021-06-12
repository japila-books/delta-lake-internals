# AlterTableSetPropertiesDeltaCommand

`AlterTableSetPropertiesDeltaCommand` is a [AlterDeltaTableCommand](AlterDeltaTableCommand.md).

`AlterTableSetPropertiesDeltaCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) logical operator.

## Creating Instance

`AlterTableSetPropertiesDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="configuration"> Configuration (`Map[String, String]`)

`AlterTableSetPropertiesDeltaCommand` is created when:

* `DeltaCatalog` is requested to [alterTable](../../DeltaCatalog.md#alterTable)
