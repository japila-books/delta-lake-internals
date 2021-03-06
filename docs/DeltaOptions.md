# DeltaOptions

`DeltaOptions` is a type-safe abstraction of [write](DeltaWriteOptions.md) and [read](DeltaReadOptions.md)-specific [options](#options) of the [DeltaDataSource](DeltaDataSource.md).

`DeltaOptions` is used to create [WriteIntoDelta](commands/WriteIntoDelta.md) command, [DeltaSink](DeltaSink.md), and [DeltaSource](DeltaSource.md).

`DeltaOptions` can be [verified](#verifyOptions).

## <span id="validOptionKeys"><span id="options"> Options

### <span id="checkpointLocation"> checkpointLocation

### <span id="DATA_CHANGE_OPTION"><span id="dataChange"> dataChange

### <span id="EXCLUDE_REGEX_OPTION"><span id="excludeRegex"> excludeRegex

### <span id="IGNORE_CHANGES_OPTION"><span id="ignoreChanges"> ignoreChanges

### <span id="IGNORE_DELETES_OPTION"><span id="ignoreDeletes"> ignoreDeletes

### <span id="IGNORE_FILE_DELETION_OPTION"><span id="ignoreFileDeletion"> ignoreFileDeletion

### <span id="MAX_BYTES_PER_TRIGGER_OPTION"><span id="maxBytesPerTrigger"> maxBytesPerTrigger

### <span id="MAX_FILES_PER_TRIGGER_OPTION"><span id="maxFilesPerTrigger"><span id="MAX_FILES_PER_TRIGGER_OPTION_DEFAULT"> maxFilesPerTrigger

Maximum number of files ([AddFiles](AddFile.md)) that [DeltaSource](DeltaSource.md) is supposed to [scan](DeltaSource.md#getChangesWithRateLimit) (_read_) in a streaming micro-batch (_trigger_)

Default: `1000`

Must be at least `1`

### <span id="MERGE_SCHEMA_OPTION"><span id="mergeSchema"><span id="canMergeSchema"> mergeSchema

Enables schema migration (and allows automatic schema merging during a write operation for [WriteIntoDelta](commands/WriteIntoDelta.md) and [DeltaSink](DeltaSink.md))

Equivalent SQL Session configuration: [spark.databricks.delta.schema.autoMerge.enabled](DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE)

### <span id="OPTIMIZE_WRITE_OPTION"><span id="optimizeWrite"> optimizeWrite

Enables...FIXME

### <span id="OVERWRITE_SCHEMA_OPTION"><span id="overwriteSchema"> overwriteSchema

### <span id="path"> path

**(required)** Directory on a Hadoop DFS-compliant file system with an optional [time travel](time-travel.md) identifier

Default: (undefined)

!!! note
    Can also be specified using `load` method of `DataFrameReader` and `DataStreamReader`.

### <span id="queryName"> queryName

### <span id="REPLACE_WHERE_OPTION"><span id="replaceWhere"> replaceWhere

### <span id="timestampAsOf"> timestampAsOf

Timestamp of the version of a Delta table for [Time Travel](time-travel.md)

Mutually exclusive with [versionAsOf](#versionAsOf) option and the time travel identifier of the [path](#path) option.

### <span id="USER_METADATA_OPTION"><span id="userMetadata"> userMetadata

Defines a [user-defined commit metadata](CommitInfo.md#userMetadata)

Take precedence over [spark.databricks.delta.commitInfo.userMetadata](DeltaSQLConf.md#commitInfo.userMetadata)

Available by inspecting [CommitInfo](CommitInfo.md)s using [DESCRIBE HISTORY](sql/index.md#DESCRIBE-HISTORY) or [DeltaTable.history](DeltaTable.md#history).

!!! example "Demo"
    Learn more in [Demo: User Metadata for Labelling Commits](demo/user-metadata-for-labelling-commits.md).

### <span id="versionAsOf"> versionAsOf

Version of a Delta table for [Time Travel](time-travel.md)

Mutually exclusive with [timestampAsOf](#timestampAsOf) option and the time travel identifier of the [path](#path) option.

Used when:

* `DeltaDataSource` is requested for a [relation](DeltaDataSource.md#RelationProvider-createRelation)

## Creating Instance

`DeltaOptions` takes the following to be created:

* <span id="options"> Case-Insensitive Options
* <span id="sqlConf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf))

When created, `DeltaOptions` [verifies](#verifyOptions) the input options.

`DeltaOptions` is created when:

* `DeltaLog` is requested for a [relation](DeltaLog.md#createRelation) (for [DeltaDataSource](DeltaDataSource.md) as a [CreatableRelationProvider](DeltaDataSource.md#CreatableRelationProvider) and a [RelationProvider](DeltaDataSource.md#RelationProvider))
* `DeltaDataSource` is requested for a [streaming source](DeltaDataSource.md#createSource) (to create a [DeltaSource](DeltaSource.md) for Structured Streaming), a [streaming sink](DeltaDataSource.md#createSink) (to create a [DeltaSink](DeltaSink.md) for Structured Streaming), and for an [insertable HadoopFsRelation](DeltaDataSource.md#CreatableRelationProvider-createRelation)
* `WriteIntoDeltaBuilder` is requested to [buildForV1Write](WriteIntoDeltaBuilder.md#buildForV1Write)
* `CreateDeltaTableCommand` is requested to [run](commands/CreateDeltaTableCommand.md#run)

## How to Define Options

The options can be defined using `option` method of the following:

* `DataFrameReader` and `DataFrameWriter` for batch queries (Spark SQL)
* `DataStreamReader` and `DataStreamWriter` for streaming queries (Spark Structured Streaming)

## <span id="verifyOptions"> Verifying Options

```scala
verifyOptions(
  options: CaseInsensitiveMap[String]): Unit
```

`verifyOptions` finds invalid options among the input `options`.

!!! note
    In the open-source version `verifyOptions` does nothing. The underlying objects (`recordDeltaEvent` and the others) are no-ops.

`verifyOptions` is used when:

* `DeltaOptions` is [created](#creating-instance)
* `DeltaDataSource` is requested for a [relation (for loading data in batch queries)](DeltaDataSource.md#RelationProvider-createRelation)
