# CreateDeltaTableCommand

`CreateDeltaTableCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand/)) to [create a delta table](#run) (for [DeltaCatalog](../../DeltaCatalog.md#createDeltaTable)).

`CreateDeltaTableCommand` represents the following SQL commands at execution for delta tables:

* `CREATE TABLE ... LIKE` ([Spark SQL]({{ book.spark_sql }}/logical-operators/CreateTableLikeCommand/))
* [SHALLOW CLONE](../clone/index.md)

`CreateDeltaTableCommand` is a [DeltaCommand](../DeltaCommand.md).

`CreateDeltaTableCommand` is a [CreateDeltaTableLike](CreateDeltaTableLike.md) command.

## Creating Instance

`CreateDeltaTableCommand` takes the following to be created:

* <span id="table"> `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable/))
* <span id="existingTableOpt"> Existing `CatalogTable` (if available)
* <span id="mode"> `SaveMode`
* [Logical Query Plan](#query)
* [Create Operation](#operation)
* <span id="tableByPath"> `tableByPath` flag (default: `false`)
* <span id="output"> Output attributes
* <span id="protocol"> [Protocol](../../Protocol.md) (optional)
* [allowCatalogManaged](#allowCatalogManaged) flag
* <span id="createTableFunc"> Create Table Function (default: undefined)

`CreateDeltaTableCommand` is created when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed for the following:
    * `CreateTableLikeCommand` (with the delta table as the source or the provider being `delta`)
    * [CloneTableStatement](../../DeltaAnalysis.md#resolveCloneCommand)
* `AbstractDeltaCatalog` is requested to [create a delta table](../../AbstractDeltaCatalog.md#createDeltaTable)

### allowCatalogManaged Flag { #allowCatalogManaged }

??? note "CreateDeltaTableLike"

    ```scala
    allowCatalogManaged: Boolean
    ```

    `allowCatalogManaged` is part of the [CreateDeltaTableLike](CreateDeltaTableLike.md#allowCatalogManaged) abstraction.

`CreateDeltaTableCommand` can be given `allowCatalogManaged` flag when [created](#creating-instance).

`allowCatalogManaged` is disabled (`false`) by default.

`allowCatalogManaged` can be enabled (`true`) only when `AbstractDeltaCatalog` is requested to [create a delta table](../../AbstractDeltaCatalog.md#createDeltaTable) with [Unity Catalog configured](../../AbstractDeltaCatalog.md#unity-catalog).

### Optional Logical Query Plan { #query }

```scala
query: Option[LogicalPlan]
```

`CreateDeltaTableCommand` can be given a `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan)) when [created](#creating-instance).

The `LogicalPlan` can be one of the following (that triggers a custom handling):

Logical Query Plan | Handler
-|-
[CloneTableCommand](../clone/CloneTableCommand.md) | [handleClone](../clone/CloneTableCommand.md#handleClone)
[WriteIntoDeltaLike](../WriteIntoDeltaLike.md) | [handleCreateTableAsSelect](#handleCreateTableAsSelect)
Some other `LogicalPlan` | [handleCreateTableAsSelect](#handleCreateTableAsSelect)
Undefined | [handleCreateTable](#handleCreateTable)

### Create Operation { #operation }

`CreateDeltaTableCommand` can be given a `CreationMode` when [created](#creating-instance):

* `Create` (default)
* `CreateOrReplace`
* `Replace`

`CreationMode` is `Create` by default or specified by [DeltaCatalog](../../DeltaCatalog.md#createDeltaTable).

## Execute Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run`...FIXME

??? warning "DELTA_UNSUPPORTED_CATALOG_MANAGED_TABLE_CREATION Error" 
    `run` checks whether it is allowed to create a [catalog-managed table](../../catalog-managed-tables/index.md) using the following:
    
    * this [allowCatalogManaged](#allowCatalogManaged) flag is enabled and [CatalogOwnedTableFeature](../../catalog-managed-tables/CatalogOwnedTableFeature.md) is among the [supported table features](../../table-features/TableFeatureProtocolUtils.md#getSupportedFeaturesFromTableConfigs) (of this [CatalogTable](#table)).
    * [spark.databricks.delta.properties.defaults.feature.catalogManaged](../../catalog-managed-tables/CatalogOwnedTableUtils.md#defaultCatalogOwnedEnabled) configuration property is enabled globally.

    If neither is positive, `run` throws a [DeltaUnsupportedOperationException](../../DeltaErrorsBase.md#deltaCannotCreateCatalogManagedTable):

    ```text
    Creating a catalog-managed table using delta is unsupported.
    ```

### updateCatalog { #updateCatalog }

```scala
updateCatalog(
  spark: SparkSession,
  table: CatalogTable): Unit
```

`updateCatalog` uses the given `SparkSession` to access `SessionCatalog` to `createTable` or `alterTable` when the [tableByPath](#tableByPath) flag is off. Otherwise, `updateCatalog` does nothing.

### getOperation { #getOperation }

```scala
getOperation(
  metadata: Metadata,
  isManagedTable: Boolean,
  options: Option[DeltaOptions]): DeltaOperations.Operation
```

`getOperation`...FIXME

### replaceMetadataIfNecessary { #replaceMetadataIfNecessary }

```scala
replaceMetadataIfNecessary(
  txn: OptimisticTransaction,
  tableDesc: CatalogTable,
  options: DeltaOptions,
  schema: StructType): Unit
```

??? note "`tableDesc` Unused"
    `tableDesc` argument is not used.

`replaceMetadataIfNecessary` determines whether or not it is a replace operation (i.e., `CreateOrReplace` or `Replace` based on the [CreationMode](#operation)).

`replaceMetadataIfNecessary` determines whether or not it is supposed not to overwrite the schema of a Delta table (based on the [overwriteSchema](../../spark-connector/DeltaWriteOptionsImpl.md#canOverwriteSchema) option in the input [DeltaOptions](../../spark-connector/DeltaOptions.md)).

In the end, only for an `CreateOrReplace` or `Replace` operation on an existing delta table with [overwriteSchema](../../spark-connector/DeltaWriteOptionsImpl.md#canOverwriteSchema) option enabled, `replaceMetadataIfNecessary` [updates the metadata](../../OptimisticTransactionImpl.md#updateMetadataForNewTable) (on the given [OptimisticTransaction](../../OptimisticTransaction.md)) with the given `schema`.

#### DeltaIllegalArgumentException { #replaceMetadataIfNecessary-DeltaIllegalArgumentException }

`replaceMetadataIfNecessary` throws an `DeltaIllegalArgumentException` for a `CreateOrReplace` or `Replace` operation with `overwriteSchema` option enabled:

```text
The usage of overwriteSchema is not allowed when replacing a Delta table.
```

### Handling Transaction Commit { #handleCommit }

```scala
handleCommit(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  tableWithLocation: CatalogTable): Seq[Row]
```

`handleCommit` [starts a transaction](#startTxnForTableCreation).

`handleCommit` executes one of the following logic to handle the [query](#query) (that gives the result to be returned):

* [CloneTableCommand](#CloneTableCommand)
* [WriteIntoDeltaLike](#WriteIntoDeltaLike)
* [Some other query](#some-other-query) (that is neither a[CloneTableCommand](#CloneTableCommand) nor a [WriteIntoDeltaLike](#WriteIntoDeltaLike))
* [No query](#no-query)

In the end, `handleCommit` [runs post-commit updates](#runPostCommitUpdates).

#### CloneTableCommand { #CloneTableCommand }

`handleCommit` [checkPathEmpty](#checkPathEmpty).

`handleCommit` requests the [CloneTableCommand](../clone/CloneTableCommand.md) to [handleClone](../clone/CloneTableCommand.md#handleClone).

#### WriteIntoDeltaLike { #WriteIntoDeltaLike }

`handleCommit` [checkPathEmpty](#checkPathEmpty).

`handleCommit` [handleCreateTableAsSelect](#handleCreateTableAsSelect).

#### Some Other Query

`handleCommit` [checkPathEmpty](#checkPathEmpty).

`handleCommit` makes sure that the [query](#query) is not a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) or throws an `IllegalArgumentException`.

`handleCommit` [handleCreateTableAsSelect](#handleCreateTableAsSelect) with a new [WriteIntoDelta](../WriteIntoDelta.md).

#### No Query

With no [query](#query) specified, `handleCommit` [handleCreateTable](#handleCreateTable)

#### Executing Post-Commit Updates { #runPostCommitUpdates }

```scala
runPostCommitUpdates(
  sparkSession: SparkSession,
  txnUsedForCommit: OptimisticTransaction,
  deltaLog: DeltaLog,
  tableWithLocation: CatalogTable): Unit
```

??? warning "Procedure"
    `runPostCommitUpdates` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`runPostCommitUpdates` prints out the following INFO message to the logs:

```text
Table is path-based table: [tableByPath]. Update catalog with mode: [operation]
```

`runPostCommitUpdates` requests the given [DeltaLog](#deltaLog) to [update](../../SnapshotManagement.md#update).

`runPostCommitUpdates` [updates the catalog](#updateCatalog).

In the end, when [delta.universalFormat.enabledFormats](../../table-properties/DeltaConfigs.md#universalFormat.enabledFormats) table property contains `iceberg`, `runPostCommitUpdates` requests the `UniversalFormatConverter` to [convertSnapshot](../../uniform/UniversalFormatConverter.md#convertSnapshot).

#### Updating Table Catalog { #updateCatalog }

```scala
updateCatalog(
  spark: SparkSession,
  table: CatalogTable,
  snapshot: Snapshot,
  didNotChangeMetadata: Boolean): Unit
```

??? warning "Procedure"
    `updateCatalog` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

??? note "`didNotChangeMetadata` Not Used"

`updateCatalog` prints out the following INFO message to the logs:

```text
Table is path-based table: [tableByPath]. Update catalog with mode: [operation]
```

`updateCatalog` requests the given [DeltaLog](#deltaLog) to [update](../../SnapshotManagement.md#update).

`updateCatalog` [updates the catalog](#updateCatalog).

In the end, when [delta.universalFormat.enabledFormats](../../table-properties/DeltaConfigs.md#universalFormat.enabledFormats) table property contains `iceberg`, `updateCatalog` requests the `UniversalFormatConverter` to [convertSnapshot](../../uniform/UniversalFormatConverter.md#convertSnapshot).

### handleCreateTable { #handleCreateTable }

```scala
handleCreateTable(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  tableWithLocation: CatalogTable,
  fs: FileSystem,
  hadoopConf: Configuration): Unit
```

`handleCreateTable`...FIXME

### handleCreateTableAsSelect { #handleCreateTableAsSelect }

```scala
handleCreateTableAsSelect(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  deltaLog: DeltaLog,
  deltaWriter: WriteIntoDeltaLike,
  tableWithLocation: CatalogTable): Unit
```

`handleCreateTableAsSelect`...FIXME

## Provided Metadata { #getProvidedMetadata }

```scala
getProvidedMetadata(
  table: CatalogTable,
  schemaString: String): Metadata
```

`getProvidedMetadata` gives a new [Metadata](../../Metadata.md) with the values copied directly from the given `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable)).

This `Metadata` has got [clustering columns property removed](../../liquid-clustering/ClusteredTableUtilsBase.md#removeClusteringColumnsProperty) from the table properties and uses the given schema (`schemaString`).

---

`getProvidedMetadata` creates a [Metadata](../../Metadata.md) with the following:

Metadata | Value
---------|------
 [Description](../../Metadata.md#description) | The `comment` of the given `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable)), if defined
 [Schema](../../Metadata.md#schemaString) | The given `schemaString`
 [Partition Columns](../../Metadata.md#partitionColumns) | The `partitionColumnNames` of the given `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable))
 [Table Configuration](../../Metadata.md#configuration) | [clustering columns property removed](../../liquid-clustering/ClusteredTableUtilsBase.md#removeClusteringColumnsProperty) from the `properties` of the given `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable))
 [Created Time](../../Metadata.md#createdTime) | The current time

---

`getProvidedMetadata` is used when:

* `CreateDeltaTableCommand` is requested to [handleCreateTable](#handleCreateTable) and [replaceMetadataIfNecessary](#replaceMetadataIfNecessary)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.CreateDeltaTableCommand` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.CreateDeltaTableCommand.name = org.apache.spark.sql.delta.commands.CreateDeltaTableCommand
logger.CreateDeltaTableCommand.level = all
```

Refer to [Logging](../../logging.md).
