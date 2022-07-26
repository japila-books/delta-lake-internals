# CreateDeltaTableCommand

`CreateDeltaTableCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) to [create a delta table](#run) (for [DeltaCatalog](../DeltaCatalog.md#createDeltaTable)).

## Creating Instance

`CreateDeltaTableCommand` takes the following to be created:

* <span id="table"> `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable/))
* <span id="existingTableOpt"> Existing `CatalogTable` (if available)
* <span id="mode"> `SaveMode`
* <span id="query"> Optional Data Query (`LogicalPlan`)
* [CreationMode](#operation)
* <span id="tableByPath"> `tableByPath` flag (default: `false`)
* <span id="output"> Output attributes (default: empty)

`CreateDeltaTableCommand` is created when:

* `DeltaCatalog` is requested to [create a delta table](../DeltaCatalog.md#createDeltaTable)

### <span id="operation"> CreationMode

`CreateDeltaTableCommand` is given a `CreationMode` when [created](#creating-instance):

* `Create`
* `CreateOrReplace`
* `Replace`

The `CreationMode` is passed on from [DeltaCatalog](../DeltaCatalog.md#createDeltaTable).

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

---

`run` creates a [DeltaLog](../DeltaLog.md#forTable) (for the given [table](#table) based on a table location) and a [DeltaOptions](../DeltaOptions.md).

`run` [starts a transaction](../DeltaLog.md#startTransaction).

`run` branches off based on the optional [data query](#query). For [data query](#query) defined, `run` creates a [WriteIntoDelta](WriteIntoDelta.md) and requests it to [write](WriteIntoDelta.md#write). Otherwise, `run` creates an empty table.

!!! note
    `run` does a bit more, but I don't think it's of much interest.

`run` [commits the transaction](../DeltaLog.md#commit).

In the end, `run` [updateCatalog](#updateCatalog).

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

### <span id="replaceMetadataIfNecessary"> replaceMetadataIfNecessary

```scala
replaceMetadataIfNecessary(
  txn: OptimisticTransaction,
  tableDesc: CatalogTable,
  options: DeltaOptions,
  schema: StructType): Unit
```

!!! note "Unused argument"
    `tableDesc` argument is not used.

`replaceMetadataIfNecessary` determines whether or not it is a replace operation (based on the [CreationMode](#operation)). It is for `CreateOrReplace` or `Replace`.

`replaceMetadataIfNecessary` determines whether or not it is supposed not to overwrite the schema of a Delta table (based on the [overwriteSchema](../DeltaWriteOptionsImpl.md#canOverwriteSchema) option in the input [DeltaOptions](../DeltaOptions.md)).

In the end, only for an `CreateOrReplace` or `Replace` operation on an existing delta table with [overwriteSchema](../DeltaWriteOptionsImpl.md#canOverwriteSchema) option enabled, `replaceMetadataIfNecessary` [updates the metadata](../OptimisticTransactionImpl.md#updateMetadataForNewTable) (on the given [OptimisticTransaction](../OptimisticTransaction.md)) with the given `schema`.

#### <span id="replaceMetadataIfNecessary-DeltaIllegalArgumentException"> DeltaIllegalArgumentException

`replaceMetadataIfNecessary` throws an `DeltaIllegalArgumentException` for a `CreateOrReplace` or `Replace` operation with `overwriteSchema` option enabled:

```text
The usage of overwriteSchema is not allowed when replacing a Delta table.
```
