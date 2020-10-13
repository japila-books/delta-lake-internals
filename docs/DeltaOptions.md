# DeltaOptions

[[DeltaWriteOptionsImpl]][[DeltaWriteOptions]][[DeltaReadOptions]]
`DeltaOptions` (aka `DeltaWriteOptionsImpl`, `DeltaWriteOptions`) is the options for the <<DeltaDataSource.md#, Delta data source>>.

The <<options, options>> can be defined using `option` method of `DataFrameReader`, `DataFrameWriter`, `DataStreamReader`, and `DataStreamWriter`.

DeltaOptions is used to create <<WriteIntoDelta.md#, WriteIntoDelta>> command, <<DeltaSink.md#, DeltaSink>>, and <<DeltaSource.md#, DeltaSource>>.

`DeltaOptions` can be [verified](#verifyOptions).

## <span id="validOptionKeys"> Options

=== [[checkpointLocation]] checkpointLocation

=== [[DATA_CHANGE_OPTION]][[dataChange]] dataChange

=== [[EXCLUDE_REGEX_OPTION]][[excludeRegex]] excludeRegex

=== [[IGNORE_CHANGES_OPTION]][[ignoreChanges]] ignoreChanges

=== [[IGNORE_DELETES_OPTION]][[ignoreDeletes]] ignoreDeletes

=== [[IGNORE_FILE_DELETION_OPTION]][[ignoreFileDeletion]] ignoreFileDeletion

=== [[MAX_BYTES_PER_TRIGGER_OPTION]][[maxBytesPerTrigger]] maxBytesPerTrigger

=== [[MAX_FILES_PER_TRIGGER_OPTION]][[maxFilesPerTrigger]][[MAX_FILES_PER_TRIGGER_OPTION_DEFAULT]] maxFilesPerTrigger

Maximum number of files (<<AddFile.md#, AddFiles>>) that <<DeltaSource.md#, DeltaSource>> will <<DeltaSource.md#getChangesWithRateLimit, scan>> (_read_) in a streaming micro-batch (_trigger_)

Default: `1000`

Must be at least `1`

=== [[MERGE_SCHEMA_OPTION]][[mergeSchema]][[canMergeSchema]] mergeSchema

Enables schema migration (e.g. allows automatic schema merging during a write operation for <<WriteIntoDelta.md#, WriteIntoDelta>> and <<DeltaSink.md#, DeltaSink>>)

Equivalent SQL Session configuration: <<DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE, spark.databricks.delta.schema.autoMerge.enabled>>

=== [[OPTIMIZE_WRITE_OPTION]][[optimizeWrite]] optimizeWrite

=== [[OVERWRITE_SCHEMA_OPTION]][[overwriteSchema]] overwriteSchema

=== [[path]] path

*(required)* Directory on a Hadoop DFS-compliant file system with an optional <<time-travel.md#, time travel>> identifier.

Default: (undefined)

Can also be specified using `load` method of `DataFrameReader` and `DataStreamReader`.

=== [[queryName]] queryName

=== [[REPLACE_WHERE_OPTION]][[replaceWhere]] replaceWhere

=== [[timestampAsOf]] timestampAsOf

<<time-travel.md#, Time traveling>> using a timestamp of a table

Mutually exclusive with <<versionAsOf, versionAsOf>> option and the time travel identifier of the <<path, path>> option.

=== [[USER_METADATA_OPTION]][[userMetadata]] userMetadata

Defines a CommitInfo.md#userMetadata[user-defined commit metadata]

Take precedence over DeltaSQLConf.md#commitInfo.userMetadata[spark.databricks.delta.commitInfo.userMetadata]

Available by inspecting CommitInfo.md[]s using delta-sql.md#DESCRIBE-HISTORY[DESCRIBE HISTORY] or DeltaTable.md#history[DeltaTable.history].

=== [[versionAsOf]] versionAsOf

<<time-travel.md#, Time traveling>> using a version of a table

Mutually exclusive with <<timestampAsOf, timestampAsOf>> option and the time travel identifier of the <<path, path>> option.

Used exclusively when `DeltaDataSource` is requested for a <<DeltaDataSource.md#RelationProvider-createRelation, relation (as a RelationProvider)>>

== [[creating-instance]] Creating Instance

DeltaOptions takes the following to be created:

* Options (`Map[String, String]` or `CaseInsensitiveMap[String]`)
* [[sqlConf]] `SQLConf`

DeltaOptions is created when:

* `DeltaLog` is requested to <<DeltaLog.md#createRelation, create a relation>> (for <<DeltaDataSource.md#, DeltaDataSource>> as a <<DeltaDataSource.md#CreatableRelationProvider, CreatableRelationProvider>> and a <<DeltaDataSource.md#RelationProvider, RelationProvider>>)

* `DeltaDataSource` is requested to <<DeltaDataSource.md#createSource, create a streaming source>> (to create a <<DeltaSource.md#, DeltaSource>> for Structured Streaming), <<DeltaDataSource.md#createSink, create a streaming sink>> (to create a <<DeltaSink.md#, DeltaSink>> for Structured Streaming), and <<DeltaDataSource.md#CreatableRelationProvider-createRelation, create an insertable HadoopFsRelation>>

## <span id="verifyOptions"> Verifying Options

```scala
verifyOptions(
  options: CaseInsensitiveMap[String]): Unit
```

`verifyOptions`...FIXME
