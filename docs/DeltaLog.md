# DeltaLog

`DeltaLog` is a **transaction log** (_change log_) of [changes](Action.md) to the state of a Delta table (in the given [data directory](#dataPath)).

## Creating Instance

`DeltaLog` takes the following to be created:

* <span id="logPath"> Log directory (Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="dataPath"> Data directory (Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="clock"> `Clock`

`DeltaLog` is created (indirectly via [DeltaLog.apply](#apply) utility) when:

* [DeltaLog.forTable](#forTable) utility is used

## <span id="_delta_log"> _delta_log Metadata Directory

`DeltaLog` uses **_delta_log** metadata directory for the transaction log of a Delta table.

The `_delta_log` directory is in the given [data path](#dataPath) directory (when created using [DeltaLog.forTable](#forTable) utility).

The `_delta_log` directory is resolved (in the [DeltaLog.apply](#apply) utility) using the application-wide Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html).

Once resolved and turned into a qualified path, the `_delta_log` directory is [cached](#deltaLogCache).

## <span id="forTable"> DeltaLog.forTable

```scala
forTable(
  spark: SparkSession,
  table: CatalogTable): DeltaLog
forTable(
  spark: SparkSession,
  table: CatalogTable,
  clock: Clock): DeltaLog
forTable(
  spark: SparkSession,
  deltaTable: DeltaTableIdentifier): DeltaLog
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
forTable(
  spark: SparkSession,
  tableName: TableIdentifier): DeltaLog
forTable(
  spark: SparkSession,
  tableName: TableIdentifier,
  clock: Clock): DeltaLog
```

`forTable` creates a [DeltaLog](#apply) with [_delta_log](#_delta_log) directory (in the given `dataPath` directory).

`forTable` is used when:

* [AlterTableSetLocationDeltaCommand](commands/alter/AlterTableSetLocationDeltaCommand.md), [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md), [VacuumTableCommand](commands/vacuum/VacuumTableCommand.md), [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md), [DeltaGenerateCommand](commands/generate/DeltaGenerateCommand.md), [DescribeDeltaDetailCommand](commands/describe-detail/DescribeDeltaDetailCommand.md), [DescribeDeltaHistoryCommand](commands/describe-history/DescribeDeltaHistoryCommand.md) commands are executed

* `DeltaDataSource` is requested for the [source schema](DeltaDataSource.md#sourceSchema), a [source](DeltaDataSource.md#createSource), and a [relation](DeltaDataSource.md#createRelation)

* [DeltaTable.isDeltaTable](DeltaTable.md#isDeltaTable) utility is used

* [DeltaTableUtils.combineWithCatalogMetadata](DeltaTableUtils.md#combineWithCatalogMetadata) utility is used

* `DeltaTableIdentifier` is requested to [getDeltaLog](DeltaTableIdentifier.md#getDeltaLog)

* `DeltaCatalog` is requested to [createDeltaTable](DeltaCatalog.md#createDeltaTable)

* `DeltaTableV2` is requested for the [DeltaLog](DeltaTableV2.md#deltaLog)

* [DeltaSink](DeltaSink.md#deltaLog) is created

### <span id="apply"> Looking Up Or Creating DeltaLog Instance

```scala
apply(
  spark: SparkSession,
  rawPath: Path,
  clock: Clock = new SystemClock): DeltaLog
```

!!! note
    `rawPath` is a Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) to the [_delta_log](#_delta_log) directory at the root of the data of a delta table.

`apply`...FIXME

## <span id="tableExists"> tableExists

```scala
tableExists: Boolean
```

`tableExists` requests the [current Snapshot](SnapshotManagement.md#snapshot) for the [version](Snapshot.md#version) and checks out whether it is `0` or higher.

is used when:

* `DeltaTable` utility is used to [isDeltaTable](DeltaTable.md#isDeltaTable)
* [DeltaUnsupportedOperationsCheck](DeltaUnsupportedOperationsCheck.md) logical check rule is executed
* `DeltaTableV2` is requested to [toBaseRelation](DeltaTableV2.md#toBaseRelation)

## Demo: Creating DeltaLog

```scala
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

val dataPath = "/tmp/delta/t1"
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)

import org.apache.hadoop.fs.Path
val expected = new Path(s"file:$dataPath/_delta_log/_last_checkpoint")
assert(deltaLog.LAST_CHECKPOINT == expected)
```

## Accessing Current Version

A common idiom (if not the only way) to know the current version of the delta table is to request the `DeltaLog` for the [current state (snapshot)](#snapshot) and then for the [version](Snapshot.md#version).

```text
import org.apache.spark.sql.delta.DeltaLog
assert(deltaLog.isInstanceOf[DeltaLog])

val deltaVersion = deltaLog.snapshot.version
scala> println(deltaVersion)
5
```

## Initialization

When created, `DeltaLog` does the following:

1. Creates the [LogStore](#store) based on [spark.delta.logStore.class](LogStoreProvider.md#spark.delta.logStore.class) configuration property

1. Initializes the [current snapshot](#currentSnapshot)

1. [Updates state of the delta table](#update) when there is no [metadata checkpoint](Checkpoints.md#lastCheckpoint) (e.g. the version of the [state](#currentSnapshot) is `-1`)

In other words, the version of (the `DeltaLog` of) a delta table is at version `0` at the very minimum.

```scala
assert(deltaLog.snapshot.version >= 0)
```

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

## FileFormats

`DeltaLog` defines two `FileFormat`s ([Spark SQL]({{ book.spark_sql }}/datasources/FileFormat)):

* <span id="CHECKPOINT_FILE_FORMAT"> `ParquetFileFormat` for indices of delta files

* <span id="COMMIT_FILE_FORMAT"> `JsonFileFormat` for indices of checkpoint files

These `FileFormat`s are used to create [DeltaLogFileIndex](DeltaLogFileIndex.md)es for [Snapshots](Snapshot.md#files) that in turn used them for [stateReconstruction](Snapshot.md#stateReconstruction).

## <span id="store"> LogStore

`DeltaLog` uses a [LogStore](LogStore.md) for...FIXME

## <span id="deltaLogCache"> Transaction Logs (DeltaLogs) per Fully-Qualified Path

```scala
deltaLogCache: Cache[Path, DeltaLog]
```

`deltaLogCache` is part of `DeltaLog` Scala object which makes it an application-wide cache "for free". Once used, `deltaLogCache` will only be one until the application that uses it stops.

`deltaLogCache` is a registry of `DeltaLogs` by their fully-qualified [_delta_log](#_delta_log) directories. A new instance of `DeltaLog` is added when [DeltaLog.apply](#apply) utility is used and the instance hasn't been created before for a path.

`deltaLogCache` is invalidated:

* For a delta table using [DeltaLog.invalidateCache](#invalidateCache) utility

* For all delta tables using [DeltaLog.clearCache](#clearCache) utility

## <span id="withNewTransaction"> Executing Single-Threaded Operation in New Transaction

```scala
withNewTransaction[T](
  thunk: OptimisticTransaction => T): T
```

`withNewTransaction` [starts a new transaction](#startTransaction) (that is [active](OptimisticTransaction.md#setActive) for the whole thread) and executes the given `thunk` block.

In the end, `withNewTransaction` makes the transaction [no longer active](OptimisticTransaction.md#clearActive).

`withNewTransaction` is used when:

* [DeleteCommand](commands/delete/DeleteCommand.md), [MergeIntoCommand](commands/merge/MergeIntoCommand.md), [UpdateCommand](commands/update/UpdateCommand.md), and [WriteIntoDelta](commands/WriteIntoDelta.md) commands are executed

* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)

## <span id="startTransaction"> Starting New Transaction

```scala
startTransaction(): OptimisticTransaction
```

`startTransaction` [updates](#update) and creates a new [OptimisticTransaction](OptimisticTransaction.md) (for this `DeltaLog`).

!!! NOTE
    `startTransaction` is a "subset" of [withNewTransaction](#withNewTransaction).

`startTransaction` is used when:

* `DeltaLog` is requested to [upgradeProtocol](#upgradeProtocol)

* `AlterDeltaTableCommand` is requested to [startTransaction](commands/alter/AlterDeltaTableCommand.md#startTransaction)

* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) and [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md) are executed

## <span id="assertRemovable"> Throwing UnsupportedOperationException for Append-Only Tables

```scala
assertRemovable(): Unit
```

`assertRemovable` throws an `UnsupportedOperationException` for the [appendOnly](DeltaConfigs.md#IS_APPEND_ONLY) table property ([in](DeltaConfigs.md#fromMetaData) the [Metadata](#metadata)) enabled (`true`):

```text
This table is configured to only allow appends. If you would like to permit updates or deletes, use 'ALTER TABLE <table_name> SET TBLPROPERTIES (appendOnly=false)'.
```

`assertRemovable` is used when:

* `OptimisticTransactionImpl` is requested to [prepareCommit](OptimisticTransactionImpl.md#prepareCommit)
* [DeleteCommand](commands/delete/DeleteCommand.md), [UpdateCommand](commands/update/UpdateCommand.md), [WriteIntoDelta](commands/WriteIntoDelta.md) (with `Overwrite` mode) are executed
* `DeltaSink` is requested to [addBatch](DeltaSink.md#addBatch) (with `Complete` output mode)

## <span id="metadata"> metadata

```scala
metadata: Metadata
```

`metadata` is part of the [Checkpoints](Checkpoints.md#metadata) abstraction.

`metadata` requests the [current Snapshot](#snapshot) for the [metadata](Snapshot.md#metadata) or creates a new [one](Metadata.md) (if the [current Snapshot](snapshot) is not initialized).

## <span id="update"> update

```scala
update(
  stalenessAcceptable: Boolean = false): Snapshot
```

`update` branches off based on a combination of flags: the given `stalenessAcceptable` and [isSnapshotStale](#isSnapshotStale).

For the `stalenessAcceptable` not acceptable (default) and the [snapshot not stale](#isSnapshotStale), `update` simply acquires the [deltaLogLock](#deltaLogLock) lock and [updateInternal](#updateInternal) (with `isAsync` flag off).

For all other cases, `update`...FIXME

`update` is used when:

* `DeltaHistoryManager` is requested to [getHistory](DeltaHistoryManager.md#getHistory), [getActiveCommitAtTime](DeltaHistoryManager.md#getActiveCommitAtTime), and [checkVersionExists](DeltaHistoryManager.md#checkVersionExists)

* `DeltaLog` is [created](#creating-instance) (with no [checkpoint](Checkpoints.md#lastCheckpoint) created), and requested to [startTransaction](#startTransaction) and [withNewTransaction](#withNewTransaction)

* `OptimisticTransactionImpl` is requested to [doCommit](OptimisticTransactionImpl.md#doCommit) and [checkAndRetry](OptimisticTransactionImpl.md#checkAndRetry)

* `ConvertToDeltaCommand` is requested to [run](commands/convert/ConvertToDeltaCommand.md#run) and [streamWrite](commands/convert/ConvertToDeltaCommand.md#streamWrite)

* `VacuumCommand` utility is used to [gc](commands/vacuum/VacuumCommand.md#gc)

* `TahoeLogFileIndex` is requested for the [(historical or latest) snapshot](TahoeLogFileIndex.md#getSnapshot)

* `DeltaDataSource` is requested for a [relation](DeltaDataSource.md#RelationProvider-createRelation)

### <span id="tryUpdate"> tryUpdate

```scala
tryUpdate(
  isAsync: Boolean = false): Snapshot
```

`tryUpdate`...FIXME

## <span id="snapshot"> Snapshot

```scala
snapshot: Snapshot
```

`snapshot` returns the [current snapshot](#currentSnapshot).

`snapshot` is used when:

* [OptimisticTransaction](OptimisticTransaction.md) is created

* `Checkpoints` is requested to [checkpoint](Checkpoints.md#checkpoint)

* `DeltaLog` is requested for the [metadata](#metadata), to [upgradeProtocol](#upgradeProtocol), [getSnapshotAt](#getSnapshotAt), [createRelation](#createRelation)

* `OptimisticTransactionImpl` is requested to [getNextAttemptVersion](OptimisticTransactionImpl.md#getNextAttemptVersion)

* [DeleteCommand](commands/delete/DeleteCommand.md), [DeltaGenerateCommand](commands/generate/DeltaGenerateCommand.md), [DescribeDeltaDetailCommand](commands/describe-detail/DescribeDeltaDetailCommand.md), [UpdateCommand](commands/update/UpdateCommand.md) commands are executed

* [GenerateSymlinkManifest](GenerateSymlinkManifest.md) is executed

* `DeltaCommand` is requested to [buildBaseRelation](commands/DeltaCommand.md#buildBaseRelation)

* `TahoeFileIndex` is requested for the [table version](TahoeFileIndex.md#tableVersion), [partitionSchema](TahoeFileIndex.md#partitionSchema)

* `TahoeLogFileIndex` is requested for the [table size](TahoeLogFileIndex.md#sizeInBytes)

* `DeltaDataSource` is requested for the [schema of the streaming delta source](DeltaDataSource.md#sourceSchema)

* [DeltaSource](DeltaSource.md) is created and requested for the [getStartingOffset](DeltaSource.md#getStartingOffset), [getBatch](DeltaSource.md#getBatch)

## <span id="currentSnapshot"> Current State Snapshot

```scala
currentSnapshot: Snapshot
```

`currentSnapshot` is a [Snapshot](Snapshot.md) based on the [metadata checkpoint](Checkpoints.md#lastCheckpoint) if available or a new `Snapshot` instance (with version being `-1`).

!!! NOTE
    For a new `Snapshot` instance (with version being `-1`) `DeltaLog` immediately [updates the state](#update).

Internally, `currentSnapshot`...FIXME

`currentSnapshot` is available using [snapshot](#snapshot) method.

`currentSnapshot` is used when:

* `DeltaLog` is requested to [updateInternal](#updateInternal), [update](#update) and [tryUpdate](#tryUpdate)

## <span id="createRelation"> Creating Insertable HadoopFsRelation For Batch Queries

```scala
createRelation(
  partitionFilters: Seq[Expression] = Nil,
  snapshotToUseOpt: Option[Snapshot] = None,
  isTimeTravelQuery: Boolean = false,
  cdcOptions: CaseInsensitiveStringMap = CaseInsensitiveStringMap.empty): BaseRelation
```

`createRelation`...FIXME

`createRelation` creates a [TahoeLogFileIndex](TahoeLogFileIndex.md) for the [data path](#dataPath), the given `partitionFilters` and a version (if defined).

`createRelation`...FIXME

In the end, `createRelation` creates a `HadoopFsRelation` for the `TahoeLogFileIndex` and...FIXME. The `HadoopFsRelation` is also an [InsertableRelation](#createRelation-InsertableRelation).

`createRelation` is used when:

* `DeltaTableV2` is requested to [toBaseRelation](DeltaTableV2.md#toBaseRelation)
* `WriteIntoDeltaBuilder` is requested to [buildForV1Write](WriteIntoDeltaBuilder.md#buildForV1Write)
* `DeltaDataSource` is requested for a [writable relation](DeltaDataSource.md#CreatableRelationProvider-createRelation)

## <span id="createRelation-InsertableRelation"><span id="createRelation-InsertableRelation-insert"> insert

```scala
insert(
  data: DataFrame,
  overwrite: Boolean): Unit
```

`insert`...FIXME

`insert` is part of the `InsertableRelation` ([Spark SQL]({{ book.spark_sql }}/InsertableRelation)) abstraction.

## <span id="getSnapshotAt"> Retrieving State Of Delta Table At Given Version

```scala
getSnapshotAt(
  version: Long,
  commitTimestamp: Option[Long] = None,
  lastCheckpointHint: Option[CheckpointInstance] = None): Snapshot
```

`getSnapshotAt`...FIXME

`getSnapshotAt` is used when:

* `DeltaLog` is requested for a [relation](#createRelation), and to [updateInternal](#updateInternal)

* `DeltaSource` is requested for the [snapshot of a delta table at a given version](DeltaSource.md#getSnapshotAt)

* `TahoeLogFileIndex` is requested for [historicalSnapshotOpt](TahoeLogFileIndex.md#historicalSnapshotOpt)

## <span id="checkpointInterval"> Checkpoint Interval

```scala
checkpointInterval: Int
```

`checkpointInterval` is the current value of [checkpointInterval](DeltaConfigs.md#CHECKPOINT_INTERVAL) table property ([from](DeltaConfigs.md#fromMetaData) the [Metadata](#metadata)).

`checkpointInterval` is used when:

* `OptimisticTransactionImpl` is requested to [postCommit](OptimisticTransactionImpl.md#postCommit)

## <span id="getChanges"> Changes (Actions) Of Delta Version And Later

```scala
getChanges(
  startVersion: Long): Iterator[(Long, Seq[Action])]
```

`getChanges` gives all [action](Action.md)s (_changes_) per delta log file for the given `startVersion` of a delta table and later.

```scala
val dataPath = "/tmp/delta/users"
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)
assert(deltaLog.isInstanceOf[DeltaLog])
val changesPerVersion = deltaLog.getChanges(startVersion = 0)
```

Internally, `getChanges` requests the [LogStore](#store) for [files](LogStore.md#listFrom) that are lexicographically greater or equal to the [delta log file](FileNames.md#deltaFile) for the given `startVersion` (in the [logPath](#logPath)) and leaves only [delta log files](FileNames.md#isDeltaFile) (e.g. files with numbers only as file name and `.json` file extension).

For every delta file, `getChanges` requests the [LogStore](#store) to [read the JSON content](LogStore.md#read) (every line is an [action](Action.md)), and then [deserializes it to an action](Action.md#fromJson).

`getChanges` is used when:

* `DeltaSource` is requested for the [indexed file additions (FileAdd actions)](DeltaSource.md#getChanges)

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

`createDataFrame` creates a `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) with the `TahoeBatchFileIndex` and the other properties based on the given `Snapshot` (and the associated [Metadata](Snapshot.md#metadata)).

In the end, `createDataFrame` creates a `DataFrame` with a logical query plan with a `LogicalRelation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation/)) over the `HadoopFsRelation`.

`createDataFrame` is used when:

* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed
* `DeltaSource` is requested for a [DataFrame for data between start and end offsets](DeltaSource.md#getBatch)

## <span id="minFileRetentionTimestamp"> `minFileRetentionTimestamp` Method

```scala
minFileRetentionTimestamp: Long
```

`minFileRetentionTimestamp` is the timestamp that is [tombstoneRetentionMillis](#tombstoneRetentionMillis) before the current time (per the given [Clock](#clock)).

`minFileRetentionTimestamp` is used when:

* `DeltaLog` is requested for the [currentSnapshot](#currentSnapshot), to [updateInternal](#updateInternal), and to [getSnapshotAt](#getSnapshotAt)

* `VacuumCommand` is requested for [garbage collecting of a delta table](commands/vacuum/VacuumCommand.md#gc)

## <span id="tombstoneRetentionMillis"> `tombstoneRetentionMillis` Method

```scala
tombstoneRetentionMillis: Long
```

`tombstoneRetentionMillis` gives the value of [deletedFileRetentionDuration](DeltaConfigs.md#TOMBSTONE_RETENTION) table property ([from](DeltaConfigs.md#fromMetaData) the [Metadata](#metadata)).

`tombstoneRetentionMillis` is used when:

* `DeltaLog` is requested for [minFileRetentionTimestamp](#minFileRetentionTimestamp)

* `VacuumCommand` is requested for [garbage collecting of a delta table](commands/vacuum/VacuumCommand.md#gc)

## <span id="updateInternal"> `updateInternal` Internal Method

```scala
updateInternal(
  isAsync: Boolean): Snapshot
```

`updateInternal`...FIXME

`updateInternal` is used when:

* `DeltaLog` is requested to [update](#update) (directly or via [tryUpdate](#tryUpdate))

## <span id="invalidateCache"> Invalidating Cached DeltaLog Instance By Path

```scala
invalidateCache(
  spark: SparkSession,
  dataPath: Path): Unit
```

`invalidateCache`...FIXME

`invalidateCache` is a public API and does not seem to be used at all.

## <span id="protocolRead"> protocolRead

```scala
protocolRead(
  protocol: Protocol): Unit
```

`protocolRead`...FIXME

`protocolRead` is used when:

* `OptimisticTransactionImpl` is requested to [validate and retry a commit](OptimisticTransactionImpl.md#checkAndRetry)

* [Snapshot](Snapshot.md) is created

* `DeltaSource` is requested to [verifyStreamHygieneAndFilterAddFiles](DeltaSource.md#verifyStreamHygieneAndFilterAddFiles)

## <span id="upgradeProtocol"> upgradeProtocol

```scala
upgradeProtocol(
  newVersion: Protocol = Protocol()): Unit
```

`upgradeProtocol`...FIXME

`upgradeProtocol` is used when:

* `DeltaTable` is requested to [upgradeTableProtocol](DeltaTable.md#upgradeTableProtocol)

## LogStoreProvider

`DeltaLog` is a [LogStoreProvider](LogStoreProvider.md).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.DeltaLog` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.DeltaLog=ALL
```

Refer to [Logging](spark-logging.md).
