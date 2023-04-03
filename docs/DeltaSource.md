# DeltaSource

`DeltaSource` is a [DeltaSourceBase](DeltaSourceBase.md) of the [delta](DeltaDataSource.md) data source for streaming queries.

## <span id="DeltaSourceCDCSupport"> DeltaSourceCDCSupport

`DeltaSource` is a [DeltaSourceCDCSupport](change-data-feed/DeltaSourceCDCSupport.md).

## Creating Instance

`DeltaSource` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="options"> [DeltaOptions](DeltaOptions.md)
* <span id="filters"> Filter `Expression`s (default: empty)

`DeltaSource` is created when:

* `DeltaDataSource` is requested for a [streaming source](DeltaDataSource.md#createSource)

## Demo

```text
val q = spark
  .readStream               // Creating a streaming query
  .format("delta")          // Using delta data source
  .load("/tmp/delta/users") // Over data in a delta table
  .writeStream
  .format("memory")
  .option("queryName", "demo")
  .start
import org.apache.spark.sql.execution.streaming.{MicroBatchExecution, StreamingQueryWrapper}
val plan = q.asInstanceOf[StreamingQueryWrapper]
  .streamingQuery
  .asInstanceOf[MicroBatchExecution]
  .logicalPlan
import org.apache.spark.sql.execution.streaming.StreamingExecutionRelation
val relation = plan.collect { case r: StreamingExecutionRelation => r }.head

import org.apache.spark.sql.delta.sources.DeltaSource
assert(relation.source.asInstanceOf[DeltaSource])

scala> println(relation.source)
DeltaSource[file:/tmp/delta/users]
```

## <span id="getBatch"> Streaming Micro-Batch DataFrame

```scala
getBatch(
  start: Option[Offset],
  end: Offset): DataFrame
```

`getBatch` is part of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source#getBatch)) abstraction.

---

`getBatch` creates a [DeltaSourceOffset](DeltaSourceOffset.md) for the [tableId](#tableId) (aka [reservoirId](DeltaSourceOffset.md#reservoirId)) and the given `end` offset.

`getBatch` determines the `startVersion`, `startIndex`, `isStartingVersion` and `startSourceVersion` based on the given `startOffsetOption`:

If undefined, `getBatch` [getStartingVersion](#getStartingVersion) and _does some computation_.

If specified, `getBatch` creates a [DeltaSourceOffset](DeltaSourceOffset.md). Unless the `DeltaSourceOffset` is [isStartingVersion](DeltaSourceOffset.md#isStartingVersion), `getBatch` [cleanUpSnapshotResources](DeltaSourceBase.md#cleanUpSnapshotResources). `getBatch` uses the `DeltaSourceOffset` for the versions and the index.

`getBatch` prints out the following DEBUG message to the logs:

```text
start: [startOffsetOption] end: [end]
```

In the end, `getBatch` [createDataFrameBetweenOffsets](DeltaSourceBase.md#createDataFrameBetweenOffsets) (for the `startVersion`, `startIndex`, `isStartingVersion` and `endOffset`).

## <span id="latestOffset"> Latest Available Streaming Offset

```scala
latestOffset(
  startOffset: streaming.Offset,
  limit: ReadLimit): streaming.Offset
```

`latestOffset` is part of the `SupportsAdmissionControl` ([Spark Structured Streaming]({{ book.structured_streaming }}/SupportsAdmissionControl#latestOffset)) abstraction.

---

`latestOffset` determines the latest offset (_currentOffset_) based on whether the [previousOffset](#previousOffset) internal registry is [initialized](#latestOffset-previousOffset-defined) or [not](#latestOffset-previousOffset-null).

`latestOffset` prints out the following DEBUG message to the logs (using the [previousOffset](#previousOffset) internal registry).

```text
previousOffset -> currentOffset: [previousOffset] -> [currentOffset]
```

In the end, `latestOffset` returns the [previousOffset](#previousOffset) if defined or `null`.

### <span id="latestOffset-previousOffset-null"> No previousOffset

For no [previousOffset](#previousOffset), `getOffset` [retrieves the starting offset](#getStartingOffset) (with a new [AdmissionLimits](AdmissionLimits.md) for the given `ReadLimit`).

### <span id="latestOffset-previousOffset-defined"> previousOffset Available

When the [previousOffset](#previousOffset) is defined (which is when the `DeltaSource` is requested for another micro-batch), `latestOffset` [gets the changes](#getChangesWithRateLimit) as an indexed [AddFile](AddFile.md)s (with the [previousOffset](#previousOffset) and a new [AdmissionLimits](AdmissionLimits.md) for the given `ReadLimit`).

`latestOffset` takes the [last AddFile](#iteratorLast) if available.

With no `AddFile`, `latestOffset` returns the [previousOffset](#previousOffset).

With the [previousOffset](#previousOffset) and the [last indexed AddFile](#iteratorLast) both available, `latestOffset` creates a new [DeltaSourceOffset](DeltaSourceOffset.md) for the version, index, and `isLast` flag from the last indexed [AddFile](AddFile.md).

!!! note
    `isStartingVersion` local value is enabled (`true`) when the following holds:

    * Version of the last indexed [AddFile](AddFile.md) is equal to the [reservoirVersion](DeltaSourceOffset.md#reservoirVersion) of the [previous ending offset](#previousOffset)

    * [isStartingVersion](DeltaSourceOffset.md#isStartingVersion) flag of the [previous ending offset](#previousOffset) is enabled (`true`)

### <span id="getStartingOffset"> getStartingOffset

```scala
getStartingOffset(
  limits: Option[AdmissionLimits]): Option[Offset]
```

`getStartingOffset`...FIXME (review me)

`getStartingOffset` requests the [DeltaLog](#deltaLog) for the version of the delta table (by requesting for the [current state (snapshot)](DeltaLog.md#snapshot) and then for the [version](Snapshot.md#version)).

`getStartingOffset` [takes the last file](#iteratorLast) from the [files added (with rate limit)](#getChangesWithRateLimit) for the version of the delta table, `-1L` as the `fromIndex`, and the `isStartingVersion` flag enabled (`true`).

`getStartingOffset` returns a new [DeltaSourceOffset](DeltaSourceOffset.md) for the [tableId](#tableId), the version and the index of the last file added, and whether the last file added is the last file of its version.

`getStartingOffset` returns `None` (_offset not available_) when either happens:

* the version of the delta table is negative (below `0`)

* no files were added in the version

`getStartingOffset` throws an `AssertionError` when the version of the last file added is smaller than the delta table's version:

```text
assertion failed: getChangesWithRateLimit returns an invalid version: [v] (expected: >= [version])
```

### <span id="getChangesWithRateLimit"> getChangesWithRateLimit

```scala
getChangesWithRateLimit(
  fromVersion: Long,
  fromIndex: Long,
  isStartingVersion: Boolean): Iterator[IndexedFile]
```

`getChangesWithRateLimit` [gets the changes](#getChanges) (as indexed [AddFile](AddFile.md)s) for the given `fromVersion`, `fromIndex`, and `isStartingVersion` flag.

### <span id="getOffset"> getOffset

```scala
getOffset: Option[Offset]
```

`getOffset` is part of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source#getOffset)) abstraction.

`getOffset` has been replaced by the newer [latestOffset](#latestOffset) and so throws an `UnsupportedOperationException` when called:

```text
latestOffset(Offset, ReadLimit) should be called instead of this method
```

## Snapshot Management

`DeltaSource` uses internal registries for the [DeltaSourceSnapshot](#initialState) and the [version](#initialStateVersion) to avoid requesting the [DeltaLog](#deltaLog) for [getSnapshotAt](DeltaLog.md#getSnapshotAt).

### <span id="initialState"> Snapshot

`DeltaSource` uses `initialState` internal registry for the [DeltaSourceSnapshot](DeltaSourceSnapshot.md) of the state of the [delta table](#deltaLog) at the [initialStateVersion](#initialStateVersion).

`DeltaSourceSnapshot` is used for [AddFiles of the delta table at a given version](#getSnapshotAt).

Initially uninitialized (`null`).

`DeltaSourceSnapshot` is [created](DeltaSourceSnapshot.md) (_initialized_) when uninitialized or the version requested is different from the [current one](#initialStateVersion).

`DeltaSourceSnapshot` is [closed](DeltaSourceSnapshot.md#close) and dereferenced (`null`) when `DeltaSource` is requested to [cleanUpSnapshotResources](#cleanUpSnapshotResources) (due to [version change](#getSnapshotAt), [another micro-batch](#getBatch) or [stop](#stop)).

### <span id="initialStateVersion"> Version

`DeltaSource` uses `initialStateVersion` internal registry to keep track of the version of [DeltaSourceSnapshot](DeltaSourceSnapshot.md) (when requested for [AddFiles of the delta table at a given version](#getSnapshotAt)).

Changes (alongside the [initialState](#initialState)) to the version requested when `DeltaSource` is requested for the [snapshot at a given version](#getSnapshotAt) (only when the versions are different)

Used when:

* `DeltaSource` is requested for [AddFiles of the delta table at a given version](#getSnapshotAt) and to [cleanUpSnapshotResources](#cleanUpSnapshotResources) (and unpersist the current snapshot)

## <span id="stop"> Stopping

```scala
stop(): Unit
```

`stop` is part of the `Source` ([Spark Structured Streaming]({{ book.spark_sql }}/Source#stop)) abstraction.

`stop` simply [cleanUpSnapshotResources](#cleanUpSnapshotResources).

## <span id="previousOffset"> Previous Offset

Ending [DeltaSourceOffset](DeltaSourceOffset.md) of the latest [micro-batch](#getBatch)

Starts uninitialized (`null`).

Used when `DeltaSource` is requested for the [latest available offset](#getOffset).

## <span id="getSnapshotAt"> AddFiles of Delta Table at Given Version

```scala
getSnapshotAt(
  version: Long): Iterator[IndexedFile]
```

`getSnapshotAt` requests the [DeltaSourceSnapshot](#initialState) for the [data files](SnapshotIterator.md#iterator) (as indexed [AddFile](AddFile.md)s).

In case the [DeltaSourceSnapshot](#initialState) hasn't been initialized yet (`null`) or the requested version is different from the [initialStateVersion](#initialStateVersion), `getSnapshotAt` does the following:

1. [cleanUpSnapshotResources](#cleanUpSnapshotResources)

1. Requests the [DeltaLog](#deltaLog) for the [state (snapshot) of the delta table](DeltaLog.md#getSnapshotAt) at the version

1. Creates a new [DeltaSourceSnapshot](DeltaSourceSnapshot.md) for the state (snapshot) as the current [DeltaSourceSnapshot](#initialState)

1. Changes the [initialStateVersion](#initialStateVersion) internal registry to the requested version

`getSnapshotAt` is used when:

* `DeltaSource` is requested to [getChanges](#getChanges) (with `isStartingVersion` flag enabled)

## <span id="getChanges"> getChanges

```scala
getChanges(
  fromVersion: Long,
  fromIndex: Long,
  isStartingVersion: Boolean): Iterator[IndexedFile]
```

`getChanges` branches based on `isStartingVersion` flag (enabled or not):

* For `isStartingVersion` flag enabled (`true`), `getChanges` [gets the state (snapshot)](#getSnapshotAt) for the given `fromVersion` followed by [(filtered out) indexed AddFiles](#getChanges-filterAndIndexDeltaLogs) for the next version after the given `fromVersion`

* For `isStartingVersion` flag disabled (`false`), `getChanges` simply gives [(filtered out) indexed AddFiles](#getChanges-filterAndIndexDeltaLogs) for the given `fromVersion`

!!! note
    `isStartingVersion` flag simply adds the [state (snapshot)](#getSnapshotAt) before [(filtered out) indexed AddFiles](#getChanges-filterAndIndexDeltaLogs) when enabled (`true`).

    `isStartingVersion` flag is enabled when `DeltaSource` is requested for the following:

    * [Micro-batch with data between start and end offsets](#getBatch) and the start offset is not given or is for the [starting version](DeltaSourceOffset.md#isStartingVersion)

    * [Latest available offset](#getOffset) with no [end offset of the latest micro-batch](#previousOffset) or the [end offset of the latest micro-batch](#previousOffset) for the [starting version](DeltaSourceOffset.md#isStartingVersion)

In the end, `getChanges` filters out (_excludes_) indexed [AddFile](AddFile.md)s that are not with the version later than the given `fromVersion` or the index greater than the given `fromIndex`.

`getChanges` is used when:

* `DeltaSource` is requested for the [latest available offset](#getOffset) (when requested for the [files added (with rate limit)](#getChangesWithRateLimit)) and [getBatch](#getBatch)

### <span id="getChanges-filterAndIndexDeltaLogs"> filterAndIndexDeltaLogs

```scala
filterAndIndexDeltaLogs(
  startVersion: Long): Iterator[IndexedFile]
```

`filterAndIndexDeltaLogs`...FIXME

### <span id="verifyStreamHygieneAndFilterAddFiles"> verifyStreamHygieneAndFilterAddFiles

```scala
verifyStreamHygieneAndFilterAddFiles(
  actions: Seq[Action],
  version: Long): Seq[Action]
```

`verifyStreamHygieneAndFilterAddFiles`...FIXME

## <span id="cleanUpSnapshotResources"> cleanUpSnapshotResources

```scala
cleanUpSnapshotResources(): Unit
```

`cleanUpSnapshotResources` does the following when the [initial DeltaSourceSnapshot](#initialState) internal registry is not empty:

* Requests the [DeltaSourceSnapshot](#initialState) to [close](DeltaSourceSnapshot.md#close) (with the `unpersistSnapshot` flag based on whether the [initialStateVersion](#initialStateVersion) is earlier than the [snapshot version](Snapshot.md#version))
* Dereferences (_nullifies_) the [DeltaSourceSnapshot](#initialState)

Otherwise, `cleanUpSnapshotResources` does nothing.

`cleanUpSnapshotResources` is used when:

* `DeltaSource` is requested to [getSnapshotAt](#getSnapshotAt), [getBatch](#getBatch) and [stop](#stop)

## <span id="getDefaultReadLimit"> ReadLimit

```scala
getDefaultReadLimit: ReadLimit
```

`getDefaultReadLimit` is part of the `SupportsAdmissionControl` ([Spark Structured Streaming]({{ book.structured_streaming }}/SupportsAdmissionControl#getDefaultReadLimit)) abstraction.

`getDefaultReadLimit` creates a [AdmissionLimits](AdmissionLimits.md) and requests it for a corresponding [ReadLimit](AdmissionLimits.md#toReadLimit).

## <span id="iteratorLast"> Retrieving Last Element From Iterator

```scala
iteratorLast[T](
  iter: Iterator[T]): Option[T]
```

`iteratorLast` simply returns the last element of the given `Iterator` ([Scala]({{ scala.api }}/scala/collection/Iterator.html)) or `None`.

`iteratorLast` is used when:

* `DeltaSource` is requested to [getStartingOffset](#getStartingOffset) and [getOffset](#getOffset)

## <span id="excludeRegex"> excludeRegex Option

```scala
excludeRegex: Option[Regex]
```

`excludeRegex` requests the [DeltaOptions](#options) for the value of [excludeRegex](DeltaReadOptions.md#excludeRegex) option.

!!! note "Refactor It"
    `excludeRegex` should not really be part of `DeltaSource` (more of [DeltaSourceBase](DeltaSourceBase.md)) since it's used elsewhere anyway.

---

`excludeRegex` is used when:

* `DeltaSourceBase` is requested to [getFileChangesAndCreateDataFrame](DeltaSourceBase.md#getFileChangesAndCreateDataFrame)
* `IndexedChangeFileSeq` (of [DeltaSourceCDCSupport](change-data-feed/DeltaSourceCDCSupport.md)) is requested to [isValidIndexedFile](change-data-feed/IndexedChangeFileSeq.md#isValidIndexedFile)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.sources.DeltaSource` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.sources.DeltaSource=ALL
```

Refer to [Logging](logging.md).
