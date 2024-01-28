---
title: DeltaConfigs
---

# DeltaConfigs (DeltaConfigsBase)

`DeltaConfigs` holds the supported [table properties](index.md) in Delta Lake.

## Accessing DeltaConfigs

```scala
import org.apache.spark.sql.delta.OptimisticTransaction
val txn: OptimisticTransaction = ???
```

```scala
import org.apache.spark.sql.delta.actions.Metadata
val metadata: Metadata = txn.metadata
```

```scala
import org.apache.spark.sql.delta.DeltaConfigs
DeltaConfigs.CHANGE_DATA_FEED.fromMetaData(metadata)
```

## <span id="sqlConfPrefix"> System-Wide Defaults { #spark.databricks.delta.properties.defaults }

**spark.databricks.delta.properties.defaults** prefix is used for [global table properties](#mergeGlobalConfigs).

For every [table property](#table-properties) (without the `delta.` prefix) there is the corresponding system-wide (*global*) configuration property with `spark.databricks.delta.properties.defaults` prefix for the default values of the table properties for all delta tables.

## Table Properties

All table properties start with `delta.` prefix.

### <span id="IS_APPEND_ONLY"> appendOnly { #appendOnly }

**delta.appendOnly**

Turns a table into [append-only](../append-only-tables/index.md)

When enabled, a table allows appends only and no updates or deletes.

Default: `false`

Used when:

* `DeltaLog` is requested to [assertRemovable](../DeltaLog.md#assertRemovable) (that in turn uses `DeltaErrors` utility to [modifyAppendOnlyTableException](../DeltaErrors.md#modifyAppendOnlyTableException))
* `AppendOnlyTableFeature` is requested to [metadataRequiresFeatureToBeEnabled](../append-only-tables/AppendOnlyTableFeature.md#metadataRequiresFeatureToBeEnabled)

### <span id="AUTO_OPTIMIZE"><span id="delta.autoOptimize"> autoOptimize { #autoOptimize }

**delta.autoOptimize**

!!! note "Deprecated"
    `delta.autoOptimize` is deprecated in favour of [delta.autoOptimize.autoCompact](#delta.autoOptimize.autoCompact) table property since 3.1.0.

Whether this delta table will automagically optimize the layout of files during writes.

Default: `false`

### <span id="AUTO_COMPACT"><span id="delta.autoOptimize.autoCompact"> autoOptimize.autoCompact { #autoOptimize.autoCompact }

**delta.autoOptimize.autoCompact**

Enables [Auto Compaction](../auto-compaction/index.md)

Default: `false`

??? note "Replaces delta.autoOptimize"
    `delta.autoOptimize.autoCompact` replaces [delta.autoOptimize.autoCompact](#delta.autoOptimize) table property since 3.1.0.

Used when:

* `AutoCompactBase` is requested for the [type of Auto Compaction](../auto-compaction/AutoCompactBase.md#getAutoCompactType)

### <span id="checkpointInterval"><span id="CHECKPOINT_INTERVAL"> checkpointInterval

How often to [checkpoint](../checkpoints/Checkpoints.md#checkpoint) the state of a delta table (at the end of [transaction commit](../OptimisticTransactionImpl.md#postCommit))

Default: `10`

### <span id="CHECKPOINT_RETENTION_DURATION"> checkpointRetentionDuration { #checkpointRetentionDuration }

**delta.checkpointRetentionDuration**

How long to keep checkpoint files around before deleting them

Default: `interval 2 days`

The most recent checkpoint is never deleted. It is acceptable to keep checkpoint files beyond this duration until the next calendar day.

### <span id="CHECKPOINT_WRITE_STATS_AS_JSON"> checkpoint.writeStatsAsJson { #checkpoint.writeStatsAsJson }

**delta.checkpoint.writeStatsAsJson**

Controls whether to write file statistics in the checkpoint in JSON format as the `stats` column.

Default: `true`

### <span id="CHECKPOINT_WRITE_STATS_AS_STRUCT"> checkpoint.writeStatsAsStruct { #checkpoint.writeStatsAsStruct }

**delta.checkpoint.writeStatsAsStruct**

Controls whether to write file statistics in the checkpoint in the struct format in the `stats_parsed` column and partition values as a struct as `partitionValues_parsed`

Default: `undefined` (`Option[Boolean]`)

### <span id="COLUMN_MAPPING_MAX_ID"> columnMapping.maxColumnId { #columnMapping.maxColumnId }

**delta.columnMapping.maxColumnId**

Maximum columnId used in the schema so far for [column mapping](../column-mapping/index.md)

Cannot be set

Default: `0`

### <span id="COLUMN_MAPPING_MODE"> columnMapping.mode { #columnMapping.mode }

**delta.columnMapping.mode**

[DeltaColumnMappingMode](../column-mapping/DeltaColumnMappingMode.md) to read and write parquet data files

Name    | Description
--------|------------
 `none` | **(default)** A display name is the only valid identifier of a column
 `id`   | A column ID is the identifier of a column. This mode is used for tables converted from Iceberg and parquet files in this mode will also have corresponding field Ids for each column in their file schema.
 `name` | The physical column name is the identifier of a column. Stored as part of `StructField` metadata in the schema. Used for reading statistics and partition values in the [DeltaLog](../DeltaLog.md).

Used when:

* `DeltaColumnMappingBase` is requested to [tryFixMetadata](../column-mapping/DeltaColumnMappingBase.md#tryFixMetadata) (while `OptimisticTransactionImpl` is requested to [update the metadata](../OptimisticTransactionImpl.md#updateMetadata))
* `DeltaErrors` utility is used to [create a DeltaColumnMappingUnsupportedException](../DeltaErrors.md#changeColumnMappingModeOnOldProtocol) (while `OptimisticTransactionImpl` is requested to [update the metadata](../OptimisticTransactionImpl.md#updateMetadata))
* `DeltaErrors` utility is used to [create a DeltaColumnMappingUnsupportedException](../DeltaErrors.md#convertToDeltaWithColumnMappingNotSupported) (while [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md) is executed)
* `Metadata` is requested for the [column mapping mode](../Metadata.md#columnMappingMode) (while `DeltaFileFormat` is requested for the [FileFormat](../DeltaFileFormat.md#fileFormat))

### <span id="SYMLINK_FORMAT_MANIFEST_ENABLED"> compatibility.symlinkFormatManifest.enabled { #compatibility.symlinkFormatManifest.enabled }

**delta.compatibility.symlinkFormatManifest.enabled**

Whether to register the [GenerateSymlinkManifest](../post-commit-hooks/GenerateSymlinkManifest.md) post-commit hook while [committing a transaction](../OptimisticTransactionImpl.md#commit) or not

Default: `false`

### <span id="DATA_SKIPPING_NUM_INDEXED_COLS"> dataSkippingNumIndexedCols { #dataSkippingNumIndexedCols }

**delta.dataSkippingNumIndexedCols**

The number of columns to collect stats on for [data skipping](../data-skipping/index.md). `-1` means collecting stats for all columns.

Default: `32`

Must be larger than or equal to `-1`.

Used when:

* `Snapshot` is requested for the [maximum number of indexed columns](../Snapshot.md#numIndexedCols)
* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles)

### <span id="TOMBSTONE_RETENTION"> deletedFileRetentionDuration { #deletedFileRetentionDuration }

**delta.deletedFileRetentionDuration**

How long to keep logically deleted data files around before deleting them physically (to prevent failures in stale readers after compactions or partition overwrites)

Default: `interval 1 week`

### <span id="CHANGE_DATA_FEED"><span id="enableChangeDataCapture"> enableChangeDataFeed { #enableChangeDataFeed }

**delta.enableChangeDataFeed**

Enables [Change Data Feed](../change-data-feed/index.md)

Default: `false`

Legacy configuration: `enableChangeDataCapture`

Used when:

* `Protocol` is requested for the [requiredMinimumProtocol](../Protocol.md#requiredMinimumProtocol)
* `DeleteCommand` is requested to [rewriteFiles](../commands/delete/DeleteCommand.md#rewriteFiles)
* `MergeIntoCommand` is requested to [writeAllChanges](../commands/merge/MergeIntoCommand.md#writeAllChanges)
* `UpdateCommand` is requested to [shouldOutputCdc](../commands/update/UpdateCommand.md#shouldOutputCdc)
* `CDCReader` is requested to [isCDCEnabledOnTable](../change-data-feed/CDCReader.md#isCDCEnabledOnTable)

### <span id="ENABLE_DELETION_VECTORS_CREATION"> enableDeletionVectors { #enableDeletionVectors }

**delta.enableDeletionVectors**

Enables [Deletion Vectors](../deletion-vectors/index.md)

Default: `false`

Used when:

* `DeletionVectorsTableFeature` is requested to [metadataRequiresFeatureToBeEnabled](../deletion-vectors/DeletionVectorsTableFeature.md#metadataRequiresFeatureToBeEnabled)
* `Protocol` is requested to [assertTablePropertyConstraintsSatisfied](../Protocol.md#assertTablePropertyConstraintsSatisfied)
* `DeletionVectorUtils` is requested to [deletionVectorsWritable](../deletion-vectors/DeletionVectorUtils.md#deletionVectorsWritable)

### <span id="ENABLE_EXPIRED_LOG_CLEANUP"><span id="enableExpiredLogCleanup"> enableExpiredLogCleanup { #delta.enableExpiredLogCleanup }

**delta.enableExpiredLogCleanup**

Controls [Log Cleanup](../log-cleanup/index.md)

Default: `true`

Used when:

* `MetadataCleanup` is requested for [whether to clean up expired log files and checkpoints](../log-cleanup/MetadataCleanup.md#enableExpiredLogCleanup)

### <span id="ENABLE_FULL_RETENTION_ROLLBACK"> enableFullRetentionRollback { #enableFullRetentionRollback }

**delta.enableFullRetentionRollback**

Controls whether or not a delta table can be rolled back to any point within [logRetentionDuration](#LOG_RETENTION). When disabled, the table can be rolled back [checkpointRetentionDuration](#CHECKPOINT_RETENTION_DURATION) only.

Default: `true`

### <span id="ROW_TRACKING_ENABLED"><span id="delta.enableRowTracking"> enableRowTracking { #enableRowTracking }

**delta.enableRowTracking**

Default: `false`

Used when:

* `DeltaErrorsBase` is requested to [convertToDeltaRowTrackingEnabledWithoutStatsCollection](../DeltaErrorsBase.md#convertToDeltaRowTrackingEnabledWithoutStatsCollection)
* `RowId` is requested to [isEnabled](../row-tracking/RowId.md#isEnabled)
* `RowTracking` is requested to [isEnabled](../row-tracking/RowTracking.md#isEnabled)
* `RowTrackingFeature` is requested to [metadataRequiresFeatureToBeEnabled](../row-tracking/RowTrackingFeature.md#metadataRequiresFeatureToBeEnabled)

### <span id="LOG_RETENTION"> logRetentionDuration { #logRetentionDuration }

**delta.logRetentionDuration**

How long to keep obsolete logs around before deleting them. Delta can keep logs beyond the duration until the next calendar day to avoid constantly creating checkpoints.

Default: `interval 30 days` (`CalendarInterval`)

Examples: `2 weeks`, `365 days` (`months` and `years` are not accepted)

Used when:

* `MetadataCleanup` is requested for the [deltaRetentionMillis](../log-cleanup/MetadataCleanup.md#deltaRetentionMillis)

### <span id="MIN_READER_VERSION"> minReaderVersion { #minReaderVersion }

**delta.minReaderVersion**

The protocol reader version

Default: `1`

This property is *not* stored as a table property in the `Metadata` action. It is stored as its own action. Having it modelled as a table property makes it easier to upgrade, and view the version.

### <span id="MIN_WRITER_VERSION"> minWriterVersion { #minWriterVersion }

**delta.minWriterVersion**

The protocol reader version

Default: `3`

This property is *not* stored as a table property in the `Metadata` action. It is stored as its own action. Having it modelled as a table property makes it easier to upgrade, and view the version.

### <span id="RANDOMIZE_FILE_PREFIXES"> randomizeFilePrefixes { #randomizeFilePrefixes }

**delta.randomizeFilePrefixes**

Whether to use a random prefix in a file path instead of partition information (may be required for very high volume S3 calls to better be partitioned across S3 servers)

Default: `false`

### <span id="RANDOM_PREFIX_LENGTH"> randomPrefixLength { #randomPrefixLength }

**delta.randomPrefixLength**

The length of the random prefix in a file path for [randomizeFilePrefixes](#RANDOMIZE_FILE_PREFIXES)

Default: `2`

### <span id="SAMPLE_RETENTION"> sampleRetentionDuration { #sampleRetentionDuration }

**delta.sampleRetentionDuration**

How long to keep delta sample files around before deleting them

Default: `interval 7 days`

## Building Configuration { #buildConfig }

```scala
buildConfig[T](
  key: String,
  defaultValue: String,
  fromString: String => T,
  validationFunction: T => Boolean,
  helpMessage: String,
  minimumProtocolVersion: Option[Protocol] = None): DeltaConfig[T]
```

`buildConfig` creates a [DeltaConfig](DeltaConfig.md) for the given `key` (with **delta** prefix added) and adds it to the [entries](#entries) internal registry.

`buildConfig` is used to define all of the [configuration properties](#configuration-properties) in a type-safe way and (as a side effect) register them with the system-wide [entries](#entries) internal registry.

## System-Wide Configuration Entries Registry { #entries }

```scala
entries: HashMap[String, DeltaConfig[_]]
```

`DeltaConfigs` utility (a Scala object) uses `entries` internal registry of [DeltaConfig](DeltaConfig.md)s by their key.

New entries are added in [buildConfig](#buildConfig).

`entries` is used when:

* [validateConfigurations](#validateConfigurations)
* [mergeGlobalConfigs](#mergeGlobalConfigs)
* [normalizeConfigKey](#normalizeConfigKey) and [normalizeConfigKeys](#normalizeConfigKeys)

## mergeGlobalConfigs { #mergeGlobalConfigs }

```scala
mergeGlobalConfigs(
  sqlConfs: SQLConf,
  tableConf: Map[String, String],
  protocol: Protocol): Map[String, String]
```

`mergeGlobalConfigs` finds all [spark.databricks.delta.properties.defaults](#sqlConfPrefix)-prefixed table properties among the [entries](#entries).

---

`mergeGlobalConfigs` is used when:

* `OptimisticTransactionImpl` is requested to [withGlobalConfigDefaults](../OptimisticTransactionImpl.md#withGlobalConfigDefaults)
* `InitialSnapshot` is created

## validateConfigurations { #validateConfigurations }

```scala
validateConfigurations(
  configurations: Map[String, String]): Map[String, String]
```

`validateConfigurations`...FIXME

---

`validateConfigurations` is used when:

* `DeltaCatalog` is requested to [verifyTableAndSolidify](../DeltaCatalog.md#verifyTableAndSolidify), [alterTable](../DeltaCatalog.md#alterTable)
* `CloneTableBase` is requested to [runInternal](../commands/clone/CloneTableBase.md#runInternal)
* `DeltaDataSource` is requested to [create a BaseRelation](../spark-connector/DeltaDataSource.md#createRelation)

## normalizeConfigKeys { #normalizeConfigKeys }

```scala
normalizeConfigKeys(
  propKeys: Seq[String]): Seq[String]
```

`normalizeConfigKeys`...FIXME

---

`normalizeConfigKeys` is used when:

* [AlterTableUnsetPropertiesDeltaCommand](../commands/alter/AlterTableUnsetPropertiesDeltaCommand.md) is executed
