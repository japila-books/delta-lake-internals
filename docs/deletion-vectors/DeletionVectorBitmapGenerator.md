# DeletionVectorBitmapGenerator

## buildRowIndexSetsForFilesMatchingCondition { #buildRowIndexSetsForFilesMatchingCondition }

```scala
buildRowIndexSetsForFilesMatchingCondition(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  tableHasDVs: Boolean,
  targetDf: DataFrame,
  candidateFiles: Seq[AddFile],
  condition: Expression,
  fileNameColumnOpt: Option[Column] = None,
  rowIndexColumnOpt: Option[Column] = None): Seq[DeletionVectorResult]
```

`buildRowIndexSetsForFilesMatchingCondition` adds the following columns to the input `targetDf` DataFrame:

Column Name | Column
------------|-------
 [filePath](#FILE_NAME_COL) | The given `fileNameColumnOpt` if specified or `_metadata.file_path`
 [rowIndexCol](#ROW_INDEX_COL) | The given `rowIndexColumnOpt` if specified or one of the following based on [spark.databricks.delta.deletionVectors.useMetadataRowIndex](../configuration-properties/index.md#deletionVectors.useMetadataRowIndex):<ul><li>`_metadata.row_index` (enabled)</li><li>[__delta_internal_row_index](../DeltaParquetFileFormat.md#ROW_INDEX_COLUMN_NAME)</li></ul>
 [deletionVectorId](#FILE_DV_ID_COL) | <ul><li>With the table with deletion vectors (based on the given `tableHasDVs` flag), `buildRowIndexSetsForFilesMatchingCondition`...FIXME...the [DeletionVectorDescriptor](../AddFile.md#deletionVector)s of the given `candidateFiles`</li><li>Otherwise, `null` (undefined)</li></ul>

In the end, `buildRowIndexSetsForFilesMatchingCondition` [builds the deletion vectors](#buildDeletionVectors) (for the modified `targetDf` DataFrame).

---

`buildRowIndexSetsForFilesMatchingCondition` is used when:

* `DMLWithDeletionVectorsHelper` is requested to [findTouchedFiles](DMLWithDeletionVectorsHelper.md#findTouchedFiles)

### Building Deletion Vectors { #buildDeletionVectors }

```scala
buildDeletionVectors(
  spark: SparkSession,
  target: DataFrame,
  targetDeltaLog: DeltaLog,
  deltaTxn: OptimisticTransaction): Seq[DeletionVectorResult]
```

`buildDeletionVectors` creates a new [DeletionVectorSet](DeletionVectorSet.md) to [build the deletion vectors](DeletionVectorSet.md#computeResult).
