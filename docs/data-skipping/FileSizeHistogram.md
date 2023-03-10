# FileSizeHistogram

!!! note
    `FileSizeHistogram` does not seem to be used in the current release.

## Creating Instance

`FileSizeHistogram` takes the following to be created:

* <span id="sortedBinBoundaries"> Sorted Bin Boundaries
* <span id="fileCounts"> File Counts
* <span id="totalBytes"> Total Bytes

`FileSizeHistogram` is created using [apply](#apply).

## <span id="apply"> Creating FileSizeHistogram

```scala
apply(
  sortedBinBoundaries: IndexedSeq[Long]): FileSizeHistogram
```

`apply` creates a [FileSizeHistogram](#creating-instance) with the given `sortedBinBoundaries` and the [fileCounts](#fileCounts) and the [totalBytes](#totalBytes) all `0`s (for every element in `sortedBinBoundaries`).
