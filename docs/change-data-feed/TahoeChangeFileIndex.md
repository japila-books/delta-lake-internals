# TahoeChangeFileIndex

`TahoeChangeFileIndex` is a [TahoeFileIndexWithSnapshotDescriptor](../TahoeFileIndexWithSnapshotDescriptor.md) of [AddCDCFiles](#filesByVersion) for [changesToDF](CDCReaderImpl.md#changesToDF) in [Change Data Feed](index.md).

## Creating Instance

`TahoeChangeFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="filesByVersion"> [CDCDataSpec](CDCDataSpec.md)s of [AddCDCFile](../AddCDCFile.md)
* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="path"> Path
* <span id="snapshot"> [SnapshotDescriptor](../SnapshotDescriptor.md)

`TahoeChangeFileIndex` is created when:

* `CDCReaderImpl` is requested to [changesToDF](CDCReaderImpl.md#changesToDF)

## matchingFiles { #matchingFiles }

??? note "TahoeFileIndex"

    ```scala
    matchingFiles(
      partitionFilters: Seq[Expression],
      dataFilters: Seq[Expression]): Seq[AddFile]
    ```

    `matchingFiles` is part of the [TahoeFileIndex](../TahoeFileIndex.md#matchingFiles) abstraction.

`matchingFiles`...FIXME

## inputFiles { #inputFiles }

??? note "TahoeFileIndex"

    ```scala
    inputFiles: Array[String]
    ```

    `inputFiles` is part of the [TahoeFileIndex](../TahoeFileIndex.md#inputFiles) abstraction.

`inputFiles` is the absolute paths of all the [AddCDCFile](CDCDataSpec.md#actions)s of the [CDCDataSpecs](CDCDataSpec.md).
