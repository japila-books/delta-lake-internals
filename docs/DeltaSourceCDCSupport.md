# DeltaSourceCDCSupport

`DeltaSourceCDCSupport` is an abstraction of CDC support for [DeltaSource](DeltaSource.md).

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

* `DeltaSourceBase` is requested to [createDataFrameBetweenOffsets](DeltaSourceBase.md#createDataFrameBetweenOffsets) (and [getFileChangesAndCreateDataFrame](DeltaSourceBase.md#getFileChangesAndCreateDataFrame))
