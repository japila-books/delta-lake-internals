# Options

The options can be defined using `option` method of the following:

* `DataFrameReader` and `DataFrameWriter` for batch queries (Spark SQL)
* `DataStreamReader` and `DataStreamWriter` for streaming queries (Spark Structured Streaming)

## <span id="checkpointLocation"> checkpointLocation

## <span id="DATA_CHANGE_OPTION"><span id="dataChange"> dataChange

Whether to write new data to the table or just rearrange data that is already part of the table. This option declares that the data being written by this job does not change any data in the table and merely rearranges existing data. This makes sure streaming queries reading from this table will not see any new changes

Used when:

* `DeltaWriteOptionsImpl` is requested for [rearrangeOnly](DeltaWriteOptionsImpl.md#rearrangeOnly)

## <span id="EXCLUDE_REGEX_OPTION"><span id="excludeRegex"> excludeRegex

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

## <span id="path"> path

**(required)** Directory on a Hadoop DFS-compliant file system with an optional [time travel](time-travel.md) identifier

Default: (undefined)

!!! note
    Can also be specified using `load` method of `DataFrameReader` and `DataStreamReader`.

## <span id="queryName"> queryName

## <span id="REPLACE_WHERE_OPTION"><span id="replaceWhere"> replaceWhere

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
