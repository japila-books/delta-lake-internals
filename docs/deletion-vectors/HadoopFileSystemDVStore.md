# HadoopFileSystemDVStore

`HadoopFileSystemDVStore` is a [DeletionVectorStore](DeletionVectorStore.md).

## Creating Instance

`HadoopFileSystemDVStore` takes the following to be created:

* <span id="hadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))

`HadoopFileSystemDVStore` is created when:

* `DeletionVectorStore` is requested to [create a DeletionVectorStore](DeletionVectorStore.md#createInstance)

## Reading Deletion Vector { #read }

??? note "DeletionVectorStore"

    ```scala
    read(
      path: Path,
      offset: Int,
      size: Int): RoaringBitmapArray
    ```

    `read` is part of the [DeletionVectorStore](DeletionVectorStore.md#read) abstraction.

`read`...FIXME
