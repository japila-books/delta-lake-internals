# OptimizeMetrics

`OptimizeMetrics` is the metrics of the [OPTIMIZE](OptimizeTableCommandBase.md#output) command:

* <span id="numFilesAdded"> numFilesAdded
* <span id="numFilesRemoved"> numFilesRemoved
* <span id="filesAdded"> `FileSizeMetrics` of the files added
* <span id="filesRemoved"> `FileSizeMetrics` of the files removed
* <span id="partitionsOptimized"> partitionsOptimized
* <span id="zOrderStats"> zOrderStats
* <span id="numBatches"> numBatches
* <span id="totalConsideredFiles"> totalConsideredFiles
* <span id="totalFilesSkipped"> totalFilesSkipped
* <span id="preserveInsertionOrder"> preserveInsertionOrder
* <span id="numFilesSkippedToReduceWriteAmplification"> numFilesSkippedToReduceWriteAmplification
* <span id="numBytesSkippedToReduceWriteAmplification"> numBytesSkippedToReduceWriteAmplification
* <span id="startTimeMs"> startTimeMs
* <span id="endTimeMs"> endTimeMs

`OptimizeMetrics` is created when `OptimizeStats` is requested for the [OptimizeMetrics](OptimizeStats.md#toOptimizeMetrics).
