# RemoveColumnMappingCommand

`RemoveColumnMappingCommand` is a [ImplicitMetadataOperation](../../ImplicitMetadataOperation.md) to remove [column mapping](../../column-mapping/index.md) from a [delta table](#deltaLog).

`RemoveColumnMappingCommand` is used for [AlterTableSetPropertiesDeltaCommand](AlterTableSetPropertiesDeltaCommand.md) and [AlterTableUnsetPropertiesDeltaCommand](AlterTableUnsetPropertiesDeltaCommand.md) commands to exit early when executed with just the [delta.columnMapping.mode](../../table-properties/DeltaConfigs.md#COLUMN_MAPPING_MODE) table property being changed to `none` (and [spark.databricks.delta.columnMapping.allowRemoval](../../configuration-properties/index.md#columnMapping.allowRemoval) enabled).

`RemoveColumnMappingCommand` is a transactional command (that [starts a new transaction](../../DeltaLog.md#withNewTransaction) on the [delta table](#deltaLog) when [executed](#run)).

## Creating Instance

`RemoveColumnMappingCommand` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](../../DeltaLog.md)
* <span id="catalogOpt"> `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable))

`RemoveColumnMappingCommand` is created using [apply](#apply) utility.

## Creating RemoveColumnMappingCommand { #apply }

```scala
apply(
  deltaLog: DeltaLog,
  catalogOpt: Option[CatalogTable]): RemoveColumnMappingCommand
```

`apply` creates a [RemoveColumnMappingCommand](#creating-instance) for the given [DeltaLog](../../DeltaLog.md) and `CatalogTable`.

---

`apply` is used when:

* [AlterTableSetPropertiesDeltaCommand](AlterTableSetPropertiesDeltaCommand.md) is executed
* [AlterTableUnsetPropertiesDeltaCommand](AlterTableUnsetPropertiesDeltaCommand.md) is executed

## Executing Command { #run }

```scala
run(
  spark: SparkSession,
  removeColumnMappingTableProperty: Boolean): Unit
```

`run` requests the [DeltaLog](#deltaLog) to [start a new transaction](../../DeltaLog.md#withNewTransaction).

`run`...FIXME

---

`run` is used when:

* [AlterTableSetPropertiesDeltaCommand](AlterTableSetPropertiesDeltaCommand.md) is executed
* [AlterTableUnsetPropertiesDeltaCommand](AlterTableUnsetPropertiesDeltaCommand.md) is executed
