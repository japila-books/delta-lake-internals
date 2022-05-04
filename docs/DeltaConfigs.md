# DeltaConfigs (DeltaConfigsBase)

`DeltaConfigs` holds the [table properties](table-properties.md) that can be set on a delta table.

## Configuration Properties

### <span id="appendOnly"><span id="IS_APPEND_ONLY"> appendOnly

Whether a delta table is append-only (`true`) or not (`false`). When enabled, a table allows appends only and no updates or deletes.

Default: `false`

Used when:

* `DeltaLog` is requested to [assertRemovable](DeltaLog.md#assertRemovable) (that in turn uses `DeltaErrors` utility to [modifyAppendOnlyTableException](DeltaErrors.md#modifyAppendOnlyTableException))
* `Protocol` utility is used to [requiredMinimumProtocol](Protocol.md#requiredMinimumProtocol)

### <span id="autoOptimize"><span id="AUTO_OPTIMIZE"> autoOptimize

Whether this delta table will automagically optimize the layout of files during writes.

Default: `false`

### <span id="checkpointInterval"><span id="CHECKPOINT_INTERVAL"> checkpointInterval

How often to [checkpoint](Checkpoints.md#checkpoint) the state of a delta table (at the end of [transaction commit](OptimisticTransactionImpl.md#postCommit))

Default: `10`

### <span id="checkpointRetentionDuration"><span id="CHECKPOINT_RETENTION_DURATION"> checkpointRetentionDuration

How long to keep checkpoint files around before deleting them

Default: `interval 2 days`

The most recent checkpoint is never deleted. It is acceptable to keep checkpoint files beyond this duration until the next calendar day.

### <span id="checkpoint.writeStatsAsJson"><span id="CHECKPOINT_WRITE_STATS_AS_JSON"> checkpoint.writeStatsAsJson

Controls whether to write file statistics in the checkpoint in JSON format as the `stats` column.

Default: `true`

### <span id="checkpoint.writeStatsAsStruct"><span id="CHECKPOINT_WRITE_STATS_AS_STRUCT"> checkpoint.writeStatsAsStruct

Controls whether to write file statistics in the checkpoint in the struct format in the `stats_parsed` column and partition values as a struct as `partitionValues_parsed`

Default: `undefined` (`Option[Boolean]`)

### <span id="compatibility.symlinkFormatManifest.enabled"><span id="SYMLINK_FORMAT_MANIFEST_ENABLED"> compatibility.symlinkFormatManifest.enabled

Whether to register the [GenerateSymlinkManifest](GenerateSymlinkManifest.md) post-commit hook while [committing a transaction](OptimisticTransactionImpl.md#commit) or not

Default: `false`

### <span id="dataSkippingNumIndexedCols"><span id="DATA_SKIPPING_NUM_INDEXED_COLS"> dataSkippingNumIndexedCols

The number of columns to collect stats on for data skipping. `-1` means collecting stats for all columns.

Default: `32`

Must be larger than or equal to `-1`.

Used when:

* `Snapshot` is requested for the [maximum number of indexed columns](Snapshot.md#numIndexedCols)
* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)

### <span id="deletedFileRetentionDuration"><span id="TOMBSTONE_RETENTION"> deletedFileRetentionDuration

How long to keep logically deleted data files around before deleting them physically (to prevent failures in stale readers after compactions or partition overwrites)

Default: `interval 1 week`

### <span id="enableExpiredLogCleanup"><span id="ENABLE_EXPIRED_LOG_CLEANUP"> enableExpiredLogCleanup

Whether to clean up expired log files and checkpoints

Default: `true`

### <span id="enableFullRetentionRollback"><span id="ENABLE_FULL_RETENTION_ROLLBACK"> enableFullRetentionRollback

Controls whether or not a delta table can be rolled back to any point within [logRetentionDuration](#LOG_RETENTION). When disabled, the table can be rolled back [checkpointRetentionDuration](#CHECKPOINT_RETENTION_DURATION) only.

Default: `true`

### <span id="logRetentionDuration"><span id="LOG_RETENTION"> logRetentionDuration

How long to keep obsolete logs around before deleting them. Delta can keep logs beyond the duration until the next calendar day to avoid constantly creating checkpoints.

Default: `interval 30 days` (`CalendarInterval`)

### <span id="minReaderVersion"><span id="MIN_READER_VERSION"> minReaderVersion

The protocol reader version

Default: `1`

This property is *not* stored as a table property in the `Metadata` action. It is stored as its own action. Having it modelled as a table property makes it easier to upgrade, and view the version.

### <span id="minWriterVersion"><span id="MIN_WRITER_VERSION"> minWriterVersion

The protocol reader version

Default: `3`

This property is *not* stored as a table property in the `Metadata` action. It is stored as its own action. Having it modelled as a table property makes it easier to upgrade, and view the version.

### <span id="randomizeFilePrefixes"><span id="RANDOMIZE_FILE_PREFIXES"> randomizeFilePrefixes

Whether to use a random prefix in a file path instead of partition information (may be required for very high volume S3 calls to better be partitioned across S3 servers)

Default: `false`

### <span id="randomPrefixLength"><span id="RANDOM_PREFIX_LENGTH"> randomPrefixLength

The length of the random prefix in a file path for [randomizeFilePrefixes](#RANDOMIZE_FILE_PREFIXES)

Default: `2`

### <span id="sampleRetentionDuration"><span id="SAMPLE_RETENTION"> sampleRetentionDuration

How long to keep delta sample files around before deleting them

Default: `interval 7 days`

## <span id="buildConfig"> Building Configuration

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

## <span id="entries"> System-Wide Configuration Entries Registry

```scala
entries: HashMap[String, DeltaConfig[_]]
```

`DeltaConfigs` utility (a Scala object) uses `entries` internal registry of [DeltaConfig](DeltaConfig.md)s by their key.

New entries are added in [buildConfig](#buildConfig).

`entries` is used when:

* [validateConfigurations](#validateConfigurations)
* [mergeGlobalConfigs](#mergeGlobalConfigs)
* [normalizeConfigKey](#normalizeConfigKey) and [normalizeConfigKeys](#normalizeConfigKeys)

## <span id="mergeGlobalConfigs"> mergeGlobalConfigs Utility

```scala
mergeGlobalConfigs(
  sqlConfs: SQLConf,
  tableConf: Map[String, String],
  protocol: Protocol): Map[String, String]
```

`mergeGlobalConfigs` finds all [spark.databricks.delta.properties.defaults](#sqlConfPrefix)-prefixed configuration properties among the [entries](#entries).

`mergeGlobalConfigs` is used when:

* `OptimisticTransactionImpl` is requested to [withGlobalConfigDefaults](OptimisticTransactionImpl.md#withGlobalConfigDefaults)
* `InitialSnapshot` is created

## <span id="validateConfigurations"> validateConfigurations Utility

```scala
validateConfigurations(
  configurations: Map[String, String]): Map[String, String]
```

`validateConfigurations`...FIXME

`validateConfigurations` is used when:

* `DeltaCatalog` is requested to [verifyTableAndSolidify](DeltaCatalog.md#verifyTableAndSolidify) and [alterTable](DeltaCatalog.md#alterTable)

## <span id="normalizeConfigKeys"> normalizeConfigKeys Utility

```scala
normalizeConfigKeys(
  propKeys: Seq[String]): Seq[String]
```

`normalizeConfigKeys`...FIXME

`normalizeConfigKeys` is used when:

* [AlterTableUnsetPropertiesDeltaCommand](commands/alter/AlterTableUnsetPropertiesDeltaCommand.md) is executed

## <span id="sqlConfPrefix"><span id="spark.databricks.delta.properties.defaults"> spark.databricks.delta.properties.defaults Prefix

DeltaConfigs uses **spark.databricks.delta.properties.defaults** prefix for [global configuration properties](#mergeGlobalConfigs).
