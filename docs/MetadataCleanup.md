= MetadataCleanup

`MetadataCleanup` is an abstraction of <<implementations, MetadataCleanups>> that can <<doLogCleanup, clean up>> the <<self, DeltaLog>>.

[[implementations]][[self]]
NOTE: <<DeltaLog.adoc#, DeltaLog>> is the default and only known `MetadataCleanup` in Delta Lake.

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.delta.MetadataCleanup` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.delta.MetadataCleanup=ALL
```

Refer to <<logging.adoc#, Logging>>.
====

== [[doLogCleanup]] `doLogCleanup` Method

[source, scala]
----
doLogCleanup(): Unit
----

[NOTE]
====
`doLogCleanup` is part of the <<Checkpoints.adoc#doLogCleanup, Checkpoints Contract>> to...FIXME.

Interestingly, this `MetadataCleanup` and <<Checkpoints.adoc#, Checkpoints>> abstractions require to be used with <<DeltaLog.adoc#, DeltaLog>> only.
====

`doLogCleanup` <<cleanUpExpiredLogs, cleanUpExpiredLogs>> when the <<enableExpiredLogCleanup, enableExpiredLogCleanup>> table property is enabled.

== [[enableExpiredLogCleanup]] enableExpiredLogCleanup Table Property -- `enableExpiredLogCleanup` Method

[source, scala]
----
enableExpiredLogCleanup: Boolean
----

`enableExpiredLogCleanup` gives the value of <<DeltaConfigs.adoc#ENABLE_EXPIRED_LOG_CLEANUP, enableExpiredLogCleanup>> table property (<<DeltaConfigs.adoc#fromMetaData, from>> the <<DeltaLog.adoc#metadata, Metadata>>).

NOTE: `enableExpiredLogCleanup` is used exclusively when `MetadataCleanup` is requested to <<doLogCleanup, doLogCleanup>>.

== [[deltaRetentionMillis]] logRetentionDuration Table Property -- `deltaRetentionMillis` Method

[source, scala]
----
deltaRetentionMillis: Long
----

`deltaRetentionMillis` gives the value of <<DeltaConfigs.adoc#LOG_RETENTION, logRetentionDuration>> table property (<<DeltaConfigs.adoc#fromMetaData, from>> the <<DeltaLog.adoc#metadata, Metadata>>).

NOTE: `deltaRetentionMillis` is used when...FIXME

== [[cleanUpExpiredLogs]] `cleanUpExpiredLogs` Internal Method

[source, scala]
----
cleanUpExpiredLogs(): Unit
----

`cleanUpExpiredLogs` calculates a so-called `fileCutOffTime` based on the <<DeltaLog.adoc#clock, current time>> and the <<deltaRetentionMillis, logRetentionDuration>> table property.

`cleanUpExpiredLogs` prints out the following INFO message to the logs:

```
Starting the deletion of log files older than [date]
```

`cleanUpExpiredLogs` <<listExpiredDeltaLogs, finds the expired delta logs>> (based on the `fileCutOffTime`) and deletes the files (using Hadoop's link:++https://hadoop.apache.org/docs/r2.6.5/api/org/apache/hadoop/fs/FileSystem.html#delete(org.apache.hadoop.fs.Path,%20boolean)++[FileSystem.delete] non-recursively).

In the end, `cleanUpExpiredLogs` prints out the following INFO message to the logs:

```
Deleted numDeleted log files older than [date]
```

NOTE: `cleanUpExpiredLogs` is used exclusively when `MetadataCleanup` is requested to <<doLogCleanup, doLogCleanup>>.

== [[listExpiredDeltaLogs]] Finding Expired Delta Logs -- `listExpiredDeltaLogs` Internal Method

[source, scala]
----
listExpiredDeltaLogs(
  fileCutOffTime: Long): Iterator[FileStatus]
----

`listExpiredDeltaLogs`...FIXME

requests the <<DeltaLog.adoc#store, LogStore>> for the <<LogStore.adoc#listFrom, paths (in the same directory)>> that are (lexicographically) greater or equal to the ``0``th checkpoint file (per <<FileNames.adoc#checkpointPrefix, checkpointPrefix>> format) of the <<FileNames.adoc#isCheckpointFile, checkpoint>> and <<FileNames.adoc#isDeltaFile, delta>> files in the <<DeltaLog.adoc#logPath, log directory>> (of the <<self, DeltaLog>>).

In the end, `listExpiredDeltaLogs` creates a `BufferingLogDeletionIterator` that...FIXME

NOTE: `listExpiredDeltaLogs` is used exclusively when `MetadataCleanup` is requested to <<cleanUpExpiredLogs, cleanUpExpiredLogs>>.
