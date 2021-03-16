# CreateDeltaTableCommand

`CreateDeltaTableCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)).

## Creating Instance

`CreateDeltaTableCommand` takes the following to be created:

* <span id="table"> `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable/))
* <span id="existingTableOpt"> Existing `CatalogTable` (if available)
* <span id="mode"> `SaveMode`
* <span id="query"> Optional Data Query (`LogicalPlan`)
* <span id="operation"> `CreationMode` (default: `TableCreationModes.Create`)
* <span id="tableByPath"> `tableByPath` flag (default: `false`)

`CreateDeltaTableCommand` is created when:

* `DeltaCatalog` is requested to [create a Delta table](../DeltaCatalog.md#createDeltaTable)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` creates a [DeltaLog](../DeltaLog.md#forTable) (for the given [table](#table) based on a table location) and a [DeltaOptions](../DeltaOptions.md).

`run` [starts a transaction](../DeltaLog.md#startTransaction) (on the `DeltaLog`).

`run` branches off based on the optional [data query](#query). For [data query](#query) defined, `run` creates a [WriteIntoDelta](WriteIntoDelta.md) and requests it to [write](WriteIntoDelta.md#write). Otherwise, `run` creates an empty table.

!!! note
    `run` does a bit more, but I don't think it's of much interest.

`run` [commits the transaction](../DeltaLog.md#commit).

In the end, `run` [updateCatalog](#updateCatalog).

`run` is part of the `RunnableCommand` abstraction.

### <span id="updateCatalog"> updateCatalog

```scala
updateCatalog(
  spark: SparkSession,
  table: CatalogTable): Unit
```

`updateCatalog` uses the given `SparkSession` to access `SessionCatalog` to `createTable` or `alterTable` when the [tableByPath](#tableByPath) flag is off. Otherwise, `updateCatalog` does nothing.

### <span id="getOperation"> getOperation

```scala
getOperation(
  metadata: Metadata,
  isManagedTable: Boolean,
  options: Option[DeltaOptions]): DeltaOperations.Operation
```

`getOperation`...FIXME
