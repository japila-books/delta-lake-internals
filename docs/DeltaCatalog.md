= DeltaCatalog

*DeltaCatalog* is an extension of Spark SQL (using DelegatingCatalogExtension and StagingTableCatalog).

DeltaCatalog is registered using *spark.sql.catalog.spark_catalog* configuration property while creating a SparkSession in a Spark application. Consult installation.adoc[].

== [[alterTable]] Altering Table

[source,scala]
----
alterTable(
  ident: Identifier,
  changes: TableChange*): Table
----

alterTable...FIXME

alterTable is part of the TableCatalog (Spark SQL 3.0.0) abstraction.

== [[createTable]] Creating Table

[source,scala]
----
createTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String]): Table
----

createTable...FIXME

createTable is part of the TableCatalog (Spark SQL 3.0.0) abstraction.

== [[loadTable]] Loading Table

[source,scala]
----
loadTable(
  ident: Identifier): Table
----

loadTable...FIXME

loadTable is part of the TableCatalog (Spark SQL 3.0.0) abstraction.

== [[createDeltaTable]] createDeltaTable Internal Method

[source,scala]
----
createDeltaTable(
  ident: Identifier,
  schema: StructType,
  partitions: Array[Transform],
  properties: util.Map[String, String],
  sourceQuery: Option[LogicalPlan],
  operation: TableCreationModes.CreationMode): Table
----

createDeltaTable...FIXME

createDeltaTable is used when:

* DeltaCatalog is requested to <<createTable, createTable>>

* StagedDeltaTableV2 is requested to StagedDeltaTableV2.adoc#commitStagedChanges[commitStagedChanges]
