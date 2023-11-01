# TouchedFileWithDV

`TouchedFileWithDV` is an [AddFile](#fileLogEntry) with a [DeletionVectorDescriptor](#newDeletionVector) for [Deletion Vectors](index.md) table feature.

## Creating Instance

`TouchedFileWithDV` takes the following to be created:

* <span id="inputFilePath"> The path of the input file
* <span id="fileLogEntry"> [AddFile](../AddFile.md)
* <span id="newDeletionVector"> [DeletionVectorDescriptor](DeletionVectorDescriptor.md)
* <span id="deletedRows"> Deleted Rows

`TouchedFileWithDV` is created when:

* `DMLWithDeletionVectorsHelper` is requested to [findFilesWithMatchingRows](DMLWithDeletionVectorsHelper.md#findFilesWithMatchingRows)
