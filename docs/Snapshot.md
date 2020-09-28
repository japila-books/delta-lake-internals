# Snapshot

**Snapshot** is an immutable snapshot of the [state](#state) of a [Delta table](#deltaLog) at a [version](#version).

## Creating Instance

Snapshot takes the following to be created:

* <span id="path"> Hadoop [Path](https://hadoop.apache.org/docs/r{{ hadoop.version }}/api/org/apache/hadoop/fs/Path.html) to the [log directory](DeltaLog.md#logPath)
* <span id="version"> Version
* <span id="logSegment"> `LogSegment`
* <span id="minFileRetentionTimestamp"> `minFileRetentionTimestamp` (that is exactly [DeltaLog.minFileRetentionTimestamp](DeltaLog.md#minFileRetentionTimestamp))
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="timestamp"> Timestamp
* <span id="checksumOpt"> Optional `VersionChecksum`

While being created, `Snapshot` prints out the following INFO message to the logs and [initialize](#init):

```text
Created snapshot [this]
```

`Snapshot` is created when `SnapshotManagement` is requested to [createSnapshot](SnapshotManagement.md#createSnapshot).

### <span id="init"> Initializing

```scala
init(): Unit
```

`init` requests the [DeltaLog](#deltaLog) for the [protocolRead](DeltaLog.md#protocolRead) for the [Protocol](#protocol).

## <span id="computedState"> Computed State

```scala
computedState: State
```

!!! note "Scala lazy value"
    `computedState` is a Scala lazy value and is initialized once at the first access. Once computed it stays unchanged for the `Snapshot` instance.

    ```text
    lazy val computedState: State
    ```

`computedState` takes the [current cached set of actions](#state) and reads the latest state (executes a `state.select(...).first()` query).

!!! note
    The `state.select(...).first()` query uses aggregate standard functions (e.g. `last`, `collect_set`, `sum`, `count`) and so uses `groupBy` over the whole dataset indirectly.

![Details for Query in web UI](images/Snapshot-computedState-webui-query-details.png)

`computedState` assumes that the protocol and metadata (actions) are defined. `computedState` throws an `IllegalStateException` when the actions are not defined and [spark.databricks.delta.stateReconstructionValidation.enabled](DeltaSQLConf.md#DELTA_STATE_RECONSTRUCTION_VALIDATION_ENABLED) configuration property is enabled.

```text
The [action] of your Delta table couldn't be recovered while Reconstructing
version: [version]. Did you manually delete files in the _delta_log directory?
```

!!! note
    The `state.select(...).first()` query uses `last` with `ignoreNulls` flag `true` and so may give no rows for `first()`.

`computedState` makes sure that the `State` to be returned has at least the default protocol and metadata (actions) defined.

## Configuration Properties

### <span id="getNumPartitions"> spark.databricks.delta.snapshotPartitions

`Snapshot` uses the [spark.databricks.delta.snapshotPartitions](DeltaSQLConf.md#DELTA_SNAPSHOT_PARTITIONS) configuration property for the number of partitions to use for [state reconstruction](#stateReconstruction).

### spark.databricks.delta.stateReconstructionValidation.enabled

`Snapshot` uses the [spark.databricks.delta.stateReconstructionValidation.enabled](DeltaSQLConf.md#DELTA_STATE_RECONSTRUCTION_VALIDATION_ENABLED) configuration property for [reconstructing state](#computedState).

## <span id="state"> State Dataset (of Actions)

```scala
state: Dataset[SingleAction]
```

`state` simply requests the [cached delta state](#cachedState) to [get the delta state from the cache](CachedDS.md#getDS).

`state` is used when:

* `DeltaLog` is requested to [update](DeltaLog.md#update)

* `Checkpoints` is requested to [checkpoint](Checkpoints.md#checkpoint)

* `Snapshot` is created, and requested for [allFiles](#allFiles) and [tombstones](#tombstones)

* `VacuumCommand` is requested for [garbage collecting of a delta table](commands/VacuumCommand.md#gc)

## <span id="allFiles"> All AddFile Actions

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

## <span id="stateReconstruction"> stateReconstruction Dataset (of Actions)

```scala
stateReconstruction: Dataset[SingleAction]
```

`stateReconstruction` is a dataset of [SingleActions](SingleAction.md) (that is the [dataset](CachedDS.md#ds) part) of the [cachedState](#cachedState).

## <span id="emptyActions"> emptyActions Dataset (of Actions)

```scala
emptyActions: Dataset[SingleAction]
```

`emptyActions` is an empty dataset of [SingleActions](SingleAction.md) for [stateReconstruction](#stateReconstruction) and [load](#load).

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

## <span id="cachedState"> cachedState

```scala
cachedState: CachedDS[SingleAction]
```

!!! note "Scala lazy value"
    `cachedState` is a Scala lazy value and is initialized once at the first access. Once computed it stays unchanged for the `Snapshot` instance.

    ```text
    lazy val cachedState: CachedDS[SingleAction]
    ```

[Cached Delta State](CachedDS.md) that is made up of the following:

* The [dataset](CachedDS.md#ds) part is the [stateReconstruction](#stateReconstruction) dataset of [SingleAction](SingleAction.md)s

* The [name](CachedDS.md#name) in the format **Delta Table State #version - [redactedPath]** (with the [version](#version) and the path redacted)

Used when Snapshot is requested for the [state](#state) (`Dataset[SingleAction]`)
