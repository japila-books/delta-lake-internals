# DeltaCatalog

**DeltaCatalog** is an extension of Spark SQL (using `DelegatingCatalogExtension` and `StagingTableCatalog`).

`DeltaCatalog` is [registered](installation.md) using **spark.sql.catalog.spark_catalog** configuration property (while creating a SparkSession in a Spark application).

== [[alterTable]] Altering Table

[source,scala]
----
alterTable(
  ident: Identifier,
  changes: TableChange*): Table
----

alterTable...FIXME

alterTable is part of the TableCatalog (Spark SQL 3.0.0) abstraction.

## <span id="createTable"> Creating Table

```scala
createTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): Table
```

`createTable`...FIXME

`createTable` is part of the `TableCatalog` ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/connector/catalog/TableCatalog/)) abstraction.

== [[loadTable]] Loading Table

[source,scala]
----
loadTable(
  ident: Identifier): Table
----

loadTable...FIXME

loadTable is part of the TableCatalog (Spark SQL 3.0.0) abstraction.

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
