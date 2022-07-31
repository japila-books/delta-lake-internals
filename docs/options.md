# Options

Delta Lake comes with options to fine-tune its uses. They can be defined using `option` method of the following:

* `DataFrameReader` ([Spark SQL]({{ book.spark_sql }}/DataFrameReader)) and `DataFrameWriter` ([Spark SQL]({{ book.spark_sql }}/DataFrameWriter)) for batch queries
* `DataStreamReader` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamReader)) and `DataStreamWriter` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamWriter)) for streaming queries
* SQL queries

## <span id="DeltaOptions"> Accessing Options

The options are available at runtime as [DeltaOptions](DeltaOptions.md).

```scala
import org.apache.spark.sql.delta.DeltaOptions
assert(DeltaOptions.OVERWRITE_SCHEMA_OPTION == "overwriteSchema")
```

```scala
val options = new DeltaOptions(
  Map(DeltaOptions.OVERWRITE_SCHEMA_OPTION -> true.toString),
  spark.sessionState.conf)
assert(
  options.canOverwriteSchema,
  s"${DeltaOptions.OVERWRITE_SCHEMA_OPTION} should be enabled")
```

## <span id="checkpointLocation"> checkpointLocation

Checkpoint directory for storing checkpoint data of streaming queries ([Spark Structured Streaming]({{ book.structured_streaming }}/configuration-properties/#spark.sql.streaming.checkpointLocation)).

## <span id="DATA_CHANGE_OPTION"><span id="dataChange"> dataChange

Whether to write new data to the table or just rearrange data that is already part of the table. This option declares that the data being written by this job does not change any data in the table and merely rearranges existing data. This makes sure streaming queries reading from this table will not see any new changes

Used when:

* `DeltaWriteOptionsImpl` is requested for [rearrangeOnly](DeltaWriteOptionsImpl.md#rearrangeOnly)

??? demo
    Learn more in [Demo: dataChange](demo/dataChange.md).

## <span id="EXCLUDE_REGEX_OPTION"><span id="excludeRegex"> excludeRegex

[scala.util.matching.Regex]({{ scala.api }}/scala/util/matching/Regex.html) to filter out the paths of [FileAction](FileAction.md#path)s

Default: (undefined)

Use [DeltaOptions.excludeRegex](DeltaReadOptions.md#excludeRegex) to access the value

Used when:

* `DeltaSourceBase` is requested for the [data](DeltaSourceBase.md#getFileChangesAndCreateDataFrame) (for a given [DeltaSourceOffset](DeltaSourceOffset.md))
* `DeltaSourceCDCSupport` is requested for the [data](change-data-feed/DeltaSourceCDCSupport.md#getFileChangesForCDC)

## <span id="IGNORE_CHANGES_OPTION"><span id="ignoreChanges"> ignoreChanges

## <span id="IGNORE_DELETES_OPTION"><span id="ignoreDeletes"> ignoreDeletes

## <span id="IGNORE_FILE_DELETION_OPTION"><span id="ignoreFileDeletion"> ignoreFileDeletion

## <span id="MAX_BYTES_PER_TRIGGER_OPTION"><span id="maxBytesPerTrigger"> maxBytesPerTrigger

## <span id="MAX_FILES_PER_TRIGGER_OPTION"><span id="maxFilesPerTrigger"><span id="MAX_FILES_PER_TRIGGER_OPTION_DEFAULT"> maxFilesPerTrigger

Maximum number of files ([AddFiles](AddFile.md)) that [DeltaSource](DeltaSource.md) is supposed to [scan](DeltaSource.md#getChangesWithRateLimit) (_read_) in a streaming micro-batch (_trigger_)

Default: `1000`

Must be at least `1`

## <span id="MERGE_SCHEMA_OPTION"><span id="mergeSchema"><span id="canMergeSchema"> mergeSchema

Enables schema migration (and allows automatic schema merging during a write operation for [WriteIntoDelta](commands/WriteIntoDelta.md) and [DeltaSink](DeltaSink.md))

Equivalent SQL Session configuration: [spark.databricks.delta.schema.autoMerge.enabled](DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE)

## <span id="OPTIMIZE_WRITE_OPTION"><span id="optimizeWrite"> optimizeWrite

Enables...FIXME

## <span id="OVERWRITE_SCHEMA_OPTION"><span id="overwriteSchema"> overwriteSchema

Enables overwriting schema or change partitioning of a delta table during an overwrite write operation

Use [DeltaOptions.canOverwriteSchema](DeltaWriteOptionsImpl.md#canOverwriteSchema) to access the value

!!! note
    The schema cannot be overwritten when using [replaceWhere](#REPLACE_WHERE_OPTION) option.

## <span id="path"> path

**(required)** Directory on a Hadoop DFS-compliant file system with an optional [time travel](time-travel.md) identifier

Default: (undefined)

!!! note
    Can also be specified using `load` method of `DataFrameReader` and `DataStreamReader`.

## <span id="queryName"> queryName

## <span id="CDC_READ_OPTION"><span id="readChangeFeed"> readChangeFeed

Use [DeltaOptions.readChangeFeed](DeltaReadOptions.md#readChangeFeed) to access the value

## <span id="REPLACE_WHERE_OPTION"><span id="replaceWhere"> replaceWhere

Partition predicates (unless [replaceWhere.dataColumns.enabled](DeltaSQLConf.md#replaceWhere.dataColumns.enabled) is enabled to allow for arbitrary non-partition data predicates)

Available as [DeltaWriteOptions.replaceWhere](DeltaWriteOptions.md#replaceWhere)

!!! example "Demo"
    Learn more in [Demo: replaceWhere](demo/replaceWhere.md).

## <span id="timestampAsOf"> timestampAsOf

Timestamp of the version of a Delta table for [Time Travel](time-travel.md)

Mutually exclusive with [versionAsOf](#versionAsOf) option and the time travel identifier of the [path](#path) option.

## <span id="USER_METADATA_OPTION"><span id="userMetadata"> userMetadata

Defines a [user-defined commit metadata](CommitInfo.md#userMetadata)

Take precedence over [spark.databricks.delta.commitInfo.userMetadata](DeltaSQLConf.md#commitInfo.userMetadata)

Available by inspecting [CommitInfo](CommitInfo.md)s using [DESCRIBE HISTORY](sql/index.md#DESCRIBE-HISTORY) or [DeltaTable.history](DeltaTable.md#history).

!!! example "Demo"
    Learn more in [Demo: User Metadata for Labelling Commits](demo/user-metadata-for-labelling-commits.md).

## <span id="versionAsOf"> versionAsOf

Version of a Delta table for [Time Travel](time-travel.md)

Mutually exclusive with [timestampAsOf](#timestampAsOf) option and the time travel identifier of the [path](#path) option.

Used when:

* `DeltaDataSource` is requested for a [relation](DeltaDataSource.md#RelationProvider-createRelation)
