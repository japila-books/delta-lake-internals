# DeletionVectorWriter

## createMapperToStoreDeletionVectors { #createMapperToStoreDeletionVectors }

```scala
createMapperToStoreDeletionVectors(
  sparkSession: SparkSession,
  hadoopConf: Configuration,
  table: Path,
  prefixLength: Int): Iterator[DeletionVectorData]
```

`createMapperToStoreDeletionVectors` [creates a deletion vector partition mapper function](#createDeletionVectorMapper) with the callback function (`callbackFn`) to [storeBitmapAndGenerateResult](#storeBitmapAndGenerateResult).

---

`createMapperToStoreDeletionVectors` is used when:

* `DeletionVectorSet` is requested to [build deletion vectors](DeletionVectorSet.md#computeResult) (and [bitmapStorageMapper](DeletionVectorSet.md#bitmapStorageMapper))

### createDeletionVectorMapper { #createDeletionVectorMapper }

```scala
createDeletionVectorMapper[InputT <: Sizing, OutputT](
  sparkSession: SparkSession,
  hadoopConf: Configuration,
  table: Path,
  prefixLength: Int)
  (callbackFn: (DeletionVectorMapperContext, InputT) => OutputT): Iterator[InputT] => Iterator[OutputT]
```

`createDeletionVectorMapper`...FIXME

`createDeletionVectorMapper` [creates a new DeletionVectorStore](DeletionVectorStore.md#createInstance).

`createDeletionVectorMapper`...FIXME

### storeBitmapAndGenerateResult { #storeBitmapAndGenerateResult }

```scala
storeBitmapAndGenerateResult(
  ctx: DeletionVectorMapperContext,
  row: DeletionVectorData): DeletionVectorResult
```

`storeBitmapAndGenerateResult`...FIXME

`storeBitmapAndGenerateResult` [creates a StoredBitmap](StoredBitmap.md#create) to [load the deletion vector](StoredBitmap.md#load).

`storeBitmapAndGenerateResult`...FIXME

### storeSerializedBitmap { #storeSerializedBitmap }

```scala
storeSerializedBitmap(
  ctx: DeletionVectorMapperContext,
  bitmapData: Array[Byte],
  cardinality: Long): DeletionVectorDescriptor
```

`storeSerializedBitmap`...FIXME
