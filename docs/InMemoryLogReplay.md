= InMemoryLogReplay -- Delta Log Replay

`InMemoryLogReplay` is used at the very last phase of <<Snapshot.md#stateReconstruction, state reconstruction>> (of a <<Snapshot.md#cachedState, cached delta state>>).

`InMemoryLogReplay` is <<creating-instance, created>> for every partition of the <<Snapshot.md#stateReconstruction, stateReconstruction>> dataset (`Dataset[SingleAction]`) that is based on the <<DeltaSQLConf.md#DELTA_SNAPSHOT_PARTITIONS, spark.databricks.delta.snapshotPartitions>> configuration property (default: `50`).

The lifecycle of `InMemoryLogReplay` is as follows:

. <<creating-instance, Created>> (with <<Snapshot.md#minFileRetentionTimestamp, Snapshot.minFileRetentionTimestamp>>)

. <<append, Append>> (with all <<SingleAction.md#, SingleActions>> of a partition)

. <<checkpoint, Checkpoint>>

== [[creating-instance]] Creating InMemoryLogReplay Instance

`InMemoryLogReplay` takes the following to be created:

* [[minFileRetentionTimestamp]] `minFileRetentionTimestamp` (that is exactly <<Snapshot.md#minFileRetentionTimestamp, Snapshot.minFileRetentionTimestamp>>)

`InMemoryLogReplay` initializes the <<internal-properties, internal properties>>.

== [[append]] Appending Actions -- `append` Method

[source, scala]
----
append(
  version: Long,
  actions: Iterator[Action]): Unit
----

`append` sets the <<currentVersion, currentVersion>> as the given `version`.

`append` adds <<Action.md#, actions>> to respective registries:

* Every <<SetTransaction.md#, SetTransaction>> is registered in the <<transactions, transactions>> by <<SetTransaction.md#appId, appId>>

* <<Metadata.md#, Metadata>> is registered as the <<currentMetaData, currentMetaData>>

* <<Protocol.md#, Protocol>> is registered as the <<currentProtocolVersion, currentProtocolVersion>>

* Every <<AddFile.md#, AddFile>> is registered as follows:
** Added to <<activeFiles, activeFiles>> by `pathAsUri` (with `dataChange` flag turned off)
** Removed from <<tombstones, tombstones>> by `pathAsUri`

* Every <<FileAction.md#RemoveFile, RemoveFile>> is registered as follows:
** Removed from <<activeFiles, activeFiles>> by `pathAsUri`
** Added to <<tombstones, tombstones>> by `pathAsUri` (with `dataChange` flag turned off)

* <<CommitInfo.md#, CommitInfos>> are ignored

`append` throws an `AssertionError` when the <<currentVersion, currentVersion>> is neither `-1` (the default) nor one before the given `version`:

```
Attempted to replay version [version], but state is at [currentVersion]
```

NOTE: `append` is used when `Snapshot` is created (and initializes the <<Snapshot.md#stateReconstruction, stateReconstruction>> for the <<Snapshot.md#cachedState, cached delta state>>).

== [[checkpoint]] Current State Of Delta Table -- `checkpoint` Method

[source, scala]
----
checkpoint: Iterator[Action]
----

`checkpoint` simply builds a sequence (`Iterator[Action]`) of the following (in that order):

* <<currentProtocolVersion, currentProtocolVersion>> if defined (non-``null``)

* <<currentMetaData, currentMetaData>> if defined (non-``null``)

* <<transactions, SetTransactions>>

* <<activeFiles, AddFiles>> and <<getTombstones, RemoveFiles>> (after the <<minFileRetentionTimestamp, minFileRetentionTimestamp>>) sorted by <<FileAction.md#path, path>> (lexicographically)

NOTE: `checkpoint` is used when `Snapshot` is created (and initializes the <<Snapshot.md#stateReconstruction, stateReconstruction>> for the <<Snapshot.md#cachedState, cached delta state>>).

== [[getTombstones]] `getTombstones` Internal Method

[source, scala]
----
getTombstones: Iterable[FileAction]
----

`getTombstones` returns <<FileAction.md#RemoveFile, RemoveFiles>> (from the <<tombstones, tombstones>>) with their `delTimestamp` after the <<minFileRetentionTimestamp, minFileRetentionTimestamp>>.

NOTE: `getTombstones` is used when `InMemoryLogReplay` is requested to <<checkpoint, checkpoint>>.

== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| currentProtocolVersion
a| [[currentProtocolVersion]] <<Protocol.md#, Protocol>> (default: `null`)

Used when...FIXME

| currentVersion
a| [[currentVersion]] Version (default: `-1`)

Used when...FIXME

| currentMetaData
a| [[currentMetaData]] <<Metadata.md#, Metadata>> (default: `null`)

Used when...FIXME

| transactions
a| [[transactions]] <<SetTransaction.md#, SetTransactions>> per ID (`HashMap[String, SetTransaction]`)

Used when...FIXME

| activeFiles
a| [[activeFiles]] <<AddFile.md#, AddFile>> per URI (`HashMap[URI, AddFile]`)

Used when...FIXME

| tombstones
a| [[tombstones]] <<FileAction.md.md#RemoveFile, RemoveFile>> per URI (`HashMap[URI, RemoveFile]`)

Used when...FIXME

|===
