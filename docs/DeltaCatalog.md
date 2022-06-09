# DeltaCatalog

`DeltaCatalog` is a `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/)) and a `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/)).

`DeltaCatalog` is [registered](installation.md) using `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog)) configuration property.

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

`ColumnChange`s are collected together as column updates (and executed as [AlterTableChangeColumnDeltaCommand](commands/alter/AlterTableChangeColumnDeltaCommand.md)):

* `UpdateColumnComment`
* `UpdateColumnType`
* `UpdateColumnPosition`
* `UpdateColumnNullability`
* `RenameColumn`

`alterTable` executes the table changes as [AlterDeltaTableCommand](commands/alter/AlterDeltaTableCommand.md).

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

`createTable`...FIXME

## <span id="loadTable"> Loading Table

```scala
loadTable(
  ident: Identifier): Table
```

`loadTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#loadTable)) abstraction.

`loadTable` loads a table by the given identifier from a catalog.

If found and the table is a delta table (Spark SQL's [V1Table]({{ book.spark_sql }}/connector/V1Table/) with `delta` provider), `loadTable` creates a [DeltaTableV2](DeltaTableV2.md).

## <span id="createDeltaTable"> Creating Delta Table

```scala
createDeltaTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String],
  sourceQuery: Option[LogicalPlan],
  operation: TableCreationModes.CreationMode): Table
```

`createDeltaTable`...FIXME

`createDeltaTable` is used when:

* `DeltaCatalog` is requested to [createTable](#createTable)
* `StagedDeltaTableV2` is requested to [commitStagedChanges](StagedDeltaTableV2.md#commitStagedChanges)
