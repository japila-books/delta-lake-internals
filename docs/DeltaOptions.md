= DeltaOptions

[[DeltaWriteOptionsImpl]][[DeltaWriteOptions]][[DeltaReadOptions]]
*DeltaOptions* (aka `DeltaWriteOptionsImpl`, `DeltaWriteOptions`) is the options for the <<DeltaDataSource.adoc#, Delta data source>>.

The <<options, options>> can be defined using `option` method of `DataFrameReader`, `DataFrameWriter`, `DataStreamReader`, and `DataStreamWriter`.

DeltaOptions is used to create <<WriteIntoDelta.adoc#, WriteIntoDelta>> command, <<DeltaSink.adoc#, DeltaSink>>, and <<DeltaSource.adoc#, DeltaSource>>.

DeltaOptions can be <<verifyOptions, verified>>.

== [[options]][[validOptionKeys]] Options

=== [[checkpointLocation]] checkpointLocation

=== [[DATA_CHANGE_OPTION]][[dataChange]] dataChange

=== [[EXCLUDE_REGEX_OPTION]][[excludeRegex]] excludeRegex

=== [[IGNORE_CHANGES_OPTION]][[ignoreChanges]] ignoreChanges

=== [[IGNORE_DELETES_OPTION]][[ignoreDeletes]] ignoreDeletes

=== [[IGNORE_FILE_DELETION_OPTION]][[ignoreFileDeletion]] ignoreFileDeletion

=== [[MAX_BYTES_PER_TRIGGER_OPTION]][[maxBytesPerTrigger]] maxBytesPerTrigger

=== [[MAX_FILES_PER_TRIGGER_OPTION]][[maxFilesPerTrigger]][[MAX_FILES_PER_TRIGGER_OPTION_DEFAULT]] maxFilesPerTrigger

Maximum number of files (<<AddFile.adoc#, AddFiles>>) that <<DeltaSource.adoc#, DeltaSource>> will <<DeltaSource.adoc#getChangesWithRateLimit, scan>> (_read_) in a streaming micro-batch (_trigger_)

Default: `1000`

Must be at least `1`

=== [[MERGE_SCHEMA_OPTION]][[mergeSchema]][[canMergeSchema]] mergeSchema

Enables schema migration (e.g. allows automatic schema merging during a write operation for <<WriteIntoDelta.adoc#, WriteIntoDelta>> and <<DeltaSink.adoc#, DeltaSink>>)

Equivalent SQL Session configuration: <<DeltaSQLConf.adoc#DELTA_SCHEMA_AUTO_MIGRATE, spark.databricks.delta.schema.autoMerge.enabled>>

=== [[OPTIMIZE_WRITE_OPTION]][[optimizeWrite]] optimizeWrite

=== [[OVERWRITE_SCHEMA_OPTION]][[overwriteSchema]] overwriteSchema

=== [[path]] path

*(required)* Directory on a Hadoop DFS-compliant file system with an optional <<time-travel.adoc#, time travel>> identifier.

Default: (undefined)

Can also be specified using `load` method of `DataFrameReader` and `DataStreamReader`.

=== [[queryName]] queryName

=== [[REPLACE_WHERE_OPTION]][[replaceWhere]] replaceWhere

=== [[timestampAsOf]] timestampAsOf

<<time-travel.adoc#, Time traveling>> using a timestamp of a table

Mutually exclusive with <<versionAsOf, versionAsOf>> option and the time travel identifier of the <<path, path>> option.

=== [[USER_METADATA_OPTION]][[userMetadata]] userMetadata

Defines a CommitInfo.adoc#userMetadata[user-defined commit metadata]

Take precedence over DeltaSQLConf.adoc#commitInfo.userMetadata[spark.databricks.delta.commitInfo.userMetadata]

Available by inspecting CommitInfo.adoc[]s using delta-sql.adoc#DESCRIBE-HISTORY[DESCRIBE HISTORY] or DeltaTable.adoc#history[DeltaTable.history].

=== [[versionAsOf]] versionAsOf

<<time-travel.adoc#, Time traveling>> using a version of a table

Mutually exclusive with <<timestampAsOf, timestampAsOf>> option and the time travel identifier of the <<path, path>> option.

Used exclusively when `DeltaDataSource` is requested for a <<DeltaDataSource.adoc#RelationProvider-createRelation, relation (as a RelationProvider)>>

== [[creating-instance]] Creating Instance

DeltaOptions takes the following to be created:

* Options (`Map[String, String]` or `CaseInsensitiveMap[String]`)
* [[sqlConf]] `SQLConf`

DeltaOptions is created when:

* `DeltaLog` is requested to <<DeltaLog.adoc#createRelation, create a relation>> (for <<DeltaDataSource.adoc#, DeltaDataSource>> as a <<DeltaDataSource.adoc#CreatableRelationProvider, CreatableRelationProvider>> and a <<DeltaDataSource.adoc#RelationProvider, RelationProvider>>)

* `DeltaDataSource` is requested to <<DeltaDataSource.adoc#createSource, create a streaming source>> (to create a <<DeltaSource.adoc#, DeltaSource>> for Structured Streaming), <<DeltaDataSource.adoc#createSink, create a streaming sink>> (to create a <<DeltaSink.adoc#, DeltaSink>> for Structured Streaming), and <<DeltaDataSource.adoc#CreatableRelationProvider-createRelation, create an insertable HadoopFsRelation>>

== [[verifyOptions]] verifyOptions Utility

[source, scala]
----
verifyOptions(
  options: CaseInsensitiveMap[String]): Unit
----

verifyOptions...FIXME

verifyOptions is used when:

* DeltaOptions is <<creating-instance, created>>

* DeltaDataSource is requested to <<DeltaDataSource.adoc#RelationProvider-createRelation, create a relation>>
