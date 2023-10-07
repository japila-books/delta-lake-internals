# DeletionVectorWriter

## createMapperToStoreDeletionVectors { #createMapperToStoreDeletionVectors }

```scala
createMapperToStoreDeletionVectors(
  sparkSession: SparkSession,
  hadoopConf: Configuration,
  table: Path,
  prefixLength: Int): Iterator[DeletionVectorData]
```

`createMapperToStoreDeletionVectors`...FIXME

---

`createMapperToStoreDeletionVectors` is used when:

* `DeletionVectorSet` is requested to [bitmapStorageMapper](DeletionVectorSet.md#bitmapStorageMapper)

### storeBitmapAndGenerateResult { #storeBitmapAndGenerateResult }

```scala
storeBitmapAndGenerateResult(
  ctx: DeletionVectorMapperContext,
  row: DeletionVectorData): DeletionVectorResult
```

`storeBitmapAndGenerateResult`...FIXME

### storeSerializedBitmap { #storeSerializedBitmap }

```scala
storeSerializedBitmap(
  ctx: DeletionVectorMapperContext,
  bitmapData: Array[Byte],
  cardinality: Long): DeletionVectorDescriptor
```

`storeSerializedBitmap`...FIXME
