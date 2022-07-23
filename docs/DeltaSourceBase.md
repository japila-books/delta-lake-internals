# DeltaSourceBase

`DeltaSourceBase` is an extension of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source)) abstraction for [DeltaSource](DeltaSource.md).

## <span id="SupportsAdmissionControl"> SupportsAdmissionControl

`DeltaSourceBase` is a `SupportsAdmissionControl` ([Spark Structured Streaming]({{ book.structured_streaming }}/SupportsAdmissionControl)).

## <span id="schema"> Source Schema

```scala
schema: StructType
```

`schema` is part of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source#schema)) abstraction.

---

`schema`...FIXME

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
    The `startSourceVersion` and `startOffsetOption` input arguments are ignored.

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

Otherwise, `getFileChangesAndCreateDataFrame`...FIXME

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
