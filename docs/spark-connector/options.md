---
title: Options
---

# Options

## checkpointLocation { #checkpointLocation }

Checkpoint directory for streaming queries ([Spark Structured Streaming]({{ book.structured_streaming }}/configuration-properties/#spark.sql.streaming.checkpointLocation)).

## <span id="DATA_CHANGE_OPTION"><span id="dataChange"> dataChange

Whether to write new data to the table or just rearrange data that is already part of the table. This option declares that the data being written by this job does not change any data in the table and merely rearranges existing data. This makes sure streaming queries reading from this table will not see any new changes

Used when:

* `DeltaWriteOptionsImpl` is requested for [rearrangeOnly](DeltaWriteOptionsImpl.md#rearrangeOnly)

??? demo
    Learn more in [Demo: dataChange](../demo/dataChange.md).

## <span id="EXCLUDE_REGEX_OPTION"><span id="excludeRegex"> excludeRegex

[scala.util.matching.Regex]({{ scala.api }}/scala/util/matching/Regex.html) to filter out the paths of [FileAction](../FileAction.md#path)s

Default: (undefined)

Use [DeltaOptions.excludeRegex](DeltaReadOptions.md#excludeRegex) to access the value

Used when:

* `DeltaSourceBase` is requested for the [data](DeltaSourceBase.md#getFileChangesAndCreateDataFrame) (for a given [DeltaSourceOffset](DeltaSourceOffset.md))
* `DeltaSourceCDCSupport` is requested for the [data](../change-data-feed/DeltaSourceCDCSupport.md#getFileChangesForCDC)

## <span id="FAIL_ON_DATA_LOSS_OPTION"><span id="failOnDataLoss"> failOnDataLoss

Controls whether or not to [fail](../DeltaErrors.md#failOnDataLossException) loading a delta table when the earliest available version (in the `_delta_log` directory) is after the version requested

Default: `true`

Use [DeltaOptions.failOnDataLoss](DeltaReadOptions.md#failOnDataLoss) to access the value

## <span id="IGNORE_CHANGES_OPTION"><span id="ignoreChanges"> ignoreChanges

## <span id="IGNORE_DELETES_OPTION"><span id="ignoreDeletes"> ignoreDeletes

## <span id="IGNORE_FILE_DELETION_OPTION"><span id="ignoreFileDeletion"> ignoreFileDeletion

## <span id="MAX_BYTES_PER_TRIGGER_OPTION"><span id="maxBytesPerTrigger"> maxBytesPerTrigger

## <span id="MAX_FILES_PER_TRIGGER_OPTION"><span id="maxFilesPerTrigger"><span id="MAX_FILES_PER_TRIGGER_OPTION_DEFAULT"> maxFilesPerTrigger

Maximum number of files ([AddFiles](../AddFile.md)) that [DeltaSource](DeltaSource.md) is supposed to [scan](DeltaSource.md#getChangesWithRateLimit) (_read_) in a streaming micro-batch (_trigger_)

Default: `1000`

Must be at least `1`

## <span id="MAX_RECORDS_PER_FILE"> maxRecordsPerFile { #maxRecordsPerFile }

Maximum number of records per data file

!!! note "Spark SQL"
    `maxRecordsPerFile` is amongst the `FileFormatWriter` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormatWriter/#writing-out-query-result)) options so all Delta Lake does is to let it be available (_hand it over_) to the underlying "writing infrastructure".

Used when:

* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles) (for write options of [DelayedCommitProtocol](../DelayedCommitProtocol.md))

## <span id="MERGE_SCHEMA_OPTION"><span id="mergeSchema"><span id="canMergeSchema"> mergeSchema

Enables schema migration (and allows automatic schema merging during a write operation for [WriteIntoDelta](../commands/WriteIntoDelta.md) and [DeltaSink](DeltaSink.md))

Equivalent SQL Session configuration: [spark.databricks.delta.schema.autoMerge.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE)

## <span id="OPTIMIZE_WRITE_OPTION"> optimizeWrite { #optimizeWrite }

`optimizeWrite` is a writer option.

!!! danger "Not used"

## <span id="OVERWRITE_SCHEMA_OPTION"> overwriteSchema { #overwriteSchema }

Enables overwriting schema or change partitioning of a delta table during an overwrite write operation

Use [DeltaOptions.canOverwriteSchema](DeltaWriteOptionsImpl.md#canOverwriteSchema) to access the value

!!! note
    The schema cannot be overwritten when using [replaceWhere](#REPLACE_WHERE_OPTION) option.

## <span id="PARTITION_OVERWRITE_MODE_OPTION"> partitionOverwriteMode { #partitionOverwriteMode }

Mutually exclusive with [replaceWhere](#replaceWhere)

Used when:

* `DeltaDynamicPartitionOverwriteCommand` is executed
* `DeltaWriteOptionsImpl` is requested to [isDynamicPartitionOverwriteMode](DeltaWriteOptionsImpl.md#isDynamicPartitionOverwriteMode) and for [partitionOverwriteModeInOptions](DeltaWriteOptionsImpl.md#partitionOverwriteModeInOptions)
* `WriteIntoDeltaBuilder` is requested to [overwriteDynamicPartitions](../WriteIntoDeltaBuilder.md#overwriteDynamicPartitions)

## path { #path }

**(required)** Directory on a Hadoop DFS-compliant file system with an optional [time travel](../time-travel/index.md) identifier

Default: (undefined)

!!! note
    Can also be specified using `load` method of `DataFrameReader` and `DataStreamReader`.

## queryName { #queryName }

## <span id="CDC_READ_OPTION"> readChangeFeed { #readChangeFeed }

Enables [Change Data Feed](../change-data-feed/index.md) while reading delta tables ([CDC-aware table scans](../change-data-feed/CDCReaderImpl.md#isCDCRead))

Use [DeltaOptions.readChangeFeed](DeltaReadOptions.md#readChangeFeed) for the value

!!! note
    Use the following options to fine-tune [Change Data Feed](../change-data-feed/index.md)-aware queries:

    * [startingVersion](#CDC_START_VERSION_KEY)
    * [startingTimestamp](#CDC_START_TIMESTAMP_KEY)
    * [endingVersion](#CDC_END_VERSION_KEY)
    * [endingTimestamp](#CDC_END_TIMESTAMP_KEY)

---

`readChangeFeed` is used when:

* `CDCStatementBase` is requested to `getOptions`
* `CDCReaderImpl` is requested to [isCDCRead](../change-data-feed/CDCReaderImpl.md#isCDCRead)
* `DeltaDataSource` is requested to [create a BaseRelation](#RelationProvider-createRelation)

## <span id="REPLACE_WHERE_OPTION"> replaceWhere { #replaceWhere }

Partition predicates to overwrite only the data that matches predicates over partition columns (unless [replaceWhere.dataColumns.enabled](../configuration-properties/DeltaSQLConf.md#replaceWhere.dataColumns.enabled) is enabled)

Available as [DeltaWriteOptions.replaceWhere](DeltaWriteOptions.md#replaceWhere)

Mutually exclusive with [partitionOverwriteMode](#partitionOverwriteMode)

!!! example "Demo"
    Learn more in [Demo: replaceWhere](../demo/replaceWhere.md).

## <span id="STREAMING_SOURCE_TRACKING_ID"> streamingSourceTrackingId { #streamingSourceTrackingId }

The directory for a schema log of [DeltaSourceMetadataTrackingLog](DeltaSourceMetadataTrackingLog.md#rootMetadataLocation)

Available as [DeltaOptions.sourceTrackingId](DeltaReadOptions.md#sourceTrackingId)

Used when:

* `DeltaAnalysis` is requested to [verifyDeltaSourceSchemaLocation](../DeltaAnalysis.md#verifyDeltaSourceSchemaLocation)

## <span id="timestampAsOf"><span id="TIME_TRAVEL_TIMESTAMP_KEY"> timestampAsOf

[Timestamp](../time-travel/DeltaTimeTravelSpec.md#timestamp) of the version of a delta table for [Time Travel](../time-travel/index.md)

Mutually exclusive with [versionAsOf](#versionAsOf) option and the time travel identifier of the [path](#path) option.

Used when:

* `DeltaDataSource` utility is used to [get a DeltaTimeTravelSpec](DeltaDataSource.md#getTimeTravelVersion)

## <span id="USER_METADATA_OPTION"><span id="userMetadata"> userMetadata

Defines a [user-defined commit metadata](../CommitInfo.md#userMetadata)

Take precedence over [spark.databricks.delta.commitInfo.userMetadata](../configuration-properties/DeltaSQLConf.md#commitInfo.userMetadata)

Available by inspecting [CommitInfo](../CommitInfo.md)s using [DESCRIBE HISTORY](../sql/index.md#describe-history) or [DeltaTable.history](../DeltaTable.md#history).

!!! example "Demo"
    Learn more in [Demo: User Metadata for Labelling Commits](../demo/user-metadata-for-labelling-commits.md).

## <span id="versionAsOf"><span id="TIME_TRAVEL_VERSION_KEY"> versionAsOf

[Version](../time-travel/DeltaTimeTravelSpec.md#version) of a delta table for [Time Travel](../time-travel/index.md)

Must be _castable_ to a `long` number

Mutually exclusive with [timestampAsOf](#timestampAsOf) option and the time travel identifier of the [path](#path) option.

Used when:

* `DeltaDataSource` utility is used to [get a DeltaTimeTravelSpec](DeltaDataSource.md#getTimeTravelVersion)
