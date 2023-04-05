# DeltaLog

`DeltaLog` is a **transaction log** (_change log_) of all the [changes](Action.md) to (the state of) a delta table.

## Creating Instance

`DeltaLog` takes the following to be created:

* <span id="logPath"> Log directory (Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="dataPath"> Data directory (Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="options"> Options (`Map[String, String]`)
* <span id="clock"> `Clock`

`DeltaLog` is created (indirectly via [DeltaLog.apply](#apply) utility) when:

* [DeltaLog.forTable](#forTable) utility is used

## <span id="_delta_log"> _delta_log Metadata Directory

`DeltaLog` uses **_delta_log** metadata directory for the transaction log of a Delta table.

The `_delta_log` directory is in the given [data path](#dataPath) directory (when created using [DeltaLog.forTable](#forTable) utility).

The `_delta_log` directory is resolved (in the [DeltaLog.apply](#apply) utility) using the application-wide Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html).

Once resolved and turned into a qualified path, the `_delta_log` directory is [cached](#deltaLogCache).

## <span id="deltaLogCache"><span id="delta.log.cacheSize"> DeltaLog Cache

```scala
deltaLogCache: Cache[(Path, Map[String, String]), DeltaLog]
```

`DeltaLog` uses Guava's [Cache]({{ guava.api }}/com/google/common/cache/Cache.html) as a cache of `DeltaLog`s by their HDFS-qualified [_delta_log](#_delta_log) directories (with their`fs.`-prefixed file system options).

`deltaLogCache` is part of `DeltaLog` Scala object and so becomes an application-wide cache by design (an object in Scala is available as a single instance).

### Caching DeltaLog Instance

A new instance of `DeltaLog` is added when [DeltaLog.apply](#apply) utility is used and the instance is not available for a path (and file system options).

### Cache Size

The size of the cache is controlled by `delta.log.cacheSize` system property.

### DeltaLog Instance Expiration

`DeltaLog`s expire and are automatically removed from the `deltaLogCache` after 60 minutes (non-configurable) of inactivity. Upon expiration, `deltaLogCache` requests the [Snapshot](SnapshotManagement.md#snapshot) of the `DeltaLog` to [uncache](StateCache.md#uncache).

### Cache Clearance

`deltaLogCache` is invalidated:

* For a delta table using [DeltaLog.invalidateCache](#invalidateCache) utility

* For all delta tables using [DeltaLog.clearCache](#clearCache) utility

## <span id="forTable"> DeltaLog.forTable

```scala
// There are many forTable's
forTable(...): DeltaLog
```

`forTable` is an utility that [creates a DeltaLog](#apply) with [_delta_log](#_delta_log) directory (in the given `dataPath` directory).

### <span id="forTable-demo"> Demo: Creating DeltaLog

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

## <span id="tableExists"> tableExists

```scala
tableExists: Boolean
```

`tableExists` requests the [current Snapshot](SnapshotManagement.md#snapshot) for the [version](Snapshot.md#version) and checks out whether it is `0` or higher.

is used when:

* `DeltaTable` utility is used to [isDeltaTable](DeltaTable.md#isDeltaTable)
* [DeltaUnsupportedOperationsCheck](DeltaUnsupportedOperationsCheck.md) logical check rule is executed
* `DeltaTableV2` is requested to [toBaseRelation](DeltaTableV2.md#toBaseRelation)

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

1. Creates the [LogStore](#store) based on [spark.delta.logStore.class](storage/LogStoreProvider.md#spark.delta.logStore.class) configuration property

1. Initializes the [current snapshot](#currentSnapshot)

1. [Updates state of the delta table](#update) when there is no [metadata checkpoint](checkpoints/Checkpoints.md#lastCheckpoint) (e.g. the version of the [state](#currentSnapshot) is `-1`)

In other words, the version of (the `DeltaLog` of) a delta table is at version `0` at the very minimum.

```scala
assert(deltaLog.snapshot.version >= 0)
```

## <span id="filterFileList"> filterFileList

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
* `SnapshotIterator` is requested to [iterator](delta/SnapshotIterator.md#iterator)
* `TahoeBatchFileIndex` is requested to [matchingFiles](TahoeBatchFileIndex.md#matchingFiles)
* `DeltaDataSource` utility is requested to [verifyAndCreatePartitionFilters](delta/DeltaDataSource.md#verifyAndCreatePartitionFilters)

## FileFormats

`DeltaLog` defines two `FileFormat`s ([Spark SQL]({{ book.spark_sql }}/datasources/FileFormat)):

* <span id="CHECKPOINT_FILE_FORMAT"> `ParquetFileFormat` for indices of delta files

* <span id="COMMIT_FILE_FORMAT"> `JsonFileFormat` for indices of checkpoint files

These `FileFormat`s are used to create [DeltaLogFileIndex](DeltaLogFileIndex.md)es for [Snapshots](Snapshot.md#files) that in turn used them for [stateReconstruction](Snapshot.md#stateReconstruction).

## <span id="store"> LogStore

`DeltaLog` uses a [LogStore](storage/LogStore.md) for...FIXME

## <span id="withNewTransaction"> Executing Single-Threaded Operation in New Transaction

```scala
withNewTransaction[T](
  thunk: OptimisticTransaction => T): T
```

`withNewTransaction` [starts a new transaction](#startTransaction) (that is [active](OptimisticTransaction.md#setActive) for the whole thread) and executes the given `thunk` block.

In the end, `withNewTransaction` makes the transaction [no longer active](OptimisticTransaction.md#clearActive).

`withNewTransaction` is used when:

* [DeleteCommand](commands/delete/DeleteCommand.md), [MergeIntoCommand](commands/merge/MergeIntoCommand.md), [UpdateCommand](commands/update/UpdateCommand.md), and [WriteIntoDelta](commands/WriteIntoDelta.md) commands are executed

* `DeltaSink` is requested to [add a streaming micro-batch](delta/DeltaSink.md#addBatch)

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
* `DeltaSink` is requested to [addBatch](delta/DeltaSink.md#addBatch) (with `Complete` output mode)

## <span id="metadata"> metadata

```scala
metadata: Metadata
```

`metadata` is part of the [Checkpoints](checkpoints/Checkpoints.md#metadata) abstraction.

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

* `DeltaLog` is [created](#creating-instance) (with no [checkpoint](checkpoints/Checkpoints.md#lastCheckpoint) created), and requested to [startTransaction](#startTransaction) and [withNewTransaction](#withNewTransaction)

* `OptimisticTransactionImpl` is requested to [doCommit](OptimisticTransactionImpl.md#doCommit) and [checkAndRetry](OptimisticTransactionImpl.md#checkAndRetry)

* `ConvertToDeltaCommand` is requested to [run](commands/convert/ConvertToDeltaCommand.md#run) and [streamWrite](commands/convert/ConvertToDeltaCommand.md#streamWrite)

* `VacuumCommand` utility is used to [gc](commands/vacuum/VacuumCommand.md#gc)

* `TahoeLogFileIndex` is requested for the [(historical or latest) snapshot](TahoeLogFileIndex.md#getSnapshot)

* `DeltaDataSource` is requested for a [relation](delta/DeltaDataSource.md#RelationProvider-createRelation)

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

* `Checkpoints` is requested to [checkpoint](checkpoints/Checkpoints.md#checkpoint)

* `DeltaLog` is requested for the [metadata](#metadata), to [upgradeProtocol](#upgradeProtocol), [getSnapshotAt](#getSnapshotAt), [createRelation](#createRelation)

* `OptimisticTransactionImpl` is requested to [getNextAttemptVersion](OptimisticTransactionImpl.md#getNextAttemptVersion)

* [DeleteCommand](commands/delete/DeleteCommand.md), [DeltaGenerateCommand](commands/generate/DeltaGenerateCommand.md), [DescribeDeltaDetailCommand](commands/describe-detail/DescribeDeltaDetailCommand.md), [UpdateCommand](commands/update/UpdateCommand.md) commands are executed

* [GenerateSymlinkManifest](GenerateSymlinkManifest.md) is executed

* `DeltaCommand` is requested to [buildBaseRelation](commands/DeltaCommand.md#buildBaseRelation)

* `TahoeFileIndex` is requested for the [table version](TahoeFileIndex.md#tableVersion), [partitionSchema](TahoeFileIndex.md#partitionSchema)

* `TahoeLogFileIndex` is requested for the [table size](TahoeLogFileIndex.md#sizeInBytes)

* `DeltaDataSource` is requested for the [schema of the streaming delta source](delta/DeltaDataSource.md#sourceSchema)

* [DeltaSource](delta/DeltaSource.md) is created and requested for the [getStartingOffset](delta/DeltaSource.md#getStartingOffset), [getBatch](delta/DeltaSource.md#getBatch)

## <span id="currentSnapshot"> Current State Snapshot

```scala
currentSnapshot: Snapshot
```

`currentSnapshot` is a [Snapshot](Snapshot.md) based on the [metadata checkpoint](checkpoints/Checkpoints.md#lastCheckpoint) if available or a new `Snapshot` instance (with version being `-1`).

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

With non-empty `cdcOptions`, `createRelation` [creates a CDC-aware relation](change-data-feed/CDCReader.md#getCDCRelation) (that represents data change between two snapshots of the table).

!!! note "When `cdcOptions` is non-empty"
    `cdcOptions` is empty by default and can only be specified when `DeltaTableV2` is [created](DeltaTableV2.md#cdcOptions).

`createRelation` creates a [TahoeLogFileIndex](TahoeLogFileIndex.md) for the [data path](#dataPath), the given `partitionFilters` and a version (if defined).

`createRelation`...FIXME

In the end, `createRelation` creates a `HadoopFsRelation` for the `TahoeLogFileIndex` and...FIXME. The `HadoopFsRelation` is also an [InsertableRelation](#createRelation-InsertableRelation).

`createRelation` is used when:

* `DeltaTableV2` is requested to [toBaseRelation](DeltaTableV2.md#toBaseRelation)
* `WriteIntoDeltaBuilder` is requested to [buildForV1Write](WriteIntoDeltaBuilder.md#buildForV1Write)
* `DeltaDataSource` is requested for a [writable relation](delta/DeltaDataSource.md#CreatableRelationProvider-createRelation)

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

* `DeltaSource` is requested for the [snapshot of a delta table at a given version](delta/DeltaSource.md#getSnapshotAt)

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

`getChanges` gives all the [Action](Action.md)s (_changes_) per delta log file for the given `startVersion` (inclusive) of a delta table and later.

```scala
val dataPath = "/tmp/delta/users"
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)
assert(deltaLog.isInstanceOf[DeltaLog])
val changesPerVersion = deltaLog.getChanges(startVersion = 0)
```

---

Internally, `getChanges` requests the [LogStore](#store) for [files](storage/LogStore.md#listFrom) that are lexicographically greater or equal to the [delta log file](FileNames.md#deltaFile) for the given `startVersion` (in the [logPath](#logPath)) and leaves only [delta log files](FileNames.md#isDeltaFile) (e.g. files with numbers only as file name and `.json` file extension).

For every delta file, `getChanges` requests the [LogStore](#store) to [read the JSON content](storage/LogStore.md#read) (every line is an [action](Action.md)), and then [deserializes it to an action](Action.md#fromJson).

## <span id="createDataFrame"> Creating DataFrame (From AddFiles)

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

`createDataFrame` creates a new [TahoeBatchFileIndex](TahoeBatchFileIndex.md) (for the action type, and the given [AddFile](AddFile.md)s, this `DeltaLog`, and [Snapshot](Snapshot.md)).

`createDataFrame` creates a `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) with the `TahoeBatchFileIndex` and the other properties based on the given `Snapshot` (and the associated [Metadata](Snapshot.md#metadata)).

In the end, `createDataFrame` creates a `DataFrame` with (a logical query plan with) a `LogicalRelation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation/)) over the `HadoopFsRelation`.

`createDataFrame` is used when:

* [AlterTableAddConstraintDeltaCommand](commands/alter/AlterTableAddConstraintDeltaCommand.md) is executed
* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed (and requested to [buildTargetPlanWithFiles](commands/merge/MergeIntoCommand.md#buildTargetPlanWithFiles))
* `OptimizeExecutor` is requested to [runOptimizeBinJob](commands/optimize/OptimizeExecutor.md#runOptimizeBinJob)
* `DeltaSourceBase` is requested to [createDataFrame](delta/DeltaSourceBase.md#createDataFrame)
* `StatisticsCollection` utility is used to [recompute](StatisticsCollection.md#recompute)

### <span id="createDataFrame-demo"> Demo: DeltaLog.createDataFrame

Create a delta table with some data to work with. We need data files for this demo.

=== "Scala"

    ```scala
    sql("DROP TABLE IF EXISTS delta_demo")
    spark.range(5).write.format("delta").saveAsTable("delta_demo")
    ```

Review the data (parquet) files created. These are our [AddFile](AddFile.md)s.

```console
$ tree spark-warehouse/delta_demo/
spark-warehouse/delta_demo/
├── _delta_log
│   └── 00000000000000000000.json
├── part-00000-993a2fad-3643-48f5-b2be-d1b9036fb29d-c000.snappy.parquet
├── part-00003-74b48672-e869-47fc-818b-e422062c1427-c000.snappy.parquet
├── part-00006-91497579-5f25-42e6-82c9-1dc8416fe987-c000.snappy.parquet
├── part-00009-6f3e75fd-828d-4e1b-9d38-7aa65f928a9e-c000.snappy.parquet
├── part-00012-309fbcfe-4d34-45f7-b414-034f676480c6-c000.snappy.parquet
└── part-00015-5d72e873-e4df-493a-8bcf-2a3af9dfd636-c000.snappy.parquet

1 directory, 7 files
```

Let's load the delta table.

=== "Scala"

    ```scala
    // FIXME I feel there should be a better way to access a DeltaLog
    val tableName = "delta_demo"
    val tableId = spark.sessionState.sqlParser.parseTableIdentifier(tableName)
    val tbl = spark.sessionState.catalog.getTableMetadata(tableId)
    import org.apache.spark.sql.delta.catalog.DeltaTableV2
    import org.apache.hadoop.fs.Path
    val table: DeltaTableV2 = DeltaTableV2(
      spark, new Path(tbl.location), Some(tbl), Some(tableName))
    ```

We've finally got the [DeltaTableV2](DeltaTableV2.md) so we can proceed.

=== "Scala"

    ```scala
    val txn = table.deltaLog.startTransaction()
    // FIXME Create a fake collection of AddFiles
    // We could avoid transactions and the other extra steps
    // that blur what is demo'ed
    import org.apache.spark.sql.delta.actions.AddFile
    val fakeAddFile = AddFile(
      path = "/a/fake/file/path",
      partitionValues = Map.empty,
      size = 10,
      modificationTime = 0,
      dataChange = false)
    // val addFiles: Seq[AddFile] = txn.filterFiles()
    val addFiles = Seq(fakeAddFile)
    val actionType = Some("createDataFrame Demo")
    val df = txn.snapshot.deltaLog.createDataFrame(
      txn.snapshot,
      addFiles,
      actionTypeOpt = actionType)
    ```

Up to this point, all should work just fine (since no addfiles were checked whether they are available or not).

Let's trigger an action to see what happens when Spark SQL (with Delta Lake) decides to access the data.

```scala
df.show
```

The above `show` action will surely lead to an exception (since the fake file does not really exist).

```text
scala> df.show
22/07/13 14:00:39 ERROR Executor: Exception in task 0.0 in stage 19.0 (TID 179)
java.io.FileNotFoundException:
File /a/fake/file/path does not exist

It is possible the underlying files have been updated. You can explicitly invalidate
the cache in Spark by running 'REFRESH TABLE tableName' command in SQL or by
recreating the Dataset/DataFrame involved.

	at org.apache.spark.sql.errors.QueryExecutionErrors$.readCurrentFileNotFoundError(QueryExecutionErrors.scala:506)
	at org.apache.spark.sql.execution.datasources.FileScanRDD$$anon$1.org$apache$spark$sql$execution$datasources$FileScanRDD$$anon$$readCurrentFile(FileScanRDD.scala:130)
	at org.apache.spark.sql.execution.datasources.FileScanRDD$$anon$1.nextIterator(FileScanRDD.scala:187)
	at org.apache.spark.sql.execution.datasources.FileScanRDD$$anon$1.hasNext(FileScanRDD.scala:104)
	at org.apache.spark.sql.execution.FileSourceScanExec$$anon$1.hasNext(DataSourceScanExec.scala:522)
	at org.apache.spark.sql.catalyst.expressions.GeneratedClass$GeneratedIteratorForCodegenStage1.columnartorow_nextBatch_0$(Unknown Source)
	at org.apache.spark.sql.catalyst.expressions.GeneratedClass$GeneratedIteratorForCodegenStage1.processNext(Unknown Source)
	at org.apache.spark.sql.execution.BufferedRowIterator.hasNext(BufferedRowIterator.java:43)
	at org.apache.spark.sql.execution.WholeStageCodegenExec$$anon$1.hasNext(WholeStageCodegenExec.scala:759)
	at org.apache.spark.sql.execution.SparkPlan.$anonfun$getByteArrayRdd$1(SparkPlan.scala:349)
	at org.apache.spark.rdd.RDD.$anonfun$mapPartitionsInternal$2(RDD.scala:898)
	at org.apache.spark.rdd.RDD.$anonfun$mapPartitionsInternal$2$adapted(RDD.scala:898)
	at org.apache.spark.rdd.MapPartitionsRDD.compute(MapPartitionsRDD.scala:52)
	at org.apache.spark.rdd.RDD.computeOrReadCheckpoint(RDD.scala:373)
	at org.apache.spark.rdd.RDD.iterator(RDD.scala:337)
	at org.apache.spark.scheduler.ResultTask.runTask(ResultTask.scala:90)
	at org.apache.spark.scheduler.Task.run(Task.scala:131)
	at org.apache.spark.executor.Executor$TaskRunner.$anonfun$run$3(Executor.scala:506)
	at org.apache.spark.util.Utils$.tryWithSafeFinally(Utils.scala:1462)
	at org.apache.spark.executor.Executor$TaskRunner.run(Executor.scala:509)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
	at java.base/java.lang.Thread.run(Thread.java:829)
22/07/13 14:00:39 WARN TaskSetManager: Lost task 0.0 in stage 19.0 (TID 179) (localhost executor driver): java.io.FileNotFoundException:
File /a/fake/file/path does not exist
```

## <span id="minFileRetentionTimestamp"> minFileRetentionTimestamp

```scala
minFileRetentionTimestamp: Long
```

`minFileRetentionTimestamp` is the timestamp that is [tombstoneRetentionMillis](#tombstoneRetentionMillis) before the current time (per the given [Clock](#clock)).

`minFileRetentionTimestamp` is used when:

* `DeltaLog` is requested for the [currentSnapshot](#currentSnapshot), to [updateInternal](#updateInternal), and to [getSnapshotAt](#getSnapshotAt)

* `VacuumCommand` is requested for [garbage collecting of a delta table](commands/vacuum/VacuumCommand.md#gc)

## <span id="tombstoneRetentionMillis"> tombstoneRetentionMillis

```scala
tombstoneRetentionMillis: Long
```

`tombstoneRetentionMillis` gives the value of [deletedFileRetentionDuration](DeltaConfigs.md#TOMBSTONE_RETENTION) table property ([from](DeltaConfigs.md#fromMetaData) the [Metadata](#metadata)).

`tombstoneRetentionMillis` is used when:

* `DeltaLog` is requested for [minFileRetentionTimestamp](#minFileRetentionTimestamp)

* `VacuumCommand` is requested for [garbage collecting of a delta table](commands/vacuum/VacuumCommand.md#gc)

## <span id="updateInternal"> updateInternal

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

* `DeltaSource` is requested to [verifyStreamHygieneAndFilterAddFiles](delta/DeltaSource.md#verifyStreamHygieneAndFilterAddFiles)

## <span id="upgradeProtocol"> upgradeProtocol

```scala
upgradeProtocol(
  newVersion: Protocol = Protocol()): Unit
```

`upgradeProtocol`...FIXME

`upgradeProtocol` is used when:

* `DeltaTable` is requested to [upgradeTableProtocol](DeltaTable.md#upgradeTableProtocol)

## LogStoreProvider

`DeltaLog` is a [LogStoreProvider](storage/LogStoreProvider.md).

## <span id="apply"> Looking Up Cached Or Creating New DeltaLog Instance

```scala
apply(
  spark: SparkSession,
  rawPath: Path,
  clock: Clock = new SystemClock): DeltaLog // (1)!
apply(
  spark: SparkSession,
  rawPath: Path,
  options: Map[String, String],
  clock: Clock): DeltaLog
```

1. Uses empty `options`

!!! note
    `rawPath` is a Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) to the [_delta_log](#_delta_log) directory at the root of the data of a delta table.

`apply` creates a Hadoop `Configuration` (perhaps with `fs.`-prefixed options when [spark.databricks.delta.loadFileSystemConfigsFromDataFrameOptions](configuration-properties/DeltaSQLConf.md#loadFileSystemConfigsFromDataFrameOptions) configuration property is enabled).

`apply` resolves the raw path to be HDFS-qualified (using the given Hadoop `Path` to get a Hadoop `FileSystem`).

In the end, `apply` looks up a `DeltaLog` for the HDFS-qualified path (with the file system options) in the [deltaLogCache](#deltaLogCache) or creates (and caches) a new [DeltaLog](#creating-instance).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.DeltaLog` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.DeltaLog=ALL
```

Refer to [Logging](logging.md).
