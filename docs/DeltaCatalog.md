# DeltaCatalog

`DeltaCatalog` is a `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/)) and a `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/)).

`DeltaCatalog` is [registered](installation.md) using **spark.sql.catalog.spark_catalog** configuration property (while creating a `SparkSession` in a Spark application).

## <span id="alterTable"> Altering Table

```scala
alterTable(
  ident: Identifier,
  changes: TableChange*): Table
```

`alterTable`...FIXME

`alterTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#alterTable)) abstraction.

## <span id="createTable"> Creating Table

```scala
createTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): Table
```

`createTable`...FIXME

`createTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#createTable)) abstraction.

## <span id="loadTable"> Loading Table

```scala
loadTable(
  ident: Identifier): Table
```

`loadTable` loads a table by the given identifier from a catalog.

If found and the table is a delta table (Spark SQL's [V1Table]({{ book.spark_sql }}/connector/V1Table/) with `delta` provider), `loadTable` creates a [DeltaTableV2](DeltaTableV2.md).

`loadTable` is part of the `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog/#loadTable)) abstraction.

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
