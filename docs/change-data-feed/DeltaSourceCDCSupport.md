# DeltaSourceCDCSupport

`DeltaSourceCDCSupport` is an abstraction of [CDC support](index.md) for [DeltaSource](../DeltaSource.md).

## <span id="getCDCFileChangesAndCreateDataFrame"> getCDCFileChangesAndCreateDataFrame

```scala
getCDCFileChangesAndCreateDataFrame(
  startVersion: Long,
  startIndex: Long,
  isStartingVersion: Boolean,
  endOffset: DeltaSourceOffset): DataFrame
```

`getCDCFileChangesAndCreateDataFrame`...FIXME

`getCDCFileChangesAndCreateDataFrame` is used when:

* `DeltaSourceBase` is requested to [createDataFrameBetweenOffsets](../DeltaSourceBase.md#createDataFrameBetweenOffsets) (and [getFileChangesAndCreateDataFrame](../DeltaSourceBase.md#getFileChangesAndCreateDataFrame))

## <span id="getFileChangesForCDC"> getFileChangesForCDC

```scala
getFileChangesForCDC(
  fromVersion: Long,
  fromIndex: Long,
  isStartingVersion: Boolean,
  limits: Option[AdmissionLimits],
  endOffset: Option[DeltaSourceOffset]): Iterator[(Long, Iterator[IndexedFile])]
```

`getFileChangesForCDC`...FIXME

`getFileChangesForCDC` is used when:

* `DeltaSourceBase` is requested to [getFileChangesWithRateLimit](../DeltaSourceBase.md#getFileChangesWithRateLimit)
* `DeltaSourceCDCSupport` is requested to [getCDCFileChangesAndCreateDataFrame](#getCDCFileChangesAndCreateDataFrame)

### <span id="filterAndIndexDeltaLogs"> filterAndIndexDeltaLogs

```scala
filterAndIndexDeltaLogs(
  startVersion: Long): Iterator[(Long, IndexedChangeFileSeq)]
```

`filterAndIndexDeltaLogs`...FIXME

### <span id="filterCDCActions"> filterCDCActions

```scala
filterCDCActions(
  actions: Seq[Action],
  version: Long): Seq[FileAction]
```

!!! note
    `version` argument is ignored.

`filterCDCActions` collects the [AddCDCFile](../AddCDCFile.md) actions from the given `actions` if there are any.

Otherwise, `filterCDCActions` collects [AddFile](../AddFile.md)s and [RemoveFile](../RemoveFile.md)s with `dataChange` enabled.
