# DeleteWithDeletionVectorsHelper

`DeleteWithDeletionVectorsHelper` is a [DeltaCommand](../commands/DeltaCommand.md).

## processUnmodifiedData { #processUnmodifiedData }

```scala
processUnmodifiedData(
  spark: SparkSession,
  touchedFiles: Seq[TouchedFileWithDV],
  snapshot: Snapshot): (Seq[FileAction], Map[String, Long])
```

`processUnmodifiedData`...FIXME

---

`processUnmodifiedData` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  hasDVsEnabled: Boolean,
  deltaLog: DeltaLog,
  targetDf: DataFrame,
  fileIndex: TahoeFileIndex,
  condition: Expression): Seq[TouchedFileWithDV]
```

`findTouchedFiles`...FIXME

---

`findTouchedFiles` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)
