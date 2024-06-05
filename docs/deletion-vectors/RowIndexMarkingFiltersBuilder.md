# RowIndexMarkingFiltersBuilder

`RowIndexMarkingFiltersBuilder` is an [abstraction](#contract) of [filter builders](#implementations) that can build [RowIndexFilter](RowIndexFilter.md)s for [empty](#getFilterForEmptyDeletionVector) and [non-empty deletion vectors](#getFilterForNonEmptyDeletionVector).

## Contract

### getFilterForEmptyDeletionVector { #getFilterForEmptyDeletionVector }

```scala
getFilterForEmptyDeletionVector(): RowIndexFilter
```

Creates a [RowIndexFilter](RowIndexFilter.md) for an empty deletion vector

Used when:

* `RowIndexMarkingFiltersBuilder` is requested to [create a RowIndexFilter](#createInstance)

### getFilterForNonEmptyDeletionVector { #getFilterForNonEmptyDeletionVector }

```scala
getFilterForNonEmptyDeletionVector(
  bitmap: RoaringBitmapArray): RowIndexFilter
```

Creates a [RowIndexFilter](RowIndexFilter.md) for the given deletion vector (bitmap)

Used when:

* `RowIndexMarkingFiltersBuilder` is requested to [create a RowIndexFilter](#createInstance)

## Implementations

* `DropMarkedRowsFilter`
* `KeepMarkedRowsFilter`

## Create RowIndexFilter { #createInstance }

```scala
createInstance(
  deletionVector: DeletionVectorDescriptor,
  hadoopConf: Configuration,
  tablePath: Option[Path]): RowIndexFilter
```

With [cardinality](DeletionVectorDescriptor.md#cardinality) of the given [DeletionVectorDescriptor](DeletionVectorDescriptor.md) as `0`,`createInstance` [getFilterForEmptyDeletionVector](#getFilterForEmptyDeletionVector).

Otherwise, for a non-empty deletion vector, `createInstance` creates a [DeletionVectorStore](DeletionVectorStore.md#createInstance) and a [StoredBitmap](StoredBitmap.md#create) to [load the deletion vector (bitmap)](StoredBitmap.md#load). In the end, `createInstance` [getFilterForNonEmptyDeletionVector](#getFilterForNonEmptyDeletionVector) for the deletion vector.

---

`createInstance` is used when:

* `DeltaParquetFileFormat` is requested to [iteratorWithAdditionalMetadataColumns](../DeltaParquetFileFormat.md#iteratorWithAdditionalMetadataColumns)
