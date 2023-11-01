# DeletionVectorBitmapGenerator

## buildRowIndexSetsForFilesMatchingCondition { #buildRowIndexSetsForFilesMatchingCondition }

```scala
buildRowIndexSetsForFilesMatchingCondition(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  tableHasDVs: Boolean,
  targetDf: DataFrame,
  candidateFiles: Seq[AddFile],
  condition: Expression): Seq[DeletionVectorResult]
```

`buildRowIndexSetsForFilesMatchingCondition` adds the following columns to the input `targetDf` DataFrame:

Column Name | Column
------------|-------
 `filePath` | `_metadata.file_path`
 `rowIndexCol` | [__delta_internal_row_index](../DeltaParquetFileFormat.md#ROW_INDEX_COLUMN_NAME)

`buildRowIndexSetsForFilesMatchingCondition` filters out the rows based on the given `condition` expression.

`buildRowIndexSetsForFilesMatchingCondition`...FIXME

---

`buildRowIndexSetsForFilesMatchingCondition` is used when:

* `DMLWithDeletionVectorsHelper` is requested to [findTouchedFiles](DMLWithDeletionVectorsHelper.md#findTouchedFiles)

### buildDeletionVectors { #buildDeletionVectors }

```scala
buildDeletionVectors(
  spark: SparkSession,
  target: DataFrame,
  targetDeltaLog: DeltaLog,
  deltaTxn: OptimisticTransaction): Seq[DeletionVectorResult]
```

`buildDeletionVectors`...FIXME
