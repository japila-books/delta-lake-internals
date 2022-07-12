# OptimizeStats

## Creating Instance

`OptimizeStats` takes the following to be created:

* <span id="addedFilesSizeStats"> addedFilesSizeStats
* <span id="removedFilesSizeStats"> removedFilesSizeStats
* <span id="numPartitionsOptimized"> numPartitionsOptimized
* <span id="zOrderStats"> zOrderStats
* <span id="numBatches"> numBatches
* <span id="totalConsideredFiles"> totalConsideredFiles
* <span id="totalFilesSkipped"> totalFilesSkipped
* <span id="preserveInsertionOrder"> preserveInsertionOrder
* <span id="numFilesSkippedToReduceWriteAmplification"> numFilesSkippedToReduceWriteAmplification
* <span id="numBytesSkippedToReduceWriteAmplification"> numBytesSkippedToReduceWriteAmplification
* <span id="startTimeMs"> startTimeMs
* <span id="endTimeMs"> endTimeMs

`OptimizeStats` is created when:

* `OptimizeExecutor` is requested to [optimize](OptimizeExecutor.md#optimize)

## <span id="toOptimizeMetrics"> Creating OptimizeMetrics

```scala
toOptimizeMetrics: OptimizeMetrics
```

`toOptimizeMetrics` converts this `OptimizeStats` to a [OptimizeMetrics](OptimizeMetrics.md).

`toOptimizeMetrics` is used when:

* `OptimizeExecutor` is requested to [optimize](OptimizeExecutor.md#optimize)
