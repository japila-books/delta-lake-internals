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
 `filePath` | The given `fileNameColumnOpt` if specified or `_metadata.file_path`
 `rowIndexCol` | The given `rowIndexColumnOpt` if specified or one of the following based on [spark.databricks.delta.deletionVectors.useMetadataRowIndex](../configuration-properties/index.md#deletionVectors.useMetadataRowIndex):<ul><li>`_metadata.row_index` (enabled)</li><li>[__delta_internal_row_index](../DeltaParquetFileFormat.md#ROW_INDEX_COLUMN_NAME)</li></ul>

With the table uses deletion vectors already (based on the given `tableHasDVs`), `buildRowIndexSetsForFilesMatchingCondition`...FIXME...to add [deletionVectorId](#FILE_DV_ID_COL) column with the value of [deletionVector](../AddFile.md#deletionVector) of the given `candidateFiles`. Otherwise, the [deletionVectorId](#FILE_DV_ID_COL) is `null`.

In the end, `buildRowIndexSetsForFilesMatchingCondition` [buildDeletionVectors](#buildDeletionVectors) (with the DataFrame).

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
