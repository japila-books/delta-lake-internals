# CdcAddFileIndex

`CdcAddFileIndex` is a [TahoeBatchFileIndex](../TahoeBatchFileIndex.md) with the following:

Property | Value
---------|------
 [Action Type](../TahoeBatchFileIndex.md#actionType) | `cdcRead`
 [addFiles](../TahoeBatchFileIndex.md#addFiles) | The [AddFile](../AddFile.md)s of the given [CDCDataSpecs](#filesByVersion)

`CdcAddFileIndex` is used by [CDCReaderImpl](CDCReaderImpl.md) to [scanIndex](CDCReaderImpl.md#scanIndex).

## Creating Instance

`CdcAddFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="filesByVersion"> [AddFile](../AddFile.md)s by Version (`Seq[CDCDataSpec[AddFile]]`)
* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="path"> `Path`
* <span id="snapshot"> [SnapshotDescriptor](../SnapshotDescriptor.md)
* [Row Index Filters](#rowIndexFilters)

`CdcAddFileIndex` is created when:

* `CDCReaderImpl` is requested for the [DataFrame with deleted and added rows](CDCReaderImpl.md#getDeletedAndAddedRows) and to [processDeletionVectorActions](CDCReaderImpl.md#processDeletionVectorActions)

### Row Index Filters { #rowIndexFilters }

??? note "SupportsRowIndexFilters"

    ```scala
    rowIndexFilters: Option[Map[String, RowIndexFilterType]] = None
    ```

    `rowIndexFilters` is part of the [SupportsRowIndexFilters](../SupportsRowIndexFilters.md#rowIndexFilters) abstraction.

`CdcAddFileIndex` is given Row Index Filters when [created](#creating-instance).

## Input Files { #inputFiles }

??? note "FileIndex"

    ```scala
    inputFiles: Array[String]
    ```

    `inputFiles` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/connectors/FileIndex#inputFiles)) abstraction.

`inputFiles`...FIXME

## Matching Files { #matchingFiles }

??? note "TahoeFileIndex"

    ```scala
    matchingFiles(
      partitionFilters: Seq[Expression],
      dataFilters: Seq[Expression]): Seq[AddFile]
    ```

    `matchingFiles` is part of the [TahoeFileIndex](../TahoeFileIndex.md#matchingFiles) abstraction.

`matchingFiles`...FIXME

## Partitions { #partitionSchema }

??? note "FileIndex"

    ```scala
    partitionSchema: StructType
    ```

    `partitionSchema` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/connectors/FileIndex#partitionSchema)) abstraction.

`partitionSchema` [cdcReadSchema](CDCReader.md#cdcReadSchema) for the [partitions](../Metadata.md#partitionSchema) of (the [Metadata](../SnapshotDescriptor.md#metadata) of) the given [SnapshotDescriptor](#snapshot).
