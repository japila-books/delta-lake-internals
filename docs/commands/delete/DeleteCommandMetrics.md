# DeleteCommandMetrics

`DeleteCommandMetrics` is a marker extension of the `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) abstraction for [delete commands](#implementations) with [performance metrics](#createMetrics).

## <span id="createMetrics"> Performance Metrics

```scala
createMetrics: Map[String, SQLMetric]
```

Name | web UI
-----|-------
 `numRemovedFiles` | number of files removed.
 `numAddedFiles` | number of files added.
 `numDeletedRows` | number of rows deleted.
 `numFilesBeforeSkipping` | number of files before skipping
 `numBytesBeforeSkipping` | number of bytes before skipping
 `numFilesAfterSkipping` | number of files after skipping
 `numBytesAfterSkipping` | number of bytes after skipping
 `numPartitionsAfterSkipping` | number of partitions after skipping
 `numPartitionsAddedTo` | number of partitions added
 `numPartitionsRemovedFrom` | number of partitions removed
 `numCopiedRows` | number of rows copied
 `numBytesAdded` | number of bytes added
 `numBytesRemoved` | number of bytes removed
 `executionTimeMs` | time taken to execute the entire operation
 `scanTimeMs` | time taken to scan the files for matches
 `rewriteTimeMs` | time taken to rewrite the matched files
 `numAddedChangeFiles` | number of change data capture files generated
 `changeFileBytes` | total size of change data capture files generated
 `numTouchedRows` | number of rows touched

`createMetrics` is used when:

* `DeleteCommand` is requested for the [performance metrics](DeleteCommand.md#metrics)

## <span id="getDeletedRowsFromAddFilesAndUpdateMetrics"> getDeletedRowsFromAddFilesAndUpdateMetrics

```scala
getDeletedRowsFromAddFilesAndUpdateMetrics(
  files: Seq[AddFile]): Option[Long]
```

`getDeletedRowsFromAddFilesAndUpdateMetrics`...FIXME

---

`getDeletedRowsFromAddFilesAndUpdateMetrics` is used when:

* `DeleteCommand` is requested to [performDelete](DeleteCommand.md#performDelete)
