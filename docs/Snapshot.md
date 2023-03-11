# Snapshot

`Snapshot` is an immutable snapshot of the [state](#state) of a delta table (in the [deltaLog](#deltaLog)) at the given [version](#version).

`Snapshot` uses [aggregation expressions](#aggregationsToComputeState) while [computing state](#computedState) (as [State](State.md)).

`Snapshot` [loads the actions](#loadActions) (per the [DeltaLogFileIndices](#fileIndices)) and builds a `DataFrame`.

## Creating Instance

`Snapshot` takes the following to be created:

* <span id="path"> Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) to the [log directory](DeltaLog.md#logPath)
* <span id="version"> Version
* <span id="logSegment"> [LogSegment](LogSegment.md)
* <span id="minFileRetentionTimestamp"> `minFileRetentionTimestamp` (that is exactly [DeltaLog.minFileRetentionTimestamp](DeltaLog.md#minFileRetentionTimestamp))
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="timestamp"> Timestamp
* <span id="checksumOpt"> `VersionChecksum`

While being created, `Snapshot` prints out the following INFO message to the logs and [initialize](#init):

```text
Created snapshot [this]
```

`Snapshot` is created when:

* `SnapshotManagement` is requested for a [Snapshot](SnapshotManagement.md#createSnapshot)

### <span id="init"> Initializing

```scala
init(): Unit
```

`init` requests the [DeltaLog](#deltaLog) for the [protocolRead](DeltaLog.md#protocolRead) for the [Protocol](#protocol).

## <span id="numIndexedCols"> Maximum Number of Indexed Columns

```scala
numIndexedCols: Int
```

`numIndexedCols` is the value of [dataSkippingNumIndexedCols](DeltaConfigs.md#DATA_SKIPPING_NUM_INDEXED_COLS) table property.

??? note "Lazy Value"
    `numIndexedCols` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`numIndexedCols` is part of the [StatisticsCollection](StatisticsCollection.md#numIndexedCols) abstraction.

## Demo

* [Demo: DeltaTable, DeltaLog And Snapshots](demo/DeltaTable-DeltaLog-And-Snapshots.md)

## <span id="computedState"> Computed State

```scala
computedState: State
```

??? note "Lazy Value"
    `computedState` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`computedState` takes the [current cached set of actions](#stateDF) and reads the latest state (executes a `state.select(...).first()` query) with the [aggregations](#aggregationsToComputeState) (that are then mapped to a [State](State.md)).

!!! note
    The `state.select(...).first()` query uses aggregate standard functions (e.g. `last`, `collect_set`, `sum`, `count`) and so uses `groupBy` over the whole dataset indirectly.

![Details for Query in web UI](images/Snapshot-computedState-webui-query-details.png)

`computedState` asserts that the `State` to be returned has at least the default protocol and metadata (actions) defined.

---

While executing the aggregation query, `computedState` [withStatusCode](DeltaProgressReporter.md#withStatusCode) with the following:

Property | Value
---------|------
 statusCode | DELTA
 defaultMessage | Compute snapshot for version: [version](#version)

!!! tip
    Use event logs for the INFO messages and web UI to monitor execution of the aggregation query with the following job description:

    ```text
    Delta: Compute snapshot for version: [version]
    ```

---

`computedState` assumes that the protocol and metadata (actions) are defined. `computedState` throws an `IllegalStateException` when the actions are not defined and [spark.databricks.delta.stateReconstructionValidation.enabled](DeltaSQLConf.md#DELTA_STATE_RECONSTRUCTION_VALIDATION_ENABLED) configuration property is enabled.

```text
The [action] of your Delta table couldn't be recovered while Reconstructing
version: [version]. Did you manually delete files in the _delta_log directory?
```

!!! note
    The `state.select(...).first()` query uses `last` with `ignoreNulls` flag `true` and so may give no rows for `first()`.

### <span id="aggregationsToComputeState"> aggregationsToComputeState

```scala
aggregationsToComputeState: Map[String, Column]
```

Alias | Aggregation Expression
------|-----------------------
`sizeInBytes` | `coalesce(sum(col("add.size")), lit(0L))`
`numOfSetTransactions` | `count(col("txn"))`
`numOfFiles` | `count(col("add"))`
`numOfRemoves` | `count(col("remove"))`
`numOfMetadata` | `count(col("metaData"))`
`numOfProtocol` | `count(col("protocol"))`
`setTransactions` | `collect_set(col("txn"))`
`metadata` | `last(col("metaData"), ignoreNulls = true)`
`protocol` | `last(col("protocol"), ignoreNulls = true)`
`fileSizeHistogram` | `lit(null).cast(FileSizeHistogram.schema)`

## Configuration Properties

### <span id="getNumPartitions"> spark.databricks.delta.snapshotPartitions

`Snapshot` uses the [spark.databricks.delta.snapshotPartitions](DeltaSQLConf.md#DELTA_SNAPSHOT_PARTITIONS) configuration property for the number of partitions to use for [state reconstruction](#stateReconstruction).

### spark.databricks.delta.stateReconstructionValidation.enabled

`Snapshot` uses the [spark.databricks.delta.stateReconstructionValidation.enabled](DeltaSQLConf.md#DELTA_STATE_RECONSTRUCTION_VALIDATION_ENABLED) configuration property for [reconstructing state](#computedState).

## <span id="state"> State Dataset (of Actions)

```scala
state: Dataset[SingleAction]
```

`state` requests the [cached delta table state](#cachedState) for the [current state (from the cache)](CachedDS.md#getDS).

`state` is used when:

* `Checkpoints` utility is used to [writeCheckpoint](Checkpoints.md#writeCheckpoint)
* `Snapshot` is requested for [computedState](#computedState), [all files](#allFiles) and [files removed (tombstones)](#tombstones)
* `VacuumCommand` utility is requested for [garbage collection](commands/vacuum/VacuumCommand.md#gc)

### <span id="cachedState"> Cached State

```scala
cachedState: CachedDS[SingleAction]
```

??? note "Lazy Value"
    `cachedState` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`withStatsCache` [caches](StateCache.md#cacheDS) the [stateReconstruction DataFrame](#stateReconstruction) under the following name (with the [version](#version) and the [redactedPath](#redactedPath)):

```text
Delta Table State #[version] - [redactedPath]
```

## <span id="allFiles"> All AddFiles

```scala
allFiles: Dataset[AddFile]
```

`allFiles` simply takes the [state dataset](#state) and selects [AddFiles](AddFile.md) (adds `where` clause for `add IS NOT NULL` and `select` over the fields of [AddFiles](AddFile.md)).

!!! note
    `allFiles` simply adds `where` and `select` clauses. No computation happens yet as it is (a description of) a distributed computation as a `Dataset[AddFile]`.

```text
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, "/tmp/delta/users")
val files = deltaLog.snapshot.allFiles

scala> :type files
org.apache.spark.sql.Dataset[org.apache.spark.sql.delta.actions.AddFile]

scala> files.show(truncate = false)
+-------------------------------------------------------------------+---------------+----+----------------+----------+-----+----+
|path                                                               |partitionValues|size|modificationTime|dataChange|stats|tags|
+-------------------------------------------------------------------+---------------+----+----------------+----------+-----+----+
|part-00000-4050db39-e0f5-485d-ab3b-3ca72307f621-c000.snappy.parquet|[]             |262 |1578083748000   |false     |null |null|
|part-00000-ba39f292-2970-4528-a40c-8f0aa5f796de-c000.snappy.parquet|[]             |262 |1578083570000   |false     |null |null|
|part-00003-99f9d902-24a7-4f76-a15a-6971940bc245-c000.snappy.parquet|[]             |429 |1578083748000   |false     |null |null|
|part-00007-03d987f1-5bb3-4b5b-8db9-97b6667107e2-c000.snappy.parquet|[]             |429 |1578083748000   |false     |null |null|
|part-00011-a759a8c2-507d-46dd-9da7-dc722316214b-c000.snappy.parquet|[]             |429 |1578083748000   |false     |null |null|
|part-00015-2e685d29-25ed-4262-90a7-5491847fd8d0-c000.snappy.parquet|[]             |429 |1578083748000   |false     |null |null|
|part-00015-ee0ac1af-e1e0-4422-8245-12da91ced0a2-c000.snappy.parquet|[]             |429 |1578083570000   |false     |null |null|
+-------------------------------------------------------------------+---------------+----+----------------+----------+-----+----+
```

`allFiles` is used when:

* `PartitionFiltering` is requested for the [files to scan (matching projection attributes and predicates)](PartitionFiltering.md#filesForScan)

* `DeltaSourceSnapshot` is requested for the [initial files](DeltaSourceSnapshot.md#initialFiles) (indexed [AddFiles](AddFile.md))

* `GenerateSymlinkManifestImpl` is requested to [generateIncrementalManifest](GenerateSymlinkManifest.md#generateIncrementalManifest) and [generateFullManifest](GenerateSymlinkManifest.md#generateFullManifest)

* `DeltaDataSource` is requested for an [Insertable HadoopFsRelation](DeltaDataSource.md#RelationProvider-createRelation)

## <span id="stateReconstruction"> stateReconstruction Dataset of Actions

```scala
stateReconstruction: Dataset[SingleAction]
```

!!! note
    `stateReconstruction` returns a `Dataset[SingleAction]` and so does not do any computation per se.

`stateReconstruction` is a `Dataset` of [SingleActions](SingleAction.md) (that is the [dataset](CachedDS.md#ds) part) of the [cachedState](#cachedState).

`stateReconstruction` [loads the log file indices](#loadActions) (that gives a `Dataset[SingleAction]`).

`stateReconstruction` maps over partitions (using `Dataset.mapPartitions`) and canonicalize the paths for [AddFile](AddFile.md) and [RemoveFile](RemoveFile.md) actions.

`stateReconstruction` adds `file` column that uses a UDF to assert that `input_file_name()` belongs to the Delta table.

!!! note
    This UDF-based check is very clever.

`stateReconstruction` repartitions the `Dataset` using the path of add or remove actions (with the configurable [number of partitions](#getNumPartitions)) and `Dataset.sortWithinPartitions` by the `file` column.

In the end, `stateReconstruction` maps over partitions (using `Dataset.mapPartitions`) that creates a [InMemoryLogReplay](InMemoryLogReplay.md), requests it to [append the actions](InMemoryLogReplay.md#append) (as version `0`) and [checkpoint](InMemoryLogReplay.md#checkpoint).

`stateReconstruction` is used when:

* `Snapshot` is requested for a [cached Delta table state](#cachedState)

### <span id="loadActions"> Loading Actions

```scala
loadActions: Dataset[SingleAction]
```

`loadActions` creates a union of `Dataset[SingleAction]`s for the [indices](#fileIndices) (as [LogicalRelation](#indexToRelation)s over a `HadoopFsRelation`) or defaults to an [empty dataset](#emptyActions).

### <span id="indexToRelation"> indexToRelation

```scala
indexToRelation(
  index: DeltaLogFileIndex,
  schema: StructType = logSchema): LogicalRelation
```

`indexToRelation` converts the [DeltaLogFileIndex](DeltaLogFileIndex.md) to a `LogicalRelation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation)) leaf logical operator (using the [logSchema](Action.md#logSchema)).

`indexToRelation` creates a `LogicalRelation` over a `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) with the given index and the schema.

### <span id="emptyActions"> emptyActions Dataset (of Actions)

```scala
emptyActions: Dataset[SingleAction]
```

`emptyActions` is an empty dataset of [SingleActions](SingleAction.md) for [loadActions](#loadActions) (and `InitialSnapshot`'s `state`).

## <span id="getProperties"> Table Properties

```scala
getProperties: mutable.HashMap[String, String]
```

`getProperties` returns the following:

* [Configuration](Metadata.md#configuration) (of the [Metadata](#metadata)) without `path`
* [delta.minReaderVersion](Protocol.md#MIN_READER_VERSION_PROP) to be the [minReaderVersion](Protocol.md#minReaderVersion) (of the [Protocol](#protocol))
* [delta.minWriterVersion](Protocol.md#MIN_WRITER_VERSION_PROP) to be the [minWriterVersion](Protocol.md#minWriterVersion) (of the [Protocol](#protocol))

`getProperties` is used when:

* `DeltaTableV2` is requested for the [table properties](DeltaTableV2.md#properties)

## <span id="fileIndices"> File Indices

```scala
fileIndices: Seq[DeltaLogFileIndex]
```

??? note "Lazy Value"
    `fileIndices` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`fileIndices` is the [checkpointFileIndexOpt](#checkpointFileIndexOpt) and the [deltaFileIndexOpt](#deltaFileIndexOpt) (if available).

### <span id="deltaFileIndexOpt"> Commit File Index

```scala
deltaFileIndexOpt: Option[DeltaLogFileIndex]
```

??? note "Lazy Value"
    `deltaFileIndexOpt` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`deltaFileIndexOpt` is a [DeltaLogFileIndex](DeltaLogFileIndex.md) (in `JsonFileFormat`) for the checkpoint file of the [LogSegment](#logSegment).

### <span id="checkpointFileIndexOpt"> Checkpoint File Index

```scala
checkpointFileIndexOpt: Option[DeltaLogFileIndex]
```

??? note "Lazy Value"
    `checkpointFileIndexOpt` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`checkpointFileIndexOpt` is a [DeltaLogFileIndex](DeltaLogFileIndex.md) (in `ParquetFileFormat`) for the delta files of the [LogSegment](#logSegment).

## <span id="transactions"> Transaction Version By App ID

```scala
transactions: Map[String, Long]
```

`transactions` takes the [SetTransaction](#setTransactions) actions (from the [state](#state) dataset) and makes them a lookup table of [transaction version](SetTransaction.md#version) by [appId](SetTransaction.md#appId).

!!! note "Scala lazy value"
    `transactions` is a Scala lazy value and is initialized once at the first access. Once computed it stays unchanged for the `Snapshot` instance.

    ```text
    lazy val transactions: Map[String, Long]
    ```

`transactions` is used when `OptimisticTransactionImpl` is requested for the [transaction version for a given (streaming query) id](OptimisticTransactionImpl.md#txnVersion).

## <span="tombstones"> All RemoveFile Actions (Tombstones)

```scala
tombstones: Dataset[RemoveFile]
```

`tombstones`...FIXME

```text
scala> deltaLog.snapshot.tombstones.show(false)
+----+-----------------+----------+
|path|deletionTimestamp|dataChange|
+----+-----------------+----------+
+----+-----------------+----------+
```

## <span id="dataSchema"> Data Schema (of Delta Table)

```scala
dataSchema: StructType
```

`dataSchema` requests the [Metadata](#metadata) for the [data schema](Metadata.md#dataSchema).

`dataSchema` is part of the [StatisticsCollection](StatisticsCollection.md#dataSchema) abstraction.

## <span id="metadata"> Metadata

```scala
metadata: Metadata
```

`metadata` is part of the [SnapshotDescriptor](SnapshotDescriptor.md#metadata) and [DataSkippingReaderBase](data-skipping/DataSkippingReaderBase.md#metadata) abstractions.

---

`metadata` requests the [computedState](#computedState) for the [Metadata](State.md#metadata).
