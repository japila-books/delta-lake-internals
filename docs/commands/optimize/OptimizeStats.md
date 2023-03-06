# OptimizeStats

`OptimizeStats` holds the statistics of [OptimizeExecutor](OptimizeExecutor.md) (when requested to [optimize](OptimizeExecutor.md#optimize)).

## Creating Instance

`OptimizeStats` takes the following to be created:

* <span id="addedFilesSizeStats"> addedFilesSizeStats
* <span id="removedFilesSizeStats"> removedFilesSizeStats
* <span id="numPartitionsOptimized"> numPartitionsOptimized
* <span id="zOrderStats"> `ZOrderStats`
* <span id="numBatches"> numBatches
* <span id="totalConsideredFiles"> totalConsideredFiles
* <span id="totalFilesSkipped"> totalFilesSkipped
* <span id="preserveInsertionOrder"> preserveInsertionOrder
* <span id="numFilesSkippedToReduceWriteAmplification"> numFilesSkippedToReduceWriteAmplification
* <span id="numBytesSkippedToReduceWriteAmplification"> numBytesSkippedToReduceWriteAmplification
* <span id="startTimeMs"> startTimeMs
* <span id="endTimeMs"> endTimeMs
* <span id="totalClusterParallelism"> totalClusterParallelism
* <span id="totalScheduledTasks"> totalScheduledTasks
* <span id="autoCompactParallelismStats"> `AutoCompactParallelismStats`

`OptimizeStats` is created when:

* `OptimizeExecutor` is requested to [optimize](OptimizeExecutor.md#optimize)

## <span id="FileSizeStats"> FileSizeStats

`FileSizeStats` holds the following metrics:

* <span id="minFileSize"> minFileSize
* <span id="maxFileSize"> maxFileSize
* <span id="totalFiles"> totalFiles
* <span id="totalSize"> totalSize

`FileSizeStats` is created and used to represent the following `OptimizeStats` metrics:

* [addedFilesSizeStats](#addedFilesSizeStats)
* [removedFilesSizeStats](#removedFilesSizeStats)

## <span id="toOptimizeMetrics"> Creating OptimizeMetrics

```scala
toOptimizeMetrics: OptimizeMetrics
```

`toOptimizeMetrics` converts this `OptimizeStats` to a [OptimizeMetrics](OptimizeMetrics.md).

---

`toOptimizeMetrics` is used when:

* `OptimizeExecutor` is requested to [optimize](OptimizeExecutor.md#optimize)
