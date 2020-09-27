# Checkpoints

`Checkpoints` is an <<contract, abstraction>> of <<implementations, DeltaLogs>> that can <<checkpoint, checkpoint>> the current state of a delta table (represented by the <<self, DeltaLog>>).

[[contract]]
.Checkpoints Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| logPath
a| [[logPath]]

[source, scala]
----
logPath: Path
----

Used when...FIXME

| dataPath
a| [[dataPath]]

[source, scala]
----
dataPath: Path
----

Used when...FIXME

| snapshot
a| [[snapshot]]

[source, scala]
----
snapshot: Snapshot
----

Used when...FIXME

| store
a| [[store]]

[source, scala]
----
store: LogStore
----

Used when...FIXME

| metadata
a| [[metadata]]

[source, scala]
----
metadata: Metadata
----

<<Metadata.md#, Metadata>> of (the current state of) the <<self, delta table>>

Used when...FIXME

| doLogCleanup
a| [[doLogCleanup]]

[source, scala]
----
doLogCleanup(): Unit
----

Used when...FIXME

|===

[[implementations]][[self]]
NOTE: <<DeltaLog.md#, DeltaLog>> is the default and only known `Checkpoints` in Delta Lake.

== [[LAST_CHECKPOINT]][[_last_checkpoint]] _last_checkpoint Metadata File

`Checkpoints` uses *_last_checkpoint* metadata file (under the <<DeltaLog.md#logPath, log path>>) for the following:

* <<checkpoint, Writing checkpoint metadata out>>

* <<loadMetadataFromFile, Loading checkpoint metadata in>>

== [[checkpoint]] Checkpointing -- `checkpoint` Method

[source, scala]
----
checkpoint(): Unit
checkpoint(
  snapshotToCheckpoint: Snapshot): CheckpointMetaData
----

`checkpoint`...FIXME

NOTE: `checkpoint` is used when...FIXME

## <span id="lastCheckpoint"> Loading Latest Checkpoint Metadata

```scala
lastCheckpoint: Option[CheckpointMetaData]
```

`lastCheckpoint` simply [loadMetadataFromFile](#loadMetadataFromFile) (allowing for 3 retries).

`lastCheckpoint` is used when:

* `SnapshotManagement` is requested to [load the latest snapshot](SnapshotManagement.md#getSnapshotAtInit)
* `MetadataCleanup` is requested to [listExpiredDeltaLogs](MetadataCleanup.md#listExpiredDeltaLogs)

### <span id="loadMetadataFromFile"> loadMetadataFromFile Helper Method

```scala
loadMetadataFromFile(
  tries: Int): Option[CheckpointMetaData]
```

`loadMetadataFromFile` loads the [_last_checkpoint](LAST_CHECKPOINT) file (in JSON format) and converts it to `CheckpointMetaData` (with a version, size and parts).

`loadMetadataFromFile` uses the [LogStore](DeltaLog.md#store) to [read](#read) the [_last_checkpoint](LAST_CHECKPOINT) file.

In case the [_last_checkpoint](LAST_CHECKPOINT) file is corrupted, `loadMetadataFromFile`...FIXME

== [[manuallyLoadCheckpoint]] `manuallyLoadCheckpoint` Method

[source, scala]
----
manuallyLoadCheckpoint(cv: CheckpointInstance): CheckpointMetaData
----

`manuallyLoadCheckpoint`...FIXME

NOTE: `manuallyLoadCheckpoint` is used when...FIXME

== [[findLastCompleteCheckpoint]] `findLastCompleteCheckpoint` Method

[source, scala]
----
findLastCompleteCheckpoint(cv: CheckpointInstance): Option[CheckpointInstance]
----

`findLastCompleteCheckpoint`...FIXME

NOTE: `findLastCompleteCheckpoint` is used when...FIXME

== [[getLatestCompleteCheckpointFromList]] `getLatestCompleteCheckpointFromList` Method

[source, scala]
----
getLatestCompleteCheckpointFromList(
  instances: Array[CheckpointInstance],
  notLaterThan: CheckpointInstance): Option[CheckpointInstance]
----

`getLatestCompleteCheckpointFromList`...FIXME

NOTE: `getLatestCompleteCheckpointFromList` is used when...FIXME

== [[writeCheckpoint]] `writeCheckpoint` Utility

[source, scala]
----
writeCheckpoint(
  spark: SparkSession,
  deltaLog: DeltaLog,
  snapshot: Snapshot): CheckpointMetaData
----

`writeCheckpoint`...FIXME

NOTE: `writeCheckpoint` is used when `Checkpoints` is requested to <<checkpoint, checkpoint>>.
