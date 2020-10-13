# DeltaDataSource

`DeltaDataSource` is a <<DataSourceRegister, DataSourceRegister>> and acts as the entry point to all features provided by `delta` data source.

`DeltaDataSource` is a <<RelationProvider, RelationProvider>>.

`DeltaDataSource` is a <<StreamSinkProvider, StreamSinkProvider>> for a streaming sink for streaming queries (Structured Streaming).

## <span id="RelationProvider"><span id="RelationProvider-createRelation"> RelationProvider - Creating Insertable HadoopFsRelation For Batch Queries

DeltaDataSource is a `RelationProvider` for reading (_loading_) data from a delta table in a structured query.

!!! tip
    Read up on [RelationProvider](https://jaceklaskowski.github.io/mastering-spark-sql-book/spark-sql-RelationProvider/) in [The Internals of Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book) online book.

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` [verify the given parameters](DeltaOptions.md#verifyOptions).

`createRelation` [extracts time travel specification](#getTimeTravelVersion) from the given parameters.

In the end, `createRelation` creates a [DeltaTableV2](DeltaTableV2.md) and requests it for an [insertable HadoopFsRelation](DeltaTableV2.md#toBaseRelation).

`createRelation` throws an `IllegalArgumentException` when `path` option is not specified:

```text
'path' is not specified
```

## <span id="sourceSchema"> sourceSchema

```scala
sourceSchema(
  sqlContext: SQLContext,
  schema: Option[StructType],
  providerName: String,
  parameters: Map[String, String]): (String, StructType)
```

`sourceSchema` [creates a DeltaLog](DeltaLog.md#forTable) for a Delta table in the directory specified by the required `path` option (in the parameters) and returns the [delta](#shortName) name with the schema (of the Delta table).

`sourceSchema` throws an `IllegalArgumentException` when the `path` option has not been specified:

```text
'path' is not specified
```

`sourceSchema` throws an `AnalysisException` when the `path` option [uses time travel](DeltaTableUtils.md#extractIfPathContainsTimeTravel):

```text
Cannot time travel views, subqueries or streams.
```

`sourceSchema` is part of the `StreamSourceProvider` abstraction ([Spark Structured Streaming](https://jaceklaskowski.github.io/spark-structured-streaming-book/StreamSourceProvider/)).

## Utilities

## <span id="getTimeTravelVersion"> getTimeTravelVersion

```scala
getTimeTravelVersion(
  parameters: Map[String, String]): Option[DeltaTimeTravelSpec]
```

`getTimeTravelVersion`...FIXME

`getTimeTravelVersion` is used when `DeltaDataSource` is requested to [create a relation (as a RelationProvider)](#RelationProvider-createRelation).

## <span id="parsePathIdentifier"> parsePathIdentifier

```scala
parsePathIdentifier(
  spark: SparkSession,
  userPath: String): (Path, Seq[(String, String)], Option[DeltaTimeTravelSpec])
```

`parsePathIdentifier`...FIXME

`parsePathIdentifier` is used when `DeltaTableV2` is requested for the [rootPath, partitionFilters, and timeTravelByPath](DeltaTableV2.md#rootPath) (for a non-catalog table).

== [[delta-format]][[DataSourceRegister]] DataSourceRegister for delta alias

`DeltaDataSource` is a `DataSourceRegister` and registers itself to be available using `delta` alias.

.Reading From Delta Table
[source, scala]
----
assert(spark.isInstanceOf[org.apache.spark.sql.SparkSession])
spark.read.format("delta")
spark.readStream.format("delta")
----

.Writing To Delta Table
[source, scala]
----
assert(df.isInstanceOf[org.apache.spark.sql.Dataset[_]])
df.write.format("delta")
df.writeStream.format("delta")
----

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-DataSourceRegister.html[DataSourceRegister] in https://bit.ly/spark-sql-internals[The Internals of Spark SQL] online book.

DeltaDataSource is registered using `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister`:

[source, scala]
----
org.apache.spark.sql.delta.sources.DeltaDataSource
----

== [[CreatableRelationProvider]][[CreatableRelationProvider-createRelation]] CreatableRelationProvider

DeltaDataSource is a `CreatableRelationProvider` for writing out the result of a structured query.

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-CreatableRelationProvider.html[CreatableRelationProvider] in https://bit.ly/spark-sql-internals[The Internals of Spark SQL] online book.

== [[StreamSourceProvider]][[createSource]] Creating Streaming Source (Structured Streaming) -- `createSource` Method

DeltaDataSource is a `StreamSourceProvider`.

TIP: Read up on https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-StreamSourceProvider.html[StreamSourceProvider] in https://bit.ly/spark-structured-streaming[The Internals of Spark Structured Streaming] online book.

== [[StreamSinkProvider]][[createSink]] Creating Streaming Sink (Structured Streaming) -- `createSink` Method

DeltaDataSource is a `StreamSinkProvider` for a streaming sink for Structured Streaming.

TIP: Read up on https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-StreamSinkProvider.html[StreamSinkProvider] in https://bit.ly/spark-structured-streaming[The Internals of Spark Structured Streaming] online book.

DeltaDataSource supports `Append` and `Complete` output modes only.

In the end, DeltaDataSource creates a <<DeltaSink.md#, DeltaSink>>.

TIP: Consult the demo <<demo-Using-Delta-Lake-as-Streaming-Sink-in-Structured-Streaming.md#, Using Delta Lake (as Streaming Sink) in Streaming Queries>>.

== [[extractDeltaPath]] `extractDeltaPath` Utility

[source, scala]
----
extractDeltaPath(
  dataset: Dataset[_]): Option[String]
----

`extractDeltaPath`...FIXME

NOTE: `extractDeltaPath` does not seem to be used whatsoever.

== [[getTable]] Loading Table

[source,scala]
----
getTable(
  schema: StructType,
  partitioning: Array[Transform],
  properties: java.util.Map[String, String]): Table
----

getTable...FIXME

getTable is part of the TableProvider (Spark SQL 3.0.0) abstraction.
