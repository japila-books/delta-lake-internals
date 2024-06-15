# DeletionVectorStore

`DeletionVectorStore` is an [abstraction](#contract) of [stores](#implementations) of [deletion vectors](index.md) to be [loaded as RoaringBitmapArrays](#read).

`DeletionVectorStore` is created using [createInstance](#createInstance) utility.

## Contract (Subset)

### Loading Deletion Vector { #read }

```scala
read(
  path: Path,
  offset: Int,
  size: Int): RoaringBitmapArray
```

Loads (_reads_) a deletion vector (as `RoaringBitmapArray`)

See:

* [HadoopFileSystemDVStore](HadoopFileSystemDVStore.md#read)

Used when:

* `DeletionVectorStoredBitmap` is requested to [load a deletion vector](DeletionVectorStoredBitmap.md#load)

## Implementations

* [HadoopFileSystemDVStore](HadoopFileSystemDVStore.md)

## Creating DeletionVectorStore { #createInstance }

```scala
createInstance(
  hadoopConf: Configuration): DeletionVectorStore
```

`createInstance` creates a [HadoopFileSystemDVStore](HadoopFileSystemDVStore.md).

---

`createInstance` is used when:

* `DeletionVectorWriter` is requested to [create a deletion vector partition mapper function](DeletionVectorWriter.md#createDeletionVectorMapper)
* `CDCReaderImpl` is requested to [processDeletionVectorActions](../change-data-feed/CDCReaderImpl.md#processDeletionVectorActions)
* `RowIndexMarkingFiltersBuilder` is requested to [create a RowIndexFilter](RowIndexMarkingFiltersBuilder.md#createInstance) (for non-empty deletion vectors)
