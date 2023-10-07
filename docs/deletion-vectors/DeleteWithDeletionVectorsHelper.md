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
