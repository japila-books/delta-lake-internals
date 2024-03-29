# DeltaDataSource

`DeltaDataSource` ties Delta Lake with Spark SQL (and Spark Structured Streaming) together as [delta](#DataSourceRegister) data source that supports batch and streaming queries.

## <span id="delta-format"><span id="DataSourceRegister"> DataSourceRegister and delta Alias

`DeltaDataSource` is a `DataSourceRegister` ([Spark SQL]({{ book.spark_sql }}/DataSourceRegister)) and registers **delta** alias.

`DeltaDataSource` is registered using [META-INF/services/org.apache.spark.sql.sources.DataSourceRegister]({{ delta.github }}/core/src/main/resources/META-INF/services/org.apache.spark.sql.sources.DataSourceRegister):

```text
org.apache.spark.sql.delta.sources.DeltaDataSource
```

## <span id="RelationProvider"> RelationProvider

`DeltaDataSource` is a `RelationProvider` ([Spark SQL]({{ book.spark_sql }}/RelationProvider)).

### <span id="RelationProvider-createRelation"> Creating BaseRelation for Table Scan

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` is part of the `RelationProvider` ([Spark SQL]({{ book.spark_sql }}/RelationProvider/#createRelation)) abstraction.

---

`createRelation` [verifies the given parameters](DeltaOptions.md#verifyOptions) (_options_).

`createRelation` [extracts time travel specification](#getTimeTravelVersion) (from the given `parameters`).

`createRelation` collects CDF-specific options with [change data feed enabled](../change-data-feed/CDCReaderImpl.md#isCDCRead):

* [readChangeFeed](DeltaDataSource.md#CDC_ENABLED_KEY) (with `true` value)
* [startingVersion](DeltaDataSource.md#CDC_START_VERSION_KEY)
* [startingTimestamp](DeltaDataSource.md#CDC_START_TIMESTAMP_KEY)
* [endingVersion](DeltaDataSource.md#CDC_END_VERSION_KEY)
* [endingTimestamp](DeltaDataSource.md#CDC_END_TIMESTAMP_KEY)

`createRelation` creates a [DeltaTableV2](../DeltaTableV2.md) (with the given `parameters` as options when [spark.databricks.delta.loadFileSystemConfigsFromDataFrameOptions](../configuration-properties/DeltaSQLConf.md#LOAD_FILE_SYSTEM_CONFIGS_FROM_DATAFRAME_OPTIONS) configuration property is enabled).

In the end, `createRelation` requests the `DeltaTableV2` for an [insertable HadoopFsRelation](../DeltaTableV2.md#toBaseRelation).

??? note "`path` Parameter is Required"
    `createRelation` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

    ```text
    'path' is not specified
    ```

## <span id="CreatableRelationProvider"> CreatableRelationProvider

`DeltaDataSource` is a `CreatableRelationProvider` ([Spark SQL]({{ book.spark_sql }}/CreatableRelationProvider)).

### <span id="CreatableRelationProvider-createRelation"> Creating BaseRelation after Data Writing

```scala
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  data: DataFrame): BaseRelation
```

`createRelation` is part of the `CreatableRelationProvider` ([Spark SQL]({{ book.spark_sql }}/CreatableRelationProvider/#createRelation)) abstraction.

---

`createRelation` [creates a DeltaLog](../DeltaLog.md#forTable) for the required `path` parameter (from the given `parameters`) and the given `parameters` itself.

`createSource` creates a [DeltaOptions](DeltaOptions.md) (with the given `parameters` and the current `SQLConf`).

`createSource` [validateConfigurations](../table-properties/DeltaConfigs.md#validateConfigurations) (with `delta.`-prefixed keys in the given`parameters`).

`createRelation` [creates and executes a WriteIntoDelta command](../commands/WriteIntoDelta.md) with the given `data`.

In the end, `createRelation` requests the `DeltaLog` for a [BaseRelation](../DeltaLog.md#createRelation).

??? note "`path` Parameter is Required"
    `createRelation` makes sure that there is `path` parameter defined (in the given `parameters`) or throws an `IllegalArgumentException`:

    ```text
    'path' is not specified
    ```

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

`createSource` [creates a DeltaLog](../DeltaLog.md#forTable) for the required `path` parameter (from the given `parameters`).

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

`createSource` makes sure that there is [schema](../Snapshot.md#schema) available (in the [Snapshot](../SnapshotManagement.md#snapshot)) of the `DeltaLog` or throws an `AnalysisException`:

```text
Table schema is not set.  Write data into it or use CREATE TABLE to set the schema.
```

---

`createSource` is part of the `StreamSourceProvider` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamSourceProvider/#createSource)) abstraction.

### <span id="sourceSchema"> Streaming Source Schema

```scala
sourceSchema(
  sqlContext: SQLContext,
  schema: Option[StructType],
  providerName: String,
  parameters: Map[String, String]): (String, StructType)
```

`sourceSchema` [creates a DeltaLog](../DeltaLog.md#forTable) for the required `path` parameter (from the given `parameters`).

`sourceSchema` takes the [schema](../Snapshot.md#schema) (of the [Snapshot](../SnapshotManagement.md#snapshot)) of the `DeltaLog` and [removes default expressions](../ColumnWithDefaultExprUtils.md#removeDefaultExpressions).

In the end, `sourceSchema` returns the [delta](#shortName) name with the table schema.

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

* [path](../DeltaTableUtils.md#extractIfPathContainsTimeTravel) parameter
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
    Consult the demo [Using Delta Lake (as Streaming Sink) in Streaming Queries](../demo/Using-Delta-Lake-as-Streaming-Sink-in-Structured-Streaming.md).

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

## TableProvider { #TableProvider }

`DeltaDataSource` is a `TableProvider` ([Spark SQL]({{ book.spark_sql }}/connector/TableProvider)).

### Loading Delta Table { #getTable }

??? note "TableProvider"

    ```scala
    getTable(
      schema: StructType,
      partitioning: Array[Transform],
      properties: Map[String, String]): Table
    ```

    `getTable` is part of the `TableProvider` ([Spark SQL]({{ book.spark_sql }}/connector/TableProvider#getTable)) abstraction.

`getTable` creates a [DeltaTableV2](../DeltaTableV2.md) (with the [path](../DeltaTableV2.md#path) from the given `properties`).

---

`getTable` throws an `IllegalArgumentException` when `path` option is not specified:

```text
'path' is not specified
```

## Schema Tracking Location { #extractSchemaTrackingLocationConfig }

```scala
extractSchemaTrackingLocationConfig(
  spark: SparkSession,
  parameters: Map[String, String]): Option[String]
```

`extractSchemaTrackingLocationConfig` is the value of the following options (if defined):

* [schemaTrackingLocation](options.md#schemaTrackingLocation)
* [schemaLocation](options.md#schemaLocation)

---

`extractSchemaTrackingLocationConfig` is used when:

* `DeltaAnalysis` is requested to [verifyDeltaSourceSchemaLocation](../DeltaAnalysis.md#verifyDeltaSourceSchemaLocation)
* `DeltaDataSource` is requested for a [DeltaSourceMetadataTrackingLog](#getMetadataTrackingLogForDeltaSource)

## <span id="getTimeTravelVersion"> Creating DeltaTimeTravelSpec

```scala
getTimeTravelVersion(
  parameters: Map[String, String]): Option[DeltaTimeTravelSpec]
```

`getTimeTravelVersion` reads the following options (from the given `parameters`):

* [timestampAsOf](options.md#TIME_TRAVEL_TIMESTAMP_KEY)
* [versionAsOf](options.md#TIME_TRAVEL_VERSION_KEY)
* `__time_travel_source__`

`getTimeTravelVersion` creates a [DeltaTimeTravelSpec](../time-travel/DeltaTimeTravelSpec.md) if either `timestampAsOf` or `versionAsOf` is defined. The `DeltaTimeTravelSpec` is created with the [creationSource](#creationSource) based on `__time_travel_source__` (if specified) or defaults to `dfReader`.

!!! note "Undocumented Feature"
    `__time_travel_source__` looks like an undocumented feature to use for the [creationSource](../time-travel/DeltaTimeTravelSpec.md#creationSource).

---

`getTimeTravelVersion` is used when:

* `DeltaDataSource` is requested to [create a relation (as a RelationProvider)](#RelationProvider-createRelation)

## <span id="parsePathIdentifier"> parsePathIdentifier

```scala
parsePathIdentifier(
  spark: SparkSession,
  userPath: String): (Path, Seq[(String, String)], Option[DeltaTimeTravelSpec])
```

`parsePathIdentifier`...FIXME

---

`parsePathIdentifier` is used when:

* `DeltaTableV2` is requested for [metadata](../DeltaTableV2.md#rootPath) (for a non-catalog table)

## <span id="CDC_ENABLED_KEY"> readChangeFeed { #readChangeFeed }

[readChangeFeed](options.md#readChangeFeed)

## getMetadataTrackingLogForDeltaSource { #getMetadataTrackingLogForDeltaSource }

```scala
getMetadataTrackingLogForDeltaSource(
  spark: SparkSession,
  sourceSnapshot: Snapshot,
  parameters: Map[String, String],
  sourceMetadataPathOpt: Option[String] = None,
  mergeConsecutiveSchemaChanges: Boolean = false): Option[DeltaSourceMetadataTrackingLog]
```

`getMetadataTrackingLogForDeltaSource` [finds the schema tracking location](#extractSchemaTrackingLocationConfig) and, if defined, [creates a DeltaSourceMetadataTrackingLog](DeltaSourceMetadataTrackingLog.md#create) (with the value of [streamingSourceTrackingId](options.md#streamingSourceTrackingId) option).

---

`getMetadataTrackingLogForDeltaSource` reports an `UnsupportedOperationException` for [spark.databricks.delta.streaming.schemaTracking.enabled](../configuration-properties/index.md#streaming.schemaTracking.enabled) disabled:

```text
Schema tracking location is not supported for Delta streaming source
```

---

`getMetadataTrackingLogForDeltaSource` is used when:

* `DeltaDataSource` is requested for a [streaming source](DeltaDataSource.md#createSource) and the [streaming source schema](DeltaDataSource.md#sourceSchema)
