# DeltaTable

*DeltaTable* is the <<operators, management interface>> of a Delta table (with the <<DeltaTableOperations.adoc#, Delta DML Operations>>).

DeltaTable instances are created for existing Delta tables using <<forPath, DeltaTable.forPath>> utility (static method).

You can convert parquet tables to delta format (by importing the tables into Delta Lake) using <<convertToDelta, DeltaTable.convertToDelta>> utility (static method).

You can check whether a directory is part of a delta table using <<isDeltaTable, DeltaTable.isDeltaTable>> utility (static method).

== [[creating-instance]] Creating Instance

DeltaTable takes the following to be created:

* [[df]] Distributed structured query to access table data (`Dataset[Row]`)
* [[deltaLog]] DeltaLog.adoc[]

NOTE: New DeltaTable instances should be created using <<forPath, DeltaTable.forPath>> and <<convertToDelta, DeltaTable.convertToDelta>> utilities.

== [[operators]] Operators

=== [[alias]] alias

[source, scala]
----
alias(
  alias: String): DeltaTable
----

Applies an alias to the DeltaTable (equivalent to <<as, as>>)

=== [[as]] as

[source, scala]
----
as(
  alias: String): DeltaTable
----

Applies an alias to the DeltaTable (equivalent to <<alias, alias>>)

=== [[delete]] delete

[source, scala]
----
delete(): Unit // <1>
delete(
  condition: Column): Unit
delete(
  condition: String): Unit
----
<1> Undefined condition

Deletes data from the DeltaTable that matches the given `condition`.

IMPORTANT: <<delete, delete>> and <<update, update>> operators do not support subqueries (and <<DeltaTableOperations.adoc#subqueryNotSupportedCheck, throw an AnalysisException>> otherwise).

=== [[generate]] generate

[source, scala]
----
generate(
  mode: String): Unit
----

Generates a manifest for the delta table

Internally, `generate` <<DeltaTableOperations.adoc#executeGenerate, executeGenerate>> with the table ID of the format `++delta.`path`++` (where the path is the <<DeltaLog.adoc#dataPath, data directory>> of the <<deltaLog, DeltaLog>>) and the given mode.

=== [[history]] history

[source, scala]
----
history(): DataFrame // <1>
history(
  limit: Int): DataFrame
----
<1> Unlimited history

Gets available commits (_history_) on the DeltaTable

=== [[merge]] merge

```scala
merge(
  source: DataFrame,
  condition: Column): DeltaMergeBuilder
merge(
  source: DataFrame,
  condition: String): DeltaMergeBuilder
```

Creates a [DeltaMergeBuilder](DeltaMergeBuilder.md) to describe how to merge data from a source `DataFrame` into this delta table (based on the condition).

=== [[toDF]] toDF

[source, scala]
----
toDF: Dataset[Row]
----

Gets the DataFrame representation of the DeltaTable

=== [[update]] update

[source, scala]
----
update(
  condition: Column,
  set: Map[String, Column]): Unit
update(
  condition: Column,
  set: java.util.Map[String, Column]): Unit
update(
  set: Map[String, Column]): Unit
update(
  set: java.util.Map[String, Column]): Unit
----

Updates data in the DeltaTable on the rows that match the given `condition` based on the rules defined by `set`

IMPORTANT: <<delete, delete>> and <<update, update>> operators do not support subqueries (and <<DeltaTableOperations.adoc#subqueryNotSupportedCheck, throw an AnalysisException>> otherwise).

=== [[updateExpr]] updateExpr

[source, scala]
----
updateExpr(
  set: Map[String, String]): Unit
updateExpr(
  set: java.util.Map[String, String]): Unit
updateExpr(
  condition: String,
  set: Map[String, String]): Unit
updateExpr(
  condition: String,
  set: java.util.Map[String, String]): Unit
----

Updates data in the DeltaTable on the rows that match the given `condition` based on the rules defined by `set`

=== [[vacuum]] vacuum

[source, scala]
----
vacuum(): DataFrame // <1>
vacuum(
  retentionHours: Double): DataFrame
----
<1> Undefined retention threshold

Deletes files and directories (recursively) in the DeltaTable that are not needed by the table (and maintains older versions up to the given retention threshold).

Internally, `vacuum` simply <<DeltaTableOperations.adoc#executeVacuum, executes vacuum command>>.

== [[utilities]] Utilities

=== [[convertToDelta]] convertToDelta

[source, scala]
----
convertToDelta(
  spark: SparkSession,
  identifier: String,
  partitionSchema: StructType): DeltaTable
convertToDelta(
  spark: SparkSession,
  identifier: String,
  partitionSchema: String): DeltaTable  // <1>
convertToDelta(
  spark: SparkSession,
  identifier: String): DeltaTable
----
<1> Creates `StructType` from the given DDL-formatted `partitionSchema` string

`convertToDelta` converts a parquet table to delta format (and makes the table available in Delta Lake).

TIP: Refer to demo:Converting-Parquet-Dataset-Into-Delta-Format.adoc[Demo: Converting Parquet Dataset Into Delta Format] for a demo of `DeltaTable.convertToDelta`.

Internally, `convertToDelta` requests the `SparkSession` for the SQL parser (`ParserInterface`) that is in turn requested to parse the given table identifier (to get a `TableIdentifier`).

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-ParserInterface.html[ParserInterface] in https://bit.ly/spark-sql-internals[The Internals of Spark SQL] online book.

In the end, `convertToDelta` uses the `DeltaConvert` utility to <<DeltaConvert.adoc#executeConvert, convert the parquet table to delta format>> and <<forPath, creates a DeltaTable>>.

=== [[forName]] forName

[source, scala]
----
forName(
  tableOrViewName: String): DeltaTable // <1>
forName(
  sparkSession: SparkSession,
  tableName: String): DeltaTable
----
<1> Uses the active SparkSession

forName uses ParserInterface (of the given SparkSession) to parse the given table name.

forName DeltaTableUtils.adoc#isDeltaTable[checks whether the given table name is of a Delta table] and, if so, creates a DeltaTable with the following:

* Dataset that represents loading data from the specified table name (using `SparkSession.table` operator)

* DeltaLog.adoc#forTable[DeltaLog] of the specified table

forName throws an AnalysisException when the given table name is for non-Delta table:

[source,plaintext]
----
[deltaTableIdentifier] is not a Delta table.
----

forName is used internally when DeltaConvert utility is used to DeltaConvert.adoc#executeConvert[executeConvert].

=== [[forPath]] forPath

[source, scala]
----
forPath(
  path: String): DeltaTable // <1>
forPath(
  sparkSession: SparkSession,
  path: String): DeltaTable
----
<1> Uses the active SparkSession

forPath creates a DeltaTable instance for data in the given directory (`path`) when the given <<DeltaTableUtils.adoc#isDeltaTable, directory is part of a delta table>> already (as the root or a child directory).

[source]
----
assert(spark.isInstanceOf[org.apache.spark.sql.SparkSession])

val tableId = "/tmp/delta-table/users"

import io.delta.tables.DeltaTable
assert(DeltaTable.isDeltaTable(tableId), s"$tableId should be a Delta table")

val dt = DeltaTable.forPath("delta-table")
----

forPath throws an `AnalysisException` when the given `path` does not belong to a delta table:


[source,plaintext]
----
[deltaTableIdentifier] is not a Delta table.
----

Internally, forPath creates a new <<DeltaTable, DeltaTable>> with the following:

* `Dataset` that represents loading data from the specified `path` using <<DeltaDataSource.adoc#delta-format, delta>> data source

* <<DeltaLog.adoc#, DeltaLog>> for the <<DeltaLog.adoc#forTable, (transaction log in) the specified path>>

forPath is used internally in <<convertToDelta, DeltaTable.convertToDelta>> (via DeltaConvert.adoc[] utility).

=== [[isDeltaTable]] isDeltaTable

[source, scala]
----
isDeltaTable(
  identifier: String): Boolean
isDeltaTable(
  sparkSession: SparkSession,
  identifier: String): Boolean
----

isDeltaTable checks whether or not the provided `identifier` string is a file path that points to the root of a Delta table or one of the subdirectories.

Internally, isDeltaTable simply relays to <<DeltaTableUtils.adoc#isDeltaTable, DeltaTableUtils.isDeltaTable>> utility.

== [[unapply]] unapply Extractor Utility

[source, scala]
----
unapply(
  a: LogicalRelation): Option[TahoeFileIndex]
----

`unapply` simply destructures the given `LogicalRelation` and takes out the <<TahoeFileIndex.adoc#, TahoeFileIndex>> from the `HadoopFsRelation` relation.

[NOTE]
====
`unapply` is used when:

* `DeltaSink` is requested to <<DeltaSink.adoc#addBatch, addBatch>>

* `DeltaDataSource` utility is used to <<DeltaDataSource.adoc#extractDeltaPath, extractDeltaPath>> (but does not seem to be used whatsoever)
====

== [[demo]] Demo

[source, scala]
----
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

val path = "/tmp/delta/t1"

// random data to create a delta table from scratch
val data = spark.range(5)
data.write.format("delta").save(path)

import io.delta.tables.DeltaTable
val dt = DeltaTable.forPath(spark, path)

val history = dt.history.select('version, 'timestamp, 'operation, 'operationParameters, 'isBlindAppend)
scala> history.show(truncate = false)
+-------+-------------------+---------+------------------------------------------+-------------+
|version|timestamp          |operation|operationParameters                       |isBlindAppend|
+-------+-------------------+---------+------------------------------------------+-------------+
|0      |2019-12-23 22:24:40|WRITE    |[mode -> ErrorIfExists, partitionBy -> []]|true         |
+-------+-------------------+---------+------------------------------------------+-------------+
----
