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

### replaceFileIndex { #replaceFileIndex }

```scala
replaceFileIndex(
  target: LogicalPlan,
  fileIndex: TahoeFileIndex): LogicalPlan
```

`replaceFileIndex` transforms (_recognizes_) the following logical operators in given `target` logical plan:

1. `LogicalRelation`s with `HadoopFsRelation`s ([Spark SQL]({{ book.spark_sql }}/connectors/HadoopFsRelation/)) with [DeltaParquetFileFormat](../DeltaParquetFileFormat.md)
1. `Project`s

`replaceFileIndex` adds the following metadata columns to the output schema (of the logical operators):

1. Delta-specific [__delta_internal_row_index](../DeltaParquetFileFormat.md#ROW_INDEX_COLUMN_NAME)
1. `FileFormat`-specific `_metadata` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormat/#createFileMetadataCol))

In addition, for `LogicalRelation`s, `replaceFileIndex` changes the `HadoopFsRelation` to use the following:

* The given [TahoeFileIndex](../TahoeFileIndex.md) as the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/connectors/HadoopFsRelation/#location))
* The `DeltaParquetFileFormat` with [splitting](../DeltaParquetFileFormat.md#isSplittable) and [pushdowns](../DeltaParquetFileFormat.md#disablePushDowns) disabled
