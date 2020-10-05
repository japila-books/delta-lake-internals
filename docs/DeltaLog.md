# DeltaLog

`DeltaLog` is a **transaction log** (_change log_) of [changes](Action.md) to the state of a [delta table](#dataPath).

`DeltaLog` uses [_delta_log](#_delta_log) directory for (the files of) the transaction log of a delta table (that is given when [DeltaLog.forTable](#forTable) utility is used to create an instance).

`DeltaLog` is created (indirectly via [DeltaLog.apply](#apply) utility) when [DeltaLog.forTable](#forTable) utility is used.

```text
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

val dataPath = "/tmp/delta/t1"
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)

import org.apache.hadoop.fs.Path
val expected = new Path(s"file:$dataPath/_delta_log/_last_checkpoint")
assert(deltaLog.LAST_CHECKPOINT == expected)
```

A common idiom (if not the only way) to know the current version of the delta table is to request the `DeltaLog` for the [current state (snapshot)](#snapshot) and then for the [version](Snapshot.md#version).

```text
import org.apache.spark.sql.delta.DeltaLog
assert(deltaLog.isInstanceOf[DeltaLog])

val deltaVersion = deltaLog.snapshot.version
scala> println(deltaVersion)
5
```

When created, `DeltaLog` does the following:

* Creates the <<store, LogStore>> based on <<LogStoreProvider.md#spark.delta.logStore.class, spark.delta.logStore.class>> configuration property (default: <<HDFSLogStore.md#, HDFSLogStore>>)

* Initializes the <<currentSnapshot, current snapshot>>

* <<update, Updates state of the delta table>> when there is no <<Checkpoints.md#lastCheckpoint, metadata checkpoint>> (e.g. the version of the <<currentSnapshot, state>> is `-1`)

In other words, the version of (the `DeltaLog` of) a delta table is at version `0` at the very minimum.

```scala
assert(deltaLog.snapshot.version >= 0)
```

`DeltaLog` is a [LogStoreProvider](LogStoreProvider.md).

## <span id="filterFileList"> filterFileList Utility

```scala
filterFileList(
  partitionSchema: StructType,
  files: DataFrame,
  partitionFilters: Seq[Expression],
  partitionColumnPrefixes: Seq[String] = Nil): DataFrame
```

`filterFileList`...FIXME

`filterFileList` is used when:

* `OptimisticTransactionImpl` is requested to [checkAndRetry](OptimisticTransactionImpl.md#checkAndRetry)
* `PartitionFiltering` is requested to [filesForScan](PartitionFiltering.md#filesForScan)
* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write)
* `SnapshotIterator` is requested to [iterator](SnapshotIterator.md#iterator)
* `TahoeBatchFileIndex` is requested to [matchingFiles](TahoeBatchFileIndex.md#matchingFiles)
* `DeltaDataSource` utility is requested to [verifyAndCreatePartitionFilters](DeltaDataSource.md#verifyAndCreatePartitionFilters)

== [[FileFormats]] FileFormats

`DeltaLog` defines two `FileFormats`:

* [[CHECKPOINT_FILE_FORMAT]] `ParquetFileFormat` for indices of delta files

* [[COMMIT_FILE_FORMAT]] `JsonFileFormat` for indices of checkpoint files

The `FileFormats` are used to create <<DeltaLogFileIndex.md#, DeltaLogFileIndices>> for <<Snapshot.md#files, Snapshots>> that in turn used them for <<Snapshot.md#stateReconstruction, stateReconstruction>>.

== [[_delta_log]] _delta_log Directory

`DeltaLog` uses *_delta_log* metadata directory under the <<dataPath, data path>> directory (that is specified using <<forTable, DeltaLog.forTable>> utility).

The `_delta_log` directory is resolved (in the <<apply, DeltaLog.apply>> utility) using the application-wide Hadoop https://hadoop.apache.org/docs/current2/api/org/apache/hadoop/conf/Configuration.html[Configuration].

[NOTE]
====
<<apply, DeltaLog.apply>> utility uses the given `SparkSession` to create an Hadoop `Configuration` instance.

[source, scala]
----
spark.sessionState.newHadoopConf()
----
====

Once resolved and turned into a qualified path, the `_delta_log` directory of the delta table (under the <<dataPath, data path>> directory) is <<deltaLogCache, cached>> for later reuse.

== [[store]] LogStore

`DeltaLog` uses an <<LogStore.md#, LogStore>> for...FIXME

== [[deltaLogCache]] Transaction Logs (DeltaLogs) per Fully-Qualified Path -- `deltaLogCache` Internal Registry

[source, scala]
----
deltaLogCache: Cache[Path, DeltaLog]
----

NOTE: `deltaLogCache` is part of `DeltaLog` Scala object which makes it an application-wide cache. Once used, `deltaLogCache` will only be one until the application that uses it stops.

`deltaLogCache` is a registry of `DeltaLogs` by their fully-qualified <<_delta_log, _delta_log>> directories. A new instance of `DeltaLog` is added when <<apply, DeltaLog.apply>> utility is used and the instance hasn't been created before for a path.

`deltaLogCache` is invalidated:

* For a delta table using <<invalidateCache, DeltaLog.invalidateCache>> utility (and <<apply, DeltaLog.apply>> when the cached reference is no longer <<isValid, valid>>)

* For all delta tables using <<clearCache, DeltaLog.clearCache>> utility

== [[creating-instance]] Creating DeltaLog Instance

`DeltaLog` takes the following to be created:

* [[logPath]] Log directory (Hadoop https://hadoop.apache.org/docs/r2.6.5/api/org/apache/hadoop/fs/Path.html[Path])
* [[dataPath]] Data directory (Hadoop https://hadoop.apache.org/docs/r2.6.5/api/org/apache/hadoop/fs/Path.html[Path])
* [[clock]] `Clock`

`DeltaLog` initializes the <<internal-properties, internal properties>>.

== [[apply]] Looking Up Or Creating DeltaLog Instance -- `apply` Utility

[source, scala]
----
apply(
  spark: SparkSession,
  rawPath: Path,
  clock: Clock = new SystemClock): DeltaLog
----

NOTE: `rawPath` is a Hadoop https://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/fs/Path.html[Path] to the <<_delta_log, _delta_log>> directory at the root of the data of a delta table.

`apply`...FIXME

NOTE: `apply` is used when `DeltaLog` is requested to <<forTable, forTable>>.

## <span id="withNewTransaction"> Executing Single-Threaded Operation in New Transaction

```scala
withNewTransaction[T](
  thunk: OptimisticTransaction => T): T
```

`withNewTransaction` [starts a new transaction](#startTransaction) (that is [active](OptimisticTransaction.md#setActive) for the whole thread) and executes the given `thunk` block.

In the end, `withNewTransaction` makes the transaction [no longer active](OptimisticTransaction.md#clearActive).

`withNewTransaction` is used when:

* [DeleteCommand](commands/DeleteCommand.md), [MergeIntoCommand](commands/MergeIntoCommand.md), [UpdateCommand](commands/UpdateCommand.md), and [WriteIntoDelta](commands/WriteIntoDelta.md) commands are executed

* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)

## <span id="startTransaction"> Starting New Transaction

```scala
startTransaction(): OptimisticTransaction
```

startTransaction <<update, updates>> and creates a new OptimisticTransaction.md[] (for this DeltaLog).

NOTE: startTransaction is a subset of <<withNewTransaction, withNewTransaction>>.

startTransaction is used when:

* DeltaLog is requested to <<upgradeProtocol, upgradeProtocol>>

* AlterDeltaTableCommand is requested to AlterDeltaTableCommand.md#startTransaction[startTransaction]

* ConvertToDeltaCommandBase is ConvertToDeltaCommand.md#run[executed]

* CreateDeltaTableCommand is CreateDeltaTableCommand.md#run[executed]

== [[assertRemovable]] Throwing UnsupportedOperationException For appendOnly Table Property Enabled -- `assertRemovable` Method

[source, scala]
----
assertRemovable(): Unit
----

`assertRemovable` throws an `UnsupportedOperationException` for the <<DeltaConfigs.md#IS_APPEND_ONLY, appendOnly>> table property (<<DeltaConfigs.md#fromMetaData, in>> the <<metadata, Metadata>>) enabled (`true`):

```
This table is configured to only allow appends. If you would like to permit updates or deletes, use 'ALTER TABLE <table_name> SET TBLPROPERTIES (appendOnly=false)'.
```

NOTE: `assertRemovable` is used when...FIXME

== [[metadata]] `metadata` Method

[source, scala]
----
metadata: Metadata
----

NOTE: `metadata` is part of the <<Checkpoints.md#metadata, Checkpoints Contract>> to...FIXME.

`metadata` requests the <<snapshot, current Snapshot>> for the <<Snapshot.md#metadata, metadata>> or creates a new <<Metadata.md#, one>> (if the <<snapshot, current Snapshot>> is not initialized).

== [[forTable]] Creating DeltaLog Instance -- `forTable` Utility

[source, scala]
----
forTable(
  spark: SparkSession,
  dataPath: File): DeltaLog
forTable(
  spark: SparkSession,
  dataPath: File,
  clock: Clock): DeltaLog
forTable(
  spark: SparkSession,
  dataPath: Path): DeltaLog
forTable(
  spark: SparkSession,
  dataPath: Path,
  clock: Clock): DeltaLog
forTable(
  spark: SparkSession,
  dataPath: String): DeltaLog
forTable(
  spark: SparkSession,
  dataPath: String,
  clock: Clock): DeltaLog
----

`forTable` creates a <<apply, DeltaLog>> with *_delta_log* directory (in the given `dataPath` directory).

[NOTE]
====
`forTable` is used when:

* <<DeltaTable.md#forPath, DeltaTable.forPath>> utility is used to create a <<DeltaTable.md#, DeltaTable>>

* <<ConvertToDeltaCommand.md#, ConvertToDeltaCommand>>, <<DescribeDeltaHistoryCommand.md#, DescribeDeltaHistoryCommand>>, <<VacuumTableCommand.md#, VacuumTableCommand>> are requested to `run`

* `DeltaDataSource` is requested to <<DeltaDataSource.md#sourceSchema, sourceSchema>>, <<DeltaDataSource.md#createSource, createSource>>, and create a relation (as <<DeltaDataSource.md#CreatableRelationProvider-createRelation, CreatableRelationProvider>> and <<DeltaDataSource.md#RelationProvider-createRelation, RelationProvider>>)

* <<DeltaTableUtils.md#combineWithCatalogMetadata, DeltaTableUtils.combineWithCatalogMetadata>> utility is used

* `DeltaTableIdentifier` is requested to `getDeltaLog`

* <<DeltaSink.md#, DeltaSink>> is created
====

== [[update]] `update` Method

[source, scala]
----
update(
  stalenessAcceptable: Boolean = false): Snapshot
----

`update` branches off based on a combination of flags: the given `stalenessAcceptable` and <<isSnapshotStale, isSnapshotStale>> flags.

For the `stalenessAcceptable` not acceptable (default) and the <<isSnapshotStale, snapshot not stale>>, `update` simply acquires the <<deltaLogLock, deltaLogLock>> lock and <<updateInternal, updateInternal>> (with `isAsync` flag off).

For all other cases, `update`...FIXME

[NOTE]
====
`update` is used when:

* `DeltaHistoryManager` is requested to <<DeltaHistoryManager.md#getHistory, getHistory>>, <<DeltaHistoryManager.md#getActiveCommitAtTime, getActiveCommitAtTime>>, and <<DeltaHistoryManager.md#checkVersionExists, checkVersionExists>>

* `DeltaLog` is <<creating-instance, created>> (with no <<Checkpoints.md#lastCheckpoint, checkpoint>> created), and requested to <<startTransaction, startTransaction>> and <<withNewTransaction, withNewTransaction>>

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#doCommit, doCommit>> and <<OptimisticTransactionImpl.md#checkAndRetry, checkAndRetry>>

* `ConvertToDeltaCommand` is requested to <<ConvertToDeltaCommand.md#run, run>> and <<ConvertToDeltaCommand.md#streamWrite, streamWrite>>

* `VacuumCommand` utility is used to <<VacuumCommand.md#gc, gc>>

* `TahoeLogFileIndex` is requested for the <<TahoeLogFileIndex.md#getSnapshot, (historical or latest) snapshot>>

* `DeltaDataSource` is requested for a <<DeltaDataSource.md#RelationProvider-createRelation, relation>>
====

== [[snapshot]] Current State Snapshot -- `snapshot` Method

[source, scala]
----
snapshot: Snapshot
----

`snapshot` returns the <<currentSnapshot, current snapshot>>.

[NOTE]
====
`snapshot` is used when:

* <<OptimisticTransaction.md#, OptimisticTransaction>> is created

* `Checkpoints` is requested to <<checkpoint, checkpoint>>

* `DeltaLog` is requested for the <<metadata, metadata>>, to <<upgradeProtocol, upgradeProtocol>>, <<getSnapshotAt, getSnapshotAt>>, <<createRelation, createRelation>>

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#getNextAttemptVersion, getNextAttemptVersion>>

* <<DeleteCommand.md#, DeleteCommand>>, <<DeltaGenerateCommand.md#, DeltaGenerateCommand>>, <<DescribeDeltaDetailCommand.md#, DescribeDeltaDetailCommand>>, <<UpdateCommand.md#, UpdateCommand>>, <<GenerateSymlinkManifest.md#, GenerateSymlinkManifest>> are executed

* DeltaCommand is requested to <<DeltaCommand.md#buildBaseRelation, buildBaseRelation>>

* `TahoeFileIndex` is requested for the <<TahoeFileIndex.md#tableVersion, table version>>, <<TahoeFileIndex.md#partitionSchema, partitionSchema>>

* `TahoeLogFileIndex` is requested for the <<TahoeLogFileIndex.md#sizeInBytes, table size>>

* `DeltaDataSource` is requested for the <<DeltaDataSource.md#sourceSchema, schema of the streaming delta source>>

* <<DeltaSource.md#, DeltaSource>> is created and requested for the <<DeltaSource.md#getStartingOffset, getStartingOffset>>, <<DeltaSource.md#getBatch, getBatch>>
====

== [[currentSnapshot]] Current State Snapshot -- `currentSnapshot` Internal Registry

[source, scala]
----
currentSnapshot: Snapshot
----

`currentSnapshot` is a <<Snapshot.md#, Snapshot>> based on the <<Checkpoints.md#lastCheckpoint, metadata checkpoint>> if available or a new `Snapshot` instance (with version being `-1`).

NOTE: For a new `Snapshot` instance (with version being `-1`) `DeltaLog` immediately <<update, updates the state>>.

Internally, `currentSnapshot`...FIXME

NOTE: `currentSnapshot` is available using <<snapshot, snapshot>> method.

NOTE: `currentSnapshot` is used when `DeltaLog` is requested to <<updateInternal, updateInternal>>, <<update, update>>, <<tryUpdate, tryUpdate>>, and <<isValid, isValid>.

## <span id="createRelation"> Creating Insertable HadoopFsRelation For Batch Queries

```scala
createRelation(
  partitionFilters: Seq[Expression] = Nil,
  timeTravel: Option[DeltaTimeTravelSpec] = None): BaseRelation
```

`createRelation`...FIXME

`createRelation` creates a [TahoeLogFileIndex](TahoeLogFileIndex.md) for the [data path](#dataPath), the given `partitionFilters` and a version (if defined).

`createRelation`...FIXME

In the end, `createRelation` creates a `HadoopFsRelation` for the `TahoeLogFileIndex` and...FIXME. The `HadoopFsRelation` is also an <<createRelation-InsertableRelation, InsertableRelation>>.

`createRelation` is used when `DeltaDataSource` is requested for a relation as a [CreatableRelationProvider](DeltaDataSource.md#CreatableRelationProvider) and a [RelationProvider](DeltaDataSource.md#RelationProvider) (for batch queries).

## <span id="createRelation-InsertableRelation"><span id="createRelation-InsertableRelation-insert"> insert Method

```scala
insert(
  data: DataFrame,
  overwrite: Boolean): Unit
```

`insert`...FIXME

`insert` is part of the `InsertableRelation` abstraction.

== [[getSnapshotAt]] Retrieving State Of Delta Table At Given Version -- `getSnapshotAt` Method

[source, scala]
----
getSnapshotAt(
  version: Long,
  commitTimestamp: Option[Long] = None,
  lastCheckpointHint: Option[CheckpointInstance] = None): Snapshot
----

`getSnapshotAt`...FIXME

[NOTE]
====
`getSnapshotAt` is used when:

* `DeltaLog` is requested for a <<createRelation, relation>>, and to <<updateInternal, updateInternal>>

* `DeltaSource` is requested to <<DeltaSource.md#getSnapshotAt, getSnapshotAt>>

* `TahoeLogFileIndex` is requested for <<TahoeLogFileIndex.md#historicalSnapshotOpt, historicalSnapshotOpt>>
====

== [[tryUpdate]] `tryUpdate` Method

[source, scala]
----
tryUpdate(
  isAsync: Boolean = false): Snapshot
----

`tryUpdate`...FIXME

NOTE: `tryUpdate` is used exclusively when `DeltaLog` is requested to <<update, update>>.

== [[ensureLogDirectoryExist]] `ensureLogDirectoryExist` Method

[source, scala]
----
ensureLogDirectoryExist(): Unit
----

`ensureLogDirectoryExist`...FIXME

NOTE: `ensureLogDirectoryExist` is used when...FIXME

== [[protocolWrite]] `protocolWrite` Method

[source, scala]
----
protocolWrite(
  protocol: Protocol,
  logUpgradeMessage: Boolean = true): Unit
----

`protocolWrite`...FIXME

NOTE: `protocolWrite` is used when...FIXME

== [[checkpointInterval]] `checkpointInterval` Method

[source, scala]
----
checkpointInterval: Int
----

`checkpointInterval` gives the value of <<DeltaConfigs.md#CHECKPOINT_INTERVAL, checkpointInterval>> table property (<<DeltaConfigs.md#fromMetaData, from>> the <<metadata, Metadata>>).

NOTE: `checkpointInterval` is used when...FIXME

== [[getChanges]] Changes (Actions) Of Delta Version And Later -- `getChanges` Method

[source, scala]
----
getChanges(
  startVersion: Long): Iterator[(Long, Seq[Action])]
----

`getChanges` gives all <<Action.md#, actions>> (_changes_) per delta log file for the given `startVersion` of a delta table and later.

[source,scala]
----
val dataPath = "/tmp/delta/users"
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)
assert(deltaLog.isInstanceOf[DeltaLog])
val changesPerVersion = deltaLog.getChanges(startVersion = 0)
----

Internally, `getChanges` requests the <<store, LogStore>> for <<LogStore.md#listFrom, files>> that are lexicographically greater or equal to the <<FileNames.md#deltaFile, delta log file>> for the given `startVersion` (in the <<logPath, logPath>>) and leaves only <<FileNames.md#isDeltaFile, delta log files>> (e.g. files with numbers only as file name and `.json` file extension).

For every delta file, `getChanges` requests the <<store, LogStore>> to <<LogStore.md#read, read the JSON content>> (every line is an <<Action.md#, action>>), and then <<Action.md#fromJson, deserializes it to an action>>.

NOTE: `getChanges` is used when `DeltaSource` is requested for the <<DeltaSource.md#getChanges, indexed file additions (FileAdd actions)>>.

## <span id="createDataFrame"> Creating DataFrame For Given AddFiles

```scala
createDataFrame(
  snapshot: Snapshot,
  addFiles: Seq[AddFile],
  isStreaming: Boolean = false,
  actionTypeOpt: Option[String] = None): DataFrame
```

`createDataFrame` uses the action type based on the optional action type (if defined) or uses the following based on the `isStreaming` flag:

* **streaming** when `isStreaming` flag is enabled (`true`)
* **batch** when `isStreaming` flag is disabled (`false`)

!!! note
    `actionTypeOpt` seems not to be defined ever.

`createDataFrame` creates a new [TahoeBatchFileIndex](TahoeBatchFileIndex.md) (for the action type, and the given [AddFile](AddFile.md)s and [Snapshot](Snapshot.md)).

`createDataFrame` creates a `HadoopFsRelation` with the `TahoeBatchFileIndex` and the other properties based on the given `Snapshot` (and the associated [Metadata](Snapshot.md#metadata)).

!!! tip
    Learn more on [HadoopFsRelation](https://jaceklaskowski.github.io/mastering-spark-sql-book/spark-sql-BaseRelation-HadoopFsRelation/) in [The Internals of Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book) online book.

In the end, `createDataFrame` creates a `DataFrame` with a logical query plan with a `LogicalRelation` over the `HadoopFsRelation`.

!!! tip
    Learn more on [LogicalRelation](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/LogicalRelation/) in [The Internals of Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book) online book.

`createDataFrame` is used when:

* [MergeIntoCommand](commands/MergeIntoCommand.md) is executed
* `DeltaSource` is requested for a [DataFrame for data between start and end offsets](DeltaSource.md#getBatch)

== [[lockInterruptibly]] Acquiring Interruptible Lock on Log -- `lockInterruptibly` Method

[source, scala]
----
lockInterruptibly[T](body: => T): T
----

`lockInterruptibly`...FIXME

NOTE: `lockInterruptibly` is used when...FIXME

== [[minFileRetentionTimestamp]] `minFileRetentionTimestamp` Method

[source, scala]
----
minFileRetentionTimestamp: Long
----

`minFileRetentionTimestamp` is the timestamp that is <<tombstoneRetentionMillis, tombstoneRetentionMillis>> before the current time (per the <<clock, Clock>>).

[NOTE]
====
`minFileRetentionTimestamp` is used when:

* `DeltaLog` is requested for the <<currentSnapshot, currentSnapshot>>, to <<updateInternal, updateInternal>>, and to <<getSnapshotAt, getSnapshotAt>>

* `VacuumCommand` is requested for <<VacuumCommand.md#gc, garbage collecting of a delta table>>
====

== [[tombstoneRetentionMillis]] `tombstoneRetentionMillis` Method

[source, scala]
----
tombstoneRetentionMillis: Long
----

`tombstoneRetentionMillis` gives the value of <<DeltaConfigs.md#TOMBSTONE_RETENTION, deletedFileRetentionDuration>> table property (<<DeltaConfigs.md#fromMetaData, from>> the <<metadata, Metadata>>).

[NOTE]
====
`tombstoneRetentionMillis` is used when:

* `DeltaLog` is requested for <<minFileRetentionTimestamp, minFileRetentionTimestamp>>

* `VacuumCommand` is requested for <<VacuumCommand.md#gc, garbage collecting of a delta table>>
====

== [[updateInternal]] `updateInternal` Internal Method

[source, scala]
----
updateInternal(
  isAsync: Boolean): Snapshot
----

`updateInternal`...FIXME

NOTE: `updateInternal` is used when `DeltaLog` is requested to <<update, update>> (directly or via <<tryUpdate, tryUpdate>>).

== [[invalidateCache]] Invalidating Cached DeltaLog Instance By Path -- `invalidateCache` Utility

[source, scala]
----
invalidateCache(
  spark: SparkSession,
  dataPath: Path): Unit
----

`invalidateCache`...FIXME

NOTE: `invalidateCache` is a public API and does not seem to be used at all.

== [[clearCache]] Removing (Clearing) All Cached DeltaLog Instances -- `clearCache` Utility

[source, scala]
----
clearCache(): Unit
----

`clearCache`...FIXME

NOTE: `clearCache` is a public API and is used exclusively in tests.

== [[upgradeProtocol]] `upgradeProtocol` Method

[source, scala]
----
upgradeProtocol(
  newVersion: Protocol = Protocol()): Unit
----

`upgradeProtocol`...FIXME

NOTE: `upgradeProtocol` seems to be used exclusively in tests.

== [[protocolRead]] `protocolRead` Method

[source, scala]
----
protocolRead(
  protocol: Protocol): Unit
----

`protocolRead`...FIXME

[NOTE]
====
`protocolRead` is used when:

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#checkAndRetry, validate and retry a commit>>

* <<Snapshot.md#, Snapshot>> is created

* `DeltaSource` is requested to <<DeltaSource.md#verifyStreamHygieneAndFilterAddFiles, verifyStreamHygieneAndFilterAddFiles>>
====

== [[isValid]] `isValid` Method

[source, scala]
----
isValid(): Boolean
----

`isValid`...FIXME

NOTE: `isValid` is used when `DeltaLog` utility is used to <<apply, get or create a transaction log for a delta table>>.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.DeltaLog` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.DeltaLog=ALL
```

Refer to [Logging](spark-logging.md).
