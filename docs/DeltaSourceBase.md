# DeltaSourceBase

`DeltaSourceBase` is an extension of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source)) abstraction for [DeltaSource](DeltaSource.md).

## <span id="schema"> Read (Source) Schema

```scala
schema: StructType
```

`schema` is part of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source#schema)) abstraction.

---

`schema` [removes the default expressions](ColumnWithDefaultExprUtils.md#removeDefaultExpressions) from the table schema (from the [Metadata](Snapshot.md#metadata) of the [Snapshot](SnapshotManagement.md#snapshot) of the [DeltaLog](DeltaSource.md#deltaLog)).

In the end, `schema` [adds the CDF columns](change-data-feed/CDCReader.md#cdcReadSchema) to the schema when [readChangeFeed](DeltaReadOptions.md#readChangeFeed) option is enabled. Otherwise, `schema` returns the schema with no CDF columns and default expressions.

## <span id="createDataFrameBetweenOffsets"> createDataFrameBetweenOffsets

```scala
createDataFrameBetweenOffsets(
  startVersion: Long,
  startIndex: Long,
  isStartingVersion: Boolean,
  startSourceVersion: Option[Long],
  startOffsetOption: Option[Offset],
  endOffset: DeltaSourceOffset): DataFrame
```

`createDataFrameBetweenOffsets` [getFileChangesAndCreateDataFrame](#getFileChangesAndCreateDataFrame).

!!! note
    The `startSourceVersion` and `startOffsetOption` input arguments are ignored. It looks like the method should be marked as `@obsolete` and soon removed.

`createDataFrameBetweenOffsets` is used when:

* `DeltaSource` is requested for the [batch DataFrame](DeltaSource.md#getBatch)

### <span id="getFileChangesAndCreateDataFrame"> getFileChangesAndCreateDataFrame

```scala
getFileChangesAndCreateDataFrame(
  startVersion: Long,
  startIndex: Long,
  isStartingVersion: Boolean,
  endOffset: DeltaSourceOffset): DataFrame
```

With [readChangeFeed](DeltaReadOptions.md#readChangeFeed) option enabled, `getFileChangesAndCreateDataFrame` [getCDCFileChangesAndCreateDataFrame](change-data-feed/DeltaSourceCDCSupport.md#getCDCFileChangesAndCreateDataFrame).

Otherwise, `getFileChangesAndCreateDataFrame` [gets the file changes](#getFileChanges) (as `IndexedFile`s with [AddFile](AddFile.md)s, [RemoveFile](RemoveFile.md)s or [AddCDCFile](AddCDCFile.md)s) and take as much file changes so their version and index (these actions belong to) are up to and including [DeltaSourceOffset](DeltaSourceOffset.md) (based on the [reservoirVersion](DeltaSourceOffset.md#reservoirVersion) and [index](DeltaSourceOffset.md#index)). `getFileChangesAndCreateDataFrame` filters out the file changes with the [path](FileAction.md#path) that matches the [excludeRegex](DeltaSource.md#excludeRegex) option. In the end, `getFileChangesAndCreateDataFrame` [createDataFrame](#createDataFrame) (from the filtered file changes).

### <span id="createDataFrame"> createDataFrame

```scala
createDataFrame(
  indexedFiles: Iterator[IndexedFile]): DataFrame
```

`createDataFrame` collects [AddFile](AddFile.md)s from the given `indexedFiles` collection.

In the end, `createDataFrame` requests the [DeltaLog](DeltaSource.md#deltaLog) to [createDataFrame](DeltaLog.md#createDataFrame) (for the `AddFile`s and with `isStreaming` flag enabled).

## <span id="getStartingOffsetFromSpecificDeltaVersion"> getStartingOffsetFromSpecificDeltaVersion

```scala
getStartingOffsetFromSpecificDeltaVersion(
  fromVersion: Long,
  isStartingVersion: Boolean,
  limits: Option[AdmissionLimits]): Option[Offset]
```

`getStartingOffsetFromSpecificDeltaVersion` [getFileChangesWithRateLimit](#getFileChangesWithRateLimit) and takes the last `IndexedFile` (if any).

`getStartingOffsetFromSpecificDeltaVersion` returns `None` for no (last) `IndexedFile`. Otherwise, `getStartingOffsetFromSpecificDeltaVersion` [buildOffsetFromIndexedFile](#buildOffsetFromIndexedFile).

`getStartingOffsetFromSpecificDeltaVersion` is used when:

* `DeltaSource` is requested for the [starting offset](DeltaSource.md#getStartingOffset)

## <span id="getNextOffsetFromPreviousOffset"> getNextOffsetFromPreviousOffset

```scala
getNextOffsetFromPreviousOffset(
  previousOffset: DeltaSourceOffset,
  limits: Option[AdmissionLimits]): Option[Offset]
```

`getNextOffsetFromPreviousOffset`...FIXME

`getNextOffsetFromPreviousOffset` is used when:

* `DeltaSource` is requested for the [latest offset](DeltaSource.md#latestOffset)

## <span id="getFileChangesWithRateLimit"> getFileChangesWithRateLimit

```scala
getFileChangesWithRateLimit(
  fromVersion: Long,
  fromIndex: Long,
  isStartingVersion: Boolean,
  limits: Option[AdmissionLimits] = Some(new AdmissionLimits())): ClosableIterator[IndexedFile]
```

`getFileChangesWithRateLimit`...FIXME

`getFileChangesWithRateLimit` is used when:

* `DeltaSourceBase` is requested to [getStartingOffsetFromSpecificDeltaVersion](#getStartingOffsetFromSpecificDeltaVersion) and [getNextOffsetFromPreviousOffset](#getNextOffsetFromPreviousOffset)

## <span id="buildOffsetFromIndexedFile"> buildOffsetFromIndexedFile

```scala
buildOffsetFromIndexedFile(
  indexedFile: IndexedFile,
  version: Long,
  isStartingVersion: Boolean): Option[DeltaSourceOffset]
```

`buildOffsetFromIndexedFile`...FIXME

`buildOffsetFromIndexedFile` is used when:

* `DeltaSourceBase` is requested to [getStartingOffsetFromSpecificDeltaVersion](#getStartingOffsetFromSpecificDeltaVersion) and [getNextOffsetFromPreviousOffset](#getNextOffsetFromPreviousOffset)

## <span id="SupportsAdmissionControl"> SupportsAdmissionControl

`DeltaSourceBase` is a `SupportsAdmissionControl` ([Spark Structured Streaming]({{ book.structured_streaming }}/SupportsAdmissionControl)).

!!! note
    All the methods of `SupportsAdmissionControl` are in [DeltaSource](DeltaSource.md).
