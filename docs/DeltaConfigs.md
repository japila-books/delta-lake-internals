= DeltaConfigs

*DeltaConfigs* defines <<configuration-properties, reservoir configuration properties>> (aka _table properties_).

Table properties can be assigned a value using `ALTER TABLE` SQL command:

```
ALTER TABLE <table_name> SET TBLPROPERTIES (<key>=<value>)
```

[[sqlConfPrefix]][[spark.databricks.delta.properties.defaults]]
DeltaConfigs uses *spark.databricks.delta.properties.defaults* prefix for <<mergeGlobalConfigs, global configuration properties>>.

[[configuration-properties]]
.Reservoir Configuration Properties
[cols="30m,70",options="header",width="100%"]
|===
| Key
| Description

| appendOnly
a| [[appendOnly]][[IS_APPEND_ONLY]] Whether a delta table is append-only (`true`) or not (`false`). When enabled, a table allows appends only and no updates or deletes.

Default: `false`

| autoOptimize
a| [[autoOptimize]][[AUTO_OPTIMIZE]] Whether this delta table will automagically optimize the layout of files during writes.

Default: `false`

| checkpointInterval
a| [[checkpointInterval]][[CHECKPOINT_INTERVAL]] How often to checkpoint the state of a delta table

Default: `10`

| checkpointRetentionDuration
a| [[checkpointRetentionDuration]][[CHECKPOINT_RETENTION_DURATION]] How long to keep checkpoint files around before deleting them

Default: `interval 2 days`

The most recent checkpoint is never deleted. It is acceptable to keep checkpoint files beyond this duration until the next calendar day.

| compatibility.symlinkFormatManifest.enabled
a| [[compatibility.symlinkFormatManifest]][[SYMLINK_FORMAT_MANIFEST_ENABLED]] Whether to register the <<GenerateSymlinkManifest.md#, GenerateSymlinkManifest>> post-commit hook while <<OptimisticTransactionImpl.md#commit, committing a transaction>> or not

Default: `false`

| dataSkippingNumIndexedCols
a| [[dataSkippingNumIndexedCols]][[DATA_SKIPPING_NUM_INDEXED_COLS]] The number of columns to collect stats on for data skipping. `-1` means collecting stats for all columns.

Default: `32`

| deletedFileRetentionDuration
a| [[deletedFileRetentionDuration]][[TOMBSTONE_RETENTION]] How long to keep logically deleted data files around before deleting them physically (to prevent failures in stale readers after compactions or partition overwrites)

Default: `interval 1 week`

| enableExpiredLogCleanup
a| [[enableExpiredLogCleanup]][[ENABLE_EXPIRED_LOG_CLEANUP]] Whether to clean up expired log files and checkpoints

Default: `true`

| enableFullRetentionRollback
a| [[enableFullRetentionRollback]][[ENABLE_FULL_RETENTION_ROLLBACK]] When enabled (default), a delta table can be rolled back to any point within <<LOG_RETENTION, logRetentionDuration>>. When disabled, the table can be rolled back <<CHECKPOINT_RETENTION_DURATION, checkpointRetentionDuration>> only.

Default: `true`

| logRetentionDuration
a| [[logRetentionDuration]][[LOG_RETENTION]] How long to keep obsolete logs around before deleting them. Delta can keep logs beyond the duration until the next calendar day to avoid constantly creating checkpoints.

Default: `interval 30 days`

| randomizeFilePrefixes
a| [[randomizeFilePrefixes]][[RANDOMIZE_FILE_PREFIXES]] Whether to use a random prefix in a file path instead of partition information (may be required for very high volume S3 calls to better be partitioned across S3 servers)

Default: `false`

| randomPrefixLength
a| [[randomPrefixLength]][[RANDOM_PREFIX_LENGTH]] The length of the random prefix in a file path for <<RANDOMIZE_FILE_PREFIXES, randomizeFilePrefixes>>

Default: `2`

| sampleRetentionDuration
a| [[sampleRetentionDuration]][[SAMPLE_RETENTION]] How long to keep delta sample files around before deleting them

Default: `interval 7 days`

|===

== [[mergeGlobalConfigs]] `mergeGlobalConfigs` Utility

[source, scala]
----
mergeGlobalConfigs(
  sqlConfs: SQLConf,
  tableConf: Map[String, String],
  protocol: Protocol): Map[String, String]
----

`mergeGlobalConfigs` finds all <<sqlConfPrefix, spark.databricks.delta.properties.defaults>>-prefixed configuration properties among the <<entries, entries>>.

NOTE: `mergeGlobalConfigs` is used when `OptimisticTransactionImpl` is requested for the OptimisticTransactionImpl.md#snapshotMetadata[metadata], to OptimisticTransactionImpl.md#updateMetadata[update the metadata], and OptimisticTransactionImpl.md#prepareCommit[prepare a commit] (for new delta tables).

== [[verifyProtocolVersionRequirements]] verifyProtocolVersionRequirements Utility

[source, scala]
----
verifyProtocolVersionRequirements(
  configurations: Map[String, String],
  current: Protocol): Unit
----

verifyProtocolVersionRequirements...FIXME

verifyProtocolVersionRequirements is used when...FIXME

== [[buildConfig]] Creating DeltaConfig Instance -- `buildConfig` Internal Utility

[source, scala]
----
buildConfig[T](
  key: String,
  defaultValue: String,
  fromString: String => T,
  validationFunction: T => Boolean,
  helpMessage: String,
  minimumProtocolVersion: Option[Protocol] = None): DeltaConfig[T]
----

`buildConfig` creates a DeltaConfig.md[DeltaConfig] for the given `key` (with *delta* prefix) and adds it to the <<entries, entries>> internal registry.

NOTE: `buildConfig` is used to define all of the <<configuration-properties, reservoir configuration properties>>.

== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| entries
a| [[entries]]

[source, scala]
----
HashMap[String, DeltaConfig[_]]
----

|===
