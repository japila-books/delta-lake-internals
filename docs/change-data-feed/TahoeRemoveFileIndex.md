# TahoeRemoveFileIndex

`TahoeRemoveFileIndex` is a [TahoeFileIndexWithSnapshotDescriptor](../TahoeFileIndexWithSnapshotDescriptor.md) of [RemoveFiles](#filesByVersion) for [changesToDF](CDCReaderImpl.md#changesToDF) in [Change Data Feed](index.md).

## Creating Instance

`TahoeRemoveFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* [Versioned RemoveFiles](#filesByVersion)
* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="path"> Path
* <span id="snapshot"> [SnapshotDescriptor](../SnapshotDescriptor.md)
* <span id="rowIndexFilters"> Row Index Filters (`Option[Map[String, RowIndexFilterType]]`)

`TahoeRemoveFileIndex` is created when:

* `CDCReaderImpl` is requested to [changesToDF](CDCReaderImpl.md#changesToDF) ([getDeletedAndAddedRows](CDCReaderImpl.md#getDeletedAndAddedRows) and [processDeletionVectorActions](CDCReaderImpl.md#processDeletionVectorActions))

### Versioned RemoveFiles { #filesByVersion }

```scala
filesByVersion: Seq[CDCDataSpec[RemoveFile]]
```

`TahoeRemoveFileIndex` is given a [CDCDataSpec](CDCDataSpec.md)s of [RemoveFile](../RemoveFile.md)s when [created](#creating-instance).

The `CDCDataSpec`s come from the [DeltaLog](../DeltaLog.md#getChanges) of a delta table (converted along the way to match the API).

## Matching Files { #matchingFiles }

??? note "TahoeFileIndex"

    ```scala
    matchingFiles(
      partitionFilters: Seq[Expression],
      dataFilters: Seq[Expression]): Seq[AddFile]
    ```

    `matchingFiles` is part of the [TahoeFileIndex](../TahoeFileIndex.md#matchingFiles) abstraction.

`matchingFiles` creates [AddFile](../AddFile.md)s for every [RemoveFile](CDCDataSpec.md#files) (in the given [CDCDataSpecs](#filesByVersion) of [RemoveFile](../RemoveFile.md)s by version).

??? note "Fake AddFiles"
    `matchingFiles` returns a `Seq[AddFile]` and so [AddFile](../AddFile.md)s are fake in `TahoeRemoveFileIndex` as it deals with [RemoveFile](CDCDataSpec.md#files)s.

`matchingFiles` [filterFileList](../DeltaLog.md#filterFileList) (with the [partitionSchema](#partitionSchema), a `DataFrame` of the "fake" `AddFile`s and the given `partitionFilters`). That gives a `DataFrame`.

In the end, `filterFileList` converts the `DataFrame` to a `Dataset[AddFile]` (using `Dataset.as` operator) and collect the [AddFile](../AddFile.md)s (using `Dataset.collect` operator).

## Input Files { #inputFiles }

??? note "TahoeFileIndex"

    ```scala
    inputFiles: Array[String]
    ```

    `inputFiles` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/connectors/FileIndex/#inputFiles)) abstraction.

`inputFiles` is the absolute paths of all the [RemoveFile](CDCDataSpec.md#actions)s of the [CDCDataSpecs](CDCDataSpec.md).

## Partition Schema { #partitionSchema }

??? note "TahoeFileIndex"

    ```scala
    partitionSchema: StructType
    ```

    `partitionSchema` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/connectors/FileIndex/#partitionSchema)) abstraction.

`partitionSchema` returns the [CDF-Aware Read Schema](CDCReaderImpl.md#cdcReadSchema).
