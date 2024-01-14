# DeltaSourceBase

`DeltaSourceBase` is an extension of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source)) abstraction for [DeltaSource](DeltaSource.md).

## Schema { #schema }

??? note "Source"

    ```scala
    schema: StructType
    ```

    `schema` is part of the `Source` ([Spark Structured Streaming]({{ book.structured_streaming }}/Source#schema)) abstraction.

`schema` [removes the internal table metadata](../DeltaTableUtils.md#removeInternalMetadata) (with the [readSchemaAtSourceInit](#readSchemaAtSourceInit)).

With [readChangeFeed](DeltaReadOptions.md#readChangeFeed) option enabled, `schema` [adds the CDF columns](../change-data-feed/CDCReader.md#cdcReadSchema) to the schema.

In the end, `schema` returns the schema of a delta table with or without CDF columns (based on [readChangeFeed](DeltaReadOptions.md#readChangeFeed) option).

## Creating Streaming DataFrame Between Offsets { #createDataFrameBetweenOffsets }

```scala
createDataFrameBetweenOffsets(
  startVersion: Long,
  startIndex: Long,
  isStartingVersion: Boolean,
  startSourceVersion: Option[Long],
  startOffsetOption: Option[Offset],
  endOffset: DeltaSourceOffset): DataFrame
```

`createDataFrameBetweenOffsets` [creates a streaming DataFrame between versions (possibly CDF-aware)](#getFileChangesAndCreateDataFrame).

??? note "Obsolete Soon?"
    `createDataFrameBetweenOffsets` is simply an alias of [getFileChangesAndCreateDataFrame](#getFileChangesAndCreateDataFrame).

    Moreover, the `startSourceVersion` and `startOffsetOption` input arguments are ignored.

    It looks like this method should be marked as `@obsolete` and soon removed.

---

`createDataFrameBetweenOffsets` is used when:

* `DeltaSource` is requested for a [streaming micro-batch DataFrame](DeltaSource.md#getBatch)

### Creating Streaming DataFrame Between Versions (Possibly CDF-Aware) { #getFileChangesAndCreateDataFrame }

```scala
getFileChangesAndCreateDataFrame(
  startVersion: Long,
  startIndex: Long,
  isStartingVersion: Boolean,
  endOffset: DeltaSourceOffset): DataFrame
```

With [readChangeFeed](DeltaReadOptions.md#readChangeFeed) option enabled, `getFileChangesAndCreateDataFrame` [getCDCFileChangesAndCreateDataFrame](../change-data-feed/DeltaSourceCDCSupport.md#getCDCFileChangesAndCreateDataFrame).

Otherwise, `getFileChangesAndCreateDataFrame` [gets the file changes](#getFileChanges) (as `IndexedFile`s with [AddFile](../AddFile.md)s, [RemoveFile](../RemoveFile.md)s or [AddCDCFile](../AddCDCFile.md)s) and take as much file changes so their version and index (these actions belong to) are up to and including [DeltaSourceOffset](DeltaSourceOffset.md) (based on the [reservoirVersion](DeltaSourceOffset.md#reservoirVersion) and [index](DeltaSourceOffset.md#index)). `getFileChangesAndCreateDataFrame` filters out the file changes with the [path](../FileAction.md#path) that matches the [excludeRegex](DeltaSource.md#excludeRegex) option. In the end, `getFileChangesAndCreateDataFrame` [createDataFrame](#createDataFrame) (from the filtered file changes).

### createDataFrame { #createDataFrame }

```scala
createDataFrame(
  indexedFiles: Iterator[IndexedFile]): DataFrame
```

`createDataFrame` collects [AddFile](../AddFile.md)s from the given `indexedFiles` collection.

In the end, `createDataFrame` requests the [DeltaLog](DeltaSource.md#deltaLog) to [createDataFrame](../DeltaLog.md#createDataFrame) (for the `AddFile`s and with `isStreaming` flag enabled).

## getStartingOffsetFromSpecificDeltaVersion { #getStartingOffsetFromSpecificDeltaVersion }

```scala
getStartingOffsetFromSpecificDeltaVersion(
  fromVersion: Long,
  isStartingVersion: Boolean,
  limits: Option[AdmissionLimits]): Option[Offset]
```

`getStartingOffsetFromSpecificDeltaVersion` [getFileChangesWithRateLimit](#getFileChangesWithRateLimit) and takes the last `IndexedFile` (if any).

`getStartingOffsetFromSpecificDeltaVersion` returns `None` for no (last) `IndexedFile`. Otherwise, `getStartingOffsetFromSpecificDeltaVersion` [buildOffsetFromIndexedFile](#buildOffsetFromIndexedFile).

---

`getStartingOffsetFromSpecificDeltaVersion` is used when:

* `DeltaSource` is requested for the [starting offset](DeltaSource.md#getStartingOffset)

## getNextOffsetFromPreviousOffset { #getNextOffsetFromPreviousOffset }

```scala
getNextOffsetFromPreviousOffset(
  previousOffset: DeltaSourceOffset,
  limits: Option[AdmissionLimits]): Option[Offset]
```

`getNextOffsetFromPreviousOffset`...FIXME

---

`getNextOffsetFromPreviousOffset` is used when:

* `DeltaSource` is requested for the [latest offset](DeltaSource.md#latestOffset)

## getFileChangesWithRateLimit { #getFileChangesWithRateLimit }

```scala
getFileChangesWithRateLimit(
  fromVersion: Long,
  fromIndex: Long,
  isStartingVersion: Boolean,
  limits: Option[AdmissionLimits] = Some(new AdmissionLimits())): ClosableIterator[IndexedFile]
```

`getFileChangesWithRateLimit`...FIXME

---

`getFileChangesWithRateLimit` is used when:

* `DeltaSourceBase` is requested to [getStartingOffsetFromSpecificDeltaVersion](#getStartingOffsetFromSpecificDeltaVersion) and [getNextOffsetFromPreviousOffset](#getNextOffsetFromPreviousOffset)

## buildOffsetFromIndexedFile { #buildOffsetFromIndexedFile }

```scala
buildOffsetFromIndexedFile(
  indexedFile: IndexedFile,
  version: Long,
  isStartingVersion: Boolean): Option[DeltaSourceOffset]
```

`buildOffsetFromIndexedFile`...FIXME

---

`buildOffsetFromIndexedFile` is used when:

* `DeltaSourceBase` is requested to [getStartingOffsetFromSpecificDeltaVersion](#getStartingOffsetFromSpecificDeltaVersion) and [getNextOffsetFromPreviousOffset](#getNextOffsetFromPreviousOffset)

## SupportsAdmissionControl { #SupportsAdmissionControl }

`DeltaSourceBase` is a `SupportsAdmissionControl` ([Spark Structured Streaming]({{ book.structured_streaming }}/SupportsAdmissionControl)).

!!! note
    All the methods of `SupportsAdmissionControl` are in [DeltaSource](DeltaSource.md).

## allowUnsafeStreamingReadOnColumnMappingSchemaChanges { #allowUnsafeStreamingReadOnColumnMappingSchemaChanges }

```scala
allowUnsafeStreamingReadOnColumnMappingSchemaChanges: Boolean
```

`allowUnsafeStreamingReadOnColumnMappingSchemaChanges` is the value of [spark.databricks.delta.streaming.unsafeReadOnIncompatibleColumnMappingSchemaChanges.enabled](../configuration-properties/index.md#DELTA_STREAMING_UNSAFE_READ_ON_INCOMPATIBLE_COLUMN_MAPPING_SCHEMA_CHANGES) configuration property.

---

`allowUnsafeStreamingReadOnColumnMappingSchemaChanges` is used when:

* `DeltaSourceBase` is requested to [checkReadIncompatibleSchemaChangeOnStreamStartOnce](#checkReadIncompatibleSchemaChangeOnStreamStartOnce), [checkReadIncompatibleSchemaChanges](#checkReadIncompatibleSchemaChanges)
* `DeltaSourceMetadataEvolutionSupport` is requested to `readyToInitializeMetadataTrackingEagerly` and `trackingMetadataChange`

## isStreamingFromColumnMappingTable { #isStreamingFromColumnMappingTable }

```scala
isStreamingFromColumnMappingTable: Boolean
```

`DeltaSourceBase` initializes `isStreamingFromColumnMappingTable` internal flag when created.

`isStreamingFromColumnMappingTable` is enabled (`true`) when streaming from a delta table with [Column Mapping](../column-mapping/index.md).

In other words, `isStreamingFromColumnMappingTable` is enabled when the [DeltaColumnMappingMode](../Metadata.md#columnMappingMode) of the [Metadata](../SnapshotDescriptor.md#metadata) of this [SnapshotDescriptor](DeltaSource.md#snapshotAtSourceInit) is any value but [NoMapping](../column-mapping/DeltaColumnMappingMode.md#NoMapping).

---

`isStreamingFromColumnMappingTable` is used when:

* `DeltaSourceBase` is requested to [checkReadIncompatibleSchemaChangeOnStreamStartOnce](#checkReadIncompatibleSchemaChangeOnStreamStartOnce), [checkReadIncompatibleSchemaChanges](#checkReadIncompatibleSchemaChanges)

## persistedMetadataAtSourceInit { #persistedMetadataAtSourceInit }

```scala
persistedMetadataAtSourceInit: Option[PersistedMetadata]
```

`DeltaSourceBase` initializes `persistedMetadataAtSourceInit` internal flag when created.

`persistedMetadataAtSourceInit` is the [PersistedMetadata](DeltaSourceMetadataTrackingLog.md#getCurrentTrackedMetadata) of this [DeltaSourceMetadataTrackingLog](DeltaSource.md#metadataTrackingLog), if all defined.

In other words, `persistedMetadataAtSourceInit` is defined only when this [DeltaSourceMetadataTrackingLog](DeltaSource.md#metadataTrackingLog) was (at the very minimum).

---

`persistedMetadataAtSourceInit` is used when:

* `DeltaSourceBase` is requested for a [SnapshotDescriptor](#readSnapshotDescriptor)
* `DeltaSourceMetadataEvolutionSupport` is requested to [hasMetadataOrProtocolChangeComparedToStreamMetadata](DeltaSourceMetadataEvolutionSupport.md#hasMetadataOrProtocolChangeComparedToStreamMetadata)
