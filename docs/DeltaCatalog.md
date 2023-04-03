# DeltaCatalog

`DeltaCatalog` is a `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/)) and a [StagingTableCatalog](#StagingTableCatalog).

`DeltaCatalog` is [registered](installation.md) using `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog)) configuration property.

## <span id="StagingTableCatalog"> StagingTableCatalog

`DeltaCatalog` is a `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/)) that creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (for [delta data source](delta/DeltaSourceUtils.md#isDeltaDataSourceName)) or a `BestEffortStagedTable`.

### <span id="stageCreate"> stageCreate

```scala
stageCreate(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): StagedTable
```

`stageCreate` is part of the `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/#stageCreate)) abstraction.

---

`stageCreate` creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (with `TableCreationModes.Create` operation) for [delta data source](delta/DeltaSourceUtils.md#isDeltaDataSourceName) only (based on the given `properties` or [spark.sql.sources.default](#getProvider) configuration property).

Otherwise, `stageCreate` creates a `BestEffortStagedTable` (requesting the parent `TableCatalog` to create a table).

### <span id="stageCreateOrReplace"> stageCreateOrReplace

```scala
stageCreateOrReplace(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): StagedTable
```

`stageCreateOrReplace` is part of the `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/#stageCreateOrReplace)) abstraction.

---

`stageCreateOrReplace` creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (with `TableCreationModes.CreateOrReplace` operation) for [delta data source](delta/DeltaSourceUtils.md#isDeltaDataSourceName) only (based on the given `properties` or [spark.sql.sources.default](#getProvider) configuration property).

Otherwise, `stageCreateOrReplace` requests the parent `TableCatalog` to drop the table first and then creates a `BestEffortStagedTable` (requesting the parent `TableCatalog` to create the table).

### <span id="stageReplace"> stageReplace

```scala
stageReplace(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): StagedTable
```

`stageReplace` is part of the `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/#stageReplace)) abstraction.

---

`stageReplace` creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (with `TableCreationModes.Replace` operation) for [delta data source](delta/DeltaSourceUtils.md#isDeltaDataSourceName) only (based on the given `properties` or [spark.sql.sources.default](#getProvider) configuration property).

Otherwise, `stageReplace` requests the parent `TableCatalog` to drop the table first and then creates a `BestEffortStagedTable` (requesting the parent `TableCatalog` to create the table).

## <span id="alterTable"> Altering Table

```scala
alterTable(
  ident: Identifier,
  changes: TableChange*): Table
```

`alterTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#alterTable)) abstraction.

---

`alterTable` [loads the table](#loadTable) and continues only when it is a [DeltaTableV2](DeltaTableV2.md). Otherwise, `alterTable` delegates to the parent `TableCatalog`.

`alterTable` groups the given `TableChange`s by their (class) type.

In addition, `alterTable` collects the following `ColumnChange`s together (that are then executed as column updates as [AlterTableChangeColumnDeltaCommand](commands/alter/AlterTableChangeColumnDeltaCommand.md)):

* `RenameColumn`
* `UpdateColumnComment`
* `UpdateColumnNullability`
* `UpdateColumnPosition`
* `UpdateColumnType`

`alterTable` executes the table changes as one of [AlterDeltaTableCommand](commands/alter/AlterDeltaTableCommand.md)s.

TableChange | AlterDeltaTableCommand
------------|----------
 `AddColumn` | [AlterTableAddColumnsDeltaCommand](commands/alter/AlterTableAddColumnsDeltaCommand.md)
 `AddConstraint` | [AlterTableAddConstraintDeltaCommand](commands/alter/AlterTableAddConstraintDeltaCommand.md)
 `ColumnChange` | [AlterTableChangeColumnDeltaCommand](commands/alter/AlterTableChangeColumnDeltaCommand.md)
 `DropConstraint` | [AlterTableDropConstraintDeltaCommand](commands/alter/AlterTableDropConstraintDeltaCommand.md)
 `RemoveProperty` | [AlterTableUnsetPropertiesDeltaCommand](commands/alter/AlterTableUnsetPropertiesDeltaCommand.md)
 `SetLocation`<br>(`SetProperty` with `location` property)<br>catalog delta tables only | [AlterTableSetLocationDeltaCommand](commands/alter/AlterTableSetLocationDeltaCommand.md)
 `SetProperty` | [AlterTableSetPropertiesDeltaCommand](commands/alter/AlterTableSetPropertiesDeltaCommand.md)

`alterTable`...FIXME

## <span id="createTable"> Creating Table

```scala
createTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): Table
```

`createTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#createTable)) abstraction.

---

`createTable`...FIXME

## <span id="loadTable"> Loading Table

```scala
loadTable(
  ident: Identifier): Table
```

`loadTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#loadTable)) abstraction.

---

`loadTable` loads a table by the given identifier from a catalog.

If found and the table is a delta table (Spark SQL's [V1Table]({{ book.spark_sql }}/connector/V1Table/) with `delta` provider), `loadTable` creates a [DeltaTableV2](DeltaTableV2.md).

## <span id="createDeltaTable"> Creating Delta Table

```scala
createDeltaTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  allTableProperties: Map[String, String],
  writeOptions: Map[String, String],
  sourceQuery: Option[DataFrame],
  operation: TableCreationModes.CreationMode): Table
```

`createDeltaTable`...FIXME

`createDeltaTable` is used when:

* `DeltaCatalog` is requested to [create a table](#createTable)
* `StagedDeltaTableV2` is requested to [commitStagedChanges](StagedDeltaTableV2.md#commitStagedChanges)

### <span id="createDeltaTable-operation"> Operation

`createDeltaTable` is given an argument of type `TableCreationModes.CreationMode`:

* `Create` when [DeltaCatalog creates a table](#createTable)
* `StagedDeltaTableV2` is given a [CreationMode](StagedDeltaTableV2.md#operation) when created

## <span id="getProvider"> Looking Up Table Provider

```scala
getProvider(
  properties: util.Map[String, String]): String
```

`getProvider` takes the value of the `provider` from the given `properties` (if available) or defaults to the value of `spark.sql.sources.default` ([Spark SQL]({{ book.spark_sql }}/configuration-properties#spark.sql.sources.default)) configuration property.

`getProvider` is used when:

* `DeltaCatalog` is requested to [createTable](#createTable), [stageReplace](#stageReplace), [stageCreateOrReplace](#stageCreateOrReplace) and [stageCreate](#stageCreate)
