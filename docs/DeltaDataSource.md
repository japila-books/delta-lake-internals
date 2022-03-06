# DeltaDataSource

`DeltaDataSource` is a [DataSourceRegister](#DataSourceRegister) and is the entry point to all the features provided by `delta` data source that supports batch and streaming queries.

## <span id="delta-format"><span id="DataSourceRegister"> DataSourceRegister and delta Alias

`DeltaDataSource` is a `DataSourceRegister` ([Spark SQL]({{ book.spark_sql }}/DataSourceRegister)) and registers **delta** alias.

`DeltaDataSource` is registered using [META-INF/services/org.apache.spark.sql.sources.DataSourceRegister]({{ delta.github }}/core/src/main/resources/META-INF/services/org.apache.spark.sql.sources.DataSourceRegister):

```text
org.apache.spark.sql.delta.sources.DeltaDataSource
```

## <span id="RelationProvider"> RelationProvider

`DeltaDataSource` is a `RelationProvider` ([Spark SQL]({{ book.spark_sql }}/RelationProvider)).

### <span id="RelationProvider-createRelation"> Creating Relation

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` [verifies the given parameters](DeltaOptions.md#verifyOptions).

`createRelation` [extracts time travel specification](#getTimeTravelVersion) from the given parameters.

With [spark.databricks.delta.loadFileSystemConfigsFromDataFrameOptions](DeltaSQLConf.md#LOAD_FILE_SYSTEM_CONFIGS_FROM_DATAFRAME_OPTIONS) enabled, `createRelation` uses the given `parameters` as `options`.

In the end, `createRelation` creates a [DeltaTableV2](DeltaTableV2.md) (with the required `path` option and the optional time travel specification) and requests it for an [insertable HadoopFsRelation](DeltaTableV2.md#toBaseRelation).

---

`createRelation` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

```text
'path' is not specified
```

---

`createRelation` is part of the `RelationProvider` ([Spark SQL]({{ book.spark_sql }}/RelationProvider/#createRelation)) abstraction.

## <span id="CreatableRelationProvider"> CreatableRelationProvider

`DeltaDataSource` is a `CreatableRelationProvider` ([Spark SQL]({{ book.spark_sql }}/CreatableRelationProvider)).

### <span id="CreatableRelationProvider-createRelation"> Creating Relation

```scala
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  data: DataFrame): BaseRelation
```

`createRelation` [creates a DeltaLog](DeltaLog.md#forTable) for the required `path` parameter (from the given `parameters`) and the given `parameters` itself.

`createSource` creates a [DeltaOptions](DeltaOptions.md) (with the given `parameters` and the current `SQLConf`).

`createRelation` [creates and executes a WriteIntoDelta command](commands/WriteIntoDelta.md) for the given `data`.

In the end, `createRelation` requests the `DeltaLog` for a [HadoopFsRelation](DeltaLog.md#createRelation).

---

`createRelation` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

```text
'path' is not specified
```

---

`createRelation` is part of the `CreatableRelationProvider` ([Spark SQL]({{ book.spark_sql }}/CreatableRelationProvider/#createRelation)) abstraction.

## <span id="StreamSourceProvider"> StreamSourceProvider

`DeltaDataSource` is a `StreamSourceProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSourceProvider)).

### <span id="createSource"> Creating DeltaSource

```scala
createSource(
  sqlContext: SQLContext,
  metadataPath: String,
  schema: Option[StructType],
  providerName: String,
  parameters: Map[String, String]): Source
```

`createSource` [creates a DeltaLog](DeltaLog.md#forTable) for the required `path` parameter (from the given `parameters`).

`createSource` creates a [DeltaOptions](DeltaOptions.md) (with the given `parameters` and the current `SQLConf`).

In the end, `createSource` creates a [DeltaSource](DeltaSource.md) (with the `DeltaLog` and the `DeltaOptions`).

---

`createSource` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

```text
'path' is not specified
```

---

`createSource` makes sure that there is no `schema` specified or throws an `AnalysisException`:

```text
Delta does not support specifying the schema at read time.
```

---

`createSource` makes sure that there is [schema](Snapshot.md#schema) available (in the [Snapshot](SnapshotManagement.md#snapshot)) of the `DeltaLog` or throws an `AnalysisException`:

```text
Table schema is not set.  Write data into it or use CREATE TABLE to set the schema.
```

---

`createSource` is part of the `StreamSourceProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSourceProvider/#createSource)) abstraction.

### <span id="sourceSchema"> Streaming Schema

```scala
sourceSchema(
  sqlContext: SQLContext,
  schema: Option[StructType],
  providerName: String,
  parameters: Map[String, String]): (String, StructType)
```

`sourceSchema` [creates a DeltaLog](DeltaLog.md#forTable) for the required `path` parameter (from the given `parameters`).

`sourceSchema` takes the [schema](Snapshot.md#schema) (of the [Snapshot](SnapshotManagement.md#snapshot)) of the `DeltaLog` and [removes generation expressions](generated-columns/GeneratedColumn.md#removeGenerationExpressions) (if defined).

In the end, `sourceSchema` returns the [delta](#shortName) name with the schema (of the Delta table without the generation expressions).

---

`createSource` makes sure that there is no `schema` specified or throws an `AnalysisException`:

```text
Delta does not support specifying the schema at read time.
```

---

`createSource` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

```text
'path' is not specified
```

---

`createSource` makes sure that there is no time travel specified using the following:

* [path](DeltaTableUtils.md#extractIfPathContainsTimeTravel) parameter
* [options](DeltaDataSource.md#getTimeTravelVersion) (in the given `parameters`)

If either is set, `createSource` throws an `AnalysisException`:

```text
Cannot time travel views, subqueries or streams.
```

---

`sourceSchema` is part of the `StreamSourceProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSourceProvider/#sourceSchema)) abstraction.

## <span id="StreamSinkProvider"> StreamSinkProvider

`DeltaDataSource` is a `StreamSinkProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSinkProvider)).

`DeltaDataSource` supports `Append` and `Complete` output modes only.

!!! tip
    Consult the demo [Using Delta Lake (as Streaming Sink) in Streaming Queries](demo/Using-Delta-Lake-as-Streaming-Sink-in-Structured-Streaming.md).

### <span id="createSink"> Creating Streaming Sink

```scala
createSink(
  sqlContext: SQLContext,
  parameters: Map[String, String],
  partitionColumns: Seq[String],
  outputMode: OutputMode): Sink
```

`createSink` creates a [DeltaOptions](DeltaOptions.md) (with the given `parameters` and the current `SQLConf`).

In the end, `createSink` creates a [DeltaSink](DeltaSink.md) (with the required `path` parameter, the given `partitionColumns` and the `DeltaOptions`).

---

`createSink` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

```text
'path' is not specified
```

---

`createSink` makes sure that the given `outputMode` is either `Append` or `Complete`, or throws an `IllegalArgumentException`:

```text
Data source [dataSource] does not support [outputMode] output mode
```

---

`createSink` is part of the `StreamSinkProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSinkProvider/#createSink)) abstraction.

## <span id="TableProvider"> TableProvider

`DeltaDataSource` is a`TableProvider` ([Spark SQL]({{ book.spark_sql }}/connector/TableProvider)).

`DeltaDataSource` allows registering Delta tables in a `HiveMetaStore`. Delta creates a transaction log at the table root directory, and the Hive MetaStore contains no information but the table format and the location of the table. All table properties, schema and partitioning information live in the transaction log to avoid a split brain situation.

The feature was added in [SC-34233](https://github.com/delta-io/delta/commit/5cc383496b35905d3b7911a1f3418777156464c9).

### <span id="getTable"> Loading Delta Table

```scala
getTable(
  schema: StructType,
  partitioning: Array[Transform],
  properties: Map[String, String]): Table
```

`getTable` is part of the `TableProvider` ([Spark SQL]({{ book.spark_sql }}/connector/TableProvider#getTable)) abstraction.

---

`getTable` creates a [DeltaTableV2](DeltaTableV2.md) (with the [path](DeltaTableV2.md#path) from the given `properties`).

---

`getTable` throws an `IllegalArgumentException` when `path` option is not specified:

```text
'path' is not specified
```

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
