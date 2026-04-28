# DeltaCatalog

`DeltaCatalog` is a concrete [AbstractDeltaCatalog](AbstractDeltaCatalog.md).

## loadCatalogTable { #loadCatalogTable }

??? note "AbstractDeltaCatalog"

    ```java
    Table loadCatalogTable(
      Identifier ident,
      CatalogTable catalogTable)
    ```

    `loadCatalogTable` is part of the [AbstractDeltaCatalog](AbstractDeltaCatalog.md#loadCatalogTable) abstraction.

`loadCatalogTable`...FIXME

<!--
`DeltaCatalog` is [registered](installation.md) using `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog)) configuration property.

## Altering Table { #alterTable }

??? note "TableCatalog"

    ```scala
    alterTable(
      ident: Identifier,
      changes: TableChange*): Table
    ```

    `alterTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#alterTable)) abstraction.

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

## Creating Table { #createTable }

??? note "TableCatalog"

    ```scala
    createTable(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: util.Map[String, String]): Table
    ```

    `createTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#createTable)) abstraction.

`createTable`...FIXME

## Loading Table { #loadTable }

??? note "TableCatalog"

    ```scala
    loadTable(
      ident: Identifier): Table
    ```

    `loadTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#loadTable)) abstraction.

`loadTable` loads a table by the given identifier from a catalog.

If found and the table is a delta table (Spark SQL's [V1Table]({{ book.spark_sql }}/connector/V1Table/) with `delta` provider), `loadTable` creates a [DeltaTableV2](DeltaTableV2.md).

## Looking Up Table Provider { #getProvider }

```scala
getProvider(
  properties: util.Map[String, String]): String
```

`getProvider` takes the value of the `provider` from the given `properties` (if available) or defaults to the value of `spark.sql.sources.default` ([Spark SQL]({{ book.spark_sql }}/configuration-properties#spark.sql.sources.default)) configuration property.

---

`getProvider` is used when:

* `DeltaCatalog` is requested to [createTable](#createTable), [stageReplace](#stageReplace), [stageCreateOrReplace](#stageCreateOrReplace) and [stageCreate](#stageCreate)
-->
