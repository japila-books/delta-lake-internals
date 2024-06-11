# StoredBitmap

## Create StoredBitmap { #create }

```scala
create(
  dvDescriptor: DeletionVectorDescriptor,
  tablePath: Path): StoredBitmap
```

`create` creates a new [DeletionVectorStoredBitmap](DeletionVectorStoredBitmap.md) (possibly with the given `tablePath` for an [on-disk deletion vector](DeletionVectorDescriptor.md#isOnDisk)).

---

`create` is used when:

* `DeletionVectorWriter` is requested to [storeBitmapAndGenerateResult](DeletionVectorWriter.md#storeBitmapAndGenerateResult)
* `RowIndexMarkingFiltersBuilder` is requested to [create a RowIndexFilter](RowIndexMarkingFiltersBuilder.md#createInstance)
* `DeletionVectorStore` is requested to [read a deletion vector](DeletionVectorStore.md#read)
