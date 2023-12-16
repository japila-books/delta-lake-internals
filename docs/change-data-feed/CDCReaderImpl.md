# CDCReaderImpl

## getCDCRelation { #getCDCRelation }

```scala
getCDCRelation(
  spark: SparkSession,
  snapshotToUse: Snapshot,
  isTimeTravelQuery: Boolean,
  conf: SQLConf,
  options: CaseInsensitiveStringMap): BaseRelation
```

`getCDCRelation`...FIXME

---

`getCDCRelation` is used when:

* `DeltaLog` is requested to [create a BaseRelation](../DeltaLog.md#createRelation)

## changesToBatchDF { #changesToBatchDF }

```scala
changesToBatchDF(
  deltaLog: DeltaLog,
  start: Long,
  end: Long,
  spark: SparkSession,
  readSchemaSnapshot: Option[Snapshot] = None,
  useCoarseGrainedCDC: Boolean = false): DataFrame
```

`changesToBatchDF`...FIXME

---

`changesToBatchDF` is used when:

* `DeltaCDFRelation` is requested to [buildScan](DeltaCDFRelation.md#buildScan)

## changesToDF { #changesToDF }

```scala
changesToDF(
  readSchemaSnapshot: SnapshotDescriptor,
  start: Long,
  end: Long,
  changes: Iterator[(Long, Seq[Action])],
  spark: SparkSession,
  isStreaming: Boolean = false,
  useCoarseGrainedCDC: Boolean = false): CDCVersionDiffInfo
```

`changesToDF` [getTimestampsByVersion](#getTimestampsByVersion).

`changesToDF` requests the [DeltaLog](../SnapshotDescriptor.md#deltaLog) (of the given [SnapshotDescriptor](../SnapshotDescriptor.md)) for the [Snapshot](../SnapshotManagement.md#getSnapshotAt) at the given `start`.

`changesToDF` asserts that one of the following is enabled (or throws a `DeltaAnalysisException`):

* The given `useCoarseGrainedCDC` flag
* [isCDCEnabledOnTable](#isCDCEnabledOnTable)

!!! danger "`useCoarseGrainedCDC` flag is disabled by default"
    It is a fairly dangerous assertion given `useCoarseGrainedCDC` flag is disabled by default.

`changesToDF`...FIXME

In the end, `changesToDF` creates a new `CDCVersionDiffInfo`.

---

`changesToDF` is used when:

* `CDCReaderImpl` is requested to [changesToBatchDF](#changesToBatchDF)
* `DeltaSourceCDCSupport` is requested to [getCDCFileChangesAndCreateDataFrame](DeltaSourceCDCSupport.md#getCDCFileChangesAndCreateDataFrame)

### getDeletedAndAddedRows { #getDeletedAndAddedRows }

```scala
getDeletedAndAddedRows(
  addFileSpecs: Seq[CDCDataSpec[AddFile]],
  removeFileSpecs: Seq[CDCDataSpec[RemoveFile]],
  deltaLog: DeltaLog,
  snapshot: SnapshotDescriptor,
  isStreaming: Boolean,
  spark: SparkSession): Seq[DataFrame]
```

`getDeletedAndAddedRows`...FIXME

### processDeletionVectorActions { #processDeletionVectorActions }

```scala
processDeletionVectorActions(
  addFilesMap: Map[FilePathWithTableVersion, AddFile],
  removeFilesMap: Map[FilePathWithTableVersion, RemoveFile],
  versionToCommitInfo: Map[Long, CommitInfo],
  deltaLog: DeltaLog,
  snapshot: SnapshotDescriptor,
  isStreaming: Boolean,
  spark: SparkSession): Seq[DataFrame]
```

`processDeletionVectorActions`...FIXME

### generateFileActionsWithInlineDv { #generateFileActionsWithInlineDv }

```scala
generateFileActionsWithInlineDv(
  add: AddFile,
  remove: RemoveFile,
  dvStore: DeletionVectorStore,
  deltaLog: DeltaLog): Seq[FileAction]
```

`generateFileActionsWithInlineDv`...FIXME

## scanIndex { #scanIndex }

```scala
scanIndex(
  spark: SparkSession,
  index: TahoeFileIndexWithSnapshotDescriptor,
  isStreaming: Boolean = false): DataFrame
```

`scanIndex`...FIXME

---

`scanIndex` is used when:

* `CDCReaderImpl` is requested to [changesToDF](#changesToDF), [getDeletedAndAddedRows](#getDeletedAndAddedRows), [processDeletionVectorActions](#processDeletionVectorActions)

## CDC-Aware Table Scan (CDC Read) { #isCDCRead }

```scala
isCDCRead(
  options: CaseInsensitiveStringMap): Boolean
```

`isCDCRead` is `true` when one of the following options is specified (in the given `options`) with `true` value (case-insensitive):

1. [readChangeFeed](../delta/DeltaDataSource.md#readChangeFeed)
1. (legacy) [readChangeData](../delta/DeltaDataSource.md#readChangeData)

Otherwise, `isCDCRead` is `false`.

---

`isCDCRead` is used when:

* `DeltaRelation` utility is used to [fromV2Relation](../DeltaRelation.md#fromV2Relation)
* `DeltaTableV2` is requested for the [cdcRelation](../DeltaTableV2.md#cdcRelation), [initialSnapshot](../DeltaTableV2.md#initialSnapshot), [withOptions](../DeltaTableV2.md#withOptions)
* `DeltaDataSource` is requested for the [streaming source schema](../delta/DeltaDataSource.md#sourceSchema) and for a [relation](../delta/DeltaDataSource.md#RelationProvider-createRelation)
