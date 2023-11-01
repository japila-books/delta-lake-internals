# DMLWithDeletionVectorsHelper

## createTargetDfForScanningForMatches { #createTargetDfForScanningForMatches }

```scala
createTargetDfForScanningForMatches(
  spark: SparkSession,
  target: LogicalPlan,
  fileIndex: TahoeFileIndex): DataFrame
```

`createTargetDfForScanningForMatches` creates a `DataFrame` with [replaceFileIndex](#replaceFileIndex) logical operator (based on the given `target` and [TahoeFileIndex](../TahoeFileIndex.md))

---

`createTargetDfForScanningForMatches` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete) (with [deletion vectors enabled](../commands/delete/DeleteCommand.md#shouldWritePersistentDeletionVectors))
* `UpdateCommand` is requested to [performUpdate](../commands/update/UpdateCommand.md#performUpdate) (with [deletion vectors enabled](../commands/update/UpdateCommand.md#shouldWritePersistentDeletionVectors))

### Replacing FileIndex { #replaceFileIndex }

```scala
replaceFileIndex(
  target: LogicalPlan,
  fileIndex: TahoeFileIndex): LogicalPlan
```

`replaceFileIndex` replaces a `FileIndex` in all the delta tables in the given `target` logical plan (with some other changes).

`replaceFileIndex` transforms (_recognizes_) the following logical operators in given `target` logical plan:

1. `LogicalRelation`s with `HadoopFsRelation`s ([Spark SQL]({{ book.spark_sql }}/connectors/HadoopFsRelation/)) with [DeltaParquetFileFormat](../DeltaParquetFileFormat.md)
1. `Project`s

`replaceFileIndex` adds the following metadata columns to the output schema (of the logical operators):

1. Delta-specific [__delta_internal_row_index](../DeltaParquetFileFormat.md#ROW_INDEX_COLUMN_NAME)
1. `FileFormat`-specific `_metadata` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormat/#createFileMetadataCol))

In addition, for `LogicalRelation`s, `replaceFileIndex` changes the `HadoopFsRelation` to use the following:

* The given [TahoeFileIndex](../TahoeFileIndex.md) as the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/connectors/HadoopFsRelation/#location))
* The `DeltaParquetFileFormat` with [splitting](../DeltaParquetFileFormat.md#isSplittable) and [pushdowns](../DeltaParquetFileFormat.md#disablePushDowns) disabled

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  hasDVsEnabled: Boolean,
  deltaLog: DeltaLog,
  targetDf: DataFrame,
  fileIndex: TahoeFileIndex,
  condition: Expression,
  opName: String): Seq[TouchedFileWithDV]
```

`findTouchedFiles`...FIXME

---

`findTouchedFiles` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)
* `UpdateCommand` is requested to [performUpdate](../commands/update/UpdateCommand.md#performUpdate)

### findFilesWithMatchingRows { #findFilesWithMatchingRows }

```scala
findFilesWithMatchingRows(
  txn: OptimisticTransaction,
  nameToAddFileMap: Map[String, AddFile],
  matchedFileRowIndexSets: Seq[DeletionVectorResult]): Seq[TouchedFileWithDV]
```

`findFilesWithMatchingRows`...FIXME

## processUnmodifiedData { #processUnmodifiedData }

```scala
processUnmodifiedData(
  spark: SparkSession,
  touchedFiles: Seq[TouchedFileWithDV],
  snapshot: Snapshot): (Seq[FileAction], Map[String, Long])
```

!!! danger "Review Me"

`processUnmodifiedData` calculates the following metrics (using the given `touchedFiles`):

* The total [number of modified rows](TouchedFileWithDV.md#numberOfModifiedRows)
* The number of [isFullyReplaced](TouchedFileWithDV.md#isFullyReplaced) data files

`processUnmodifiedData` splits (_partitions_) the given [TouchedFileWithDV](TouchedFileWithDV.md)s into fully removed ones and the others (based on [isFullyReplaced](TouchedFileWithDV.md#isFullyReplaced) flag).

`processUnmodifiedData`...FIXME

In the end, `processUnmodifiedData` returns a collection of the [RemoveFile](../RemoveFile.md) and [AddFile](../AddFile.md) actions along with the following metrics:

* `numModifiedRows`
* `numRemovedFiles`
* `numDeletionVectorsAdded`
* `numDeletionVectorsRemoved`
* `numDeletionVectorsUpdated`

---

`processUnmodifiedData` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete) (with [shouldWritePersistentDeletionVectors](../commands/delete/DeleteCommand.md#shouldWritePersistentDeletionVectors) enabled and supported)
