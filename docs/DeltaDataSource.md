# DeltaDataSource

`DeltaDataSource` is a [DataSourceRegister](#DataSourceRegister) and is the entry point to all the features provided by `delta` data source.

`DeltaDataSource` is a [RelationProvider](#RelationProvider).

`DeltaDataSource` is a [StreamSinkProvider](#StreamSinkProvider) for a streaming sink for streaming queries (Structured Streaming).

## <span id="delta-format"><span id="DataSourceRegister"> DataSourceRegister and delta Alias

`DeltaDataSource` is a `DataSourceRegister` ([Spark SQL]({{ book.spark_sql }}/DataSourceRegister)) and registers **delta** alias.

DeltaDataSource is registered using `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister`:

```text
org.apache.spark.sql.delta.sources.DeltaDataSource
```

## <span id="RelationProvider"><span id="RelationProvider-createRelation"><span id="createRelation"> RelationProvider for Batch Queries

DeltaDataSource is a `RelationProvider` ([Spark SQL]({{ book.spark_sql }}/RelationProvider)) for reading (_loading_) data from a delta table in a structured query.

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` reads the `path` option from the given parameters.

`createRelation` [verifies the given parameters](DeltaOptions.md#verifyOptions).

`createRelation` [extracts time travel specification](#getTimeTravelVersion) from the given parameters.

In the end, `createRelation` creates a [DeltaTableV2](DeltaTableV2.md) (for the `path` option and the time travel specification) and requests it for an [insertable HadoopFsRelation](DeltaTableV2.md#toBaseRelation).

`createRelation` throws an `IllegalArgumentException` when `path` option is not specified:

```text
'path' is not specified
```

## <span id="sourceSchema"> Source Schema

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

`sourceSchema` is part of the `StreamSourceProvider` abstraction ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSourceProvider/)).

## <span id="CreatableRelationProvider"><span id="CreatableRelationProvider-createRelation"> CreatableRelationProvider

DeltaDataSource is a `CreatableRelationProvider` ([Spark SQL]({{ book.spark_sql }}/CreatableRelationProvider)) for writing out the result of a structured query.

## <span id="StreamSourceProvider"><span id="createSource"> Creating Streaming Source

DeltaDataSource is a `StreamSourceProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSourceProvider)) for a streaming source in streaming queries.

## <span id="StreamSinkProvider"><span id="createSink"> Creating Streaming Sink

DeltaDataSource is a `StreamSinkProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSinkProvider)) for a streaming sink in streaming queries.

DeltaDataSource supports `Append` and `Complete` output modes only.

In the end, DeltaDataSource creates a [DeltaSink](DeltaSink.md).

!!! tip
    Consult the demo [Using Delta Lake (as Streaming Sink) in Streaming Queries](demo/Using-Delta-Lake-as-Streaming-Sink-in-Structured-Streaming.md).

## <span id="getTable"> Loading Table

```scala
getTable(
  schema: StructType,
  partitioning: Array[Transform],
  properties: java.util.Map[String, String]): Table
```

`getTable`...FIXME

`getTable` is part of the `TableProvider` (Spark SQL 3.0.0) abstraction.

## Utilities

### <span id="getTimeTravelVersion"> getTimeTravelVersion

```scala
getTimeTravelVersion(
  parameters: Map[String, String]): Option[DeltaTimeTravelSpec]
```

`getTimeTravelVersion`...FIXME

`getTimeTravelVersion` is used when `DeltaDataSource` is requested to [create a relation (as a RelationProvider)](#RelationProvider-createRelation).

### <span id="parsePathIdentifier"> parsePathIdentifier

```scala
parsePathIdentifier(
  spark: SparkSession,
  userPath: String): (Path, Seq[(String, String)], Option[DeltaTimeTravelSpec])
```

`parsePathIdentifier`...FIXME

`parsePathIdentifier` is used when `DeltaTableV2` is requested for [metadata](DeltaTableV2.md#rootPath) (for a non-catalog table).
