# DeletionVectorDescriptor

`DeletionVectorDescriptor` describes a [deletion vector](index.md) attached to a file action.

## Creating Instance

`DeletionVectorDescriptor` takes the following to be created:

* <span id="storageType"> storageType
* <span id="pathOrInlineDv"> pathOrInlineDv
* <span id="offset"> offset
* <span id="sizeInBytes"> sizeInBytes
* <span id="cardinality"> cardinality
* <span id="maxRowIndex"> maxRowIndex

`DeletionVectorDescriptor` is created using the following utilities:

* [onDiskWithRelativePath](#onDiskWithRelativePath)
* [onDiskWithAbsolutePath](#onDiskWithAbsolutePath)
* [inlineInLog](#inlineInLog)
* [EMPTY](#EMPTY)

## EMPTY { #EMPTY }

```scala
EMPTY: DeletionVectorDescriptor
```

`EMPTY` is an empty deletion vector (`DeletionVectorDescriptor`) with the following:

Property | Value
---------|------
 [storageType](#storageType) | `i`
 [pathOrInlineDv](#pathOrInlineDv) | (empty)
 [sizeInBytes](#sizeInBytes) | 0
 [cardinality](#cardinality) | 0

---

`EMPTY` is used when:

* `DeletionVectorWriter` is requested to [storeSerializedBitmap](DeletionVectorWriter.md#storeSerializedBitmap)
* `StoredBitmap` is requested for The  [stored bitmap of an empty deletion vector](StoredBitmap.md#EMPTY)

## onDiskWithRelativePath { #onDiskWithRelativePath }

```scala
onDiskWithRelativePath(
  id: UUID,
  randomPrefix: String = "",
  sizeInBytes: Int,
  cardinality: Long,
  offset: Option[Int] = None,
  maxRowIndex: Option[Long] = None): DeletionVectorDescriptor
```

`onDiskWithRelativePath` creates a `DeletionVectorDescriptor` with the following:

Property | Value
---------|------
 [storageType](#storageType) | `u`
 [pathOrInlineDv](#pathOrInlineDv) | [encodeUUID](#encodeUUID) with the given `id` and `randomPrefix`
 [offset](#offset) | The given `offset`
 [sizeInBytes](#sizeInBytes) | The given `sizeInBytes`
 [cardinality](#cardinality) | The given `cardinality`
 [maxRowIndex](#maxRowIndex) | The given `maxRowIndex`

---

`onDiskWithRelativePath` is used when:

* `DeletionVectorWriter` is requested to [storeSerializedBitmap](DeletionVectorWriter.md#storeSerializedBitmap)

## inlineInLog { #inlineInLog }

```scala
inlineInLog(
  data: Array[Byte],
  cardinality: Long): DeletionVectorDescriptor
```

`inlineInLog` creates a `DeletionVectorDescriptor` with the following:

Property | Value
---------|------
 [storageType](#storageType) | `i`
 [pathOrInlineDv](#pathOrInlineDv) | [encodeData](#encodeData) for the given `data`
 [sizeInBytes](#sizeInBytes) | The size of the given `data`
 [cardinality](#cardinality) | The given `cardinality`

---

`inlineInLog` is used when:

* `CDCReaderImpl` is requested to [generateFileActionsWithInlineDv](../change-data-feed/CDCReaderImpl.md#generateFileActionsWithInlineDv)

## onDiskWithAbsolutePath { #onDiskWithAbsolutePath }

```scala
onDiskWithAbsolutePath(
  path: String,
  sizeInBytes: Int,
  cardinality: Long,
  offset: Option[Int] = None,
  maxRowIndex: Option[Long] = None): DeletionVectorDescriptor
```

!!! note
    `onDiskWithAbsolutePath` is used for testing only.

## assembleDeletionVectorPath { #assembleDeletionVectorPath }

```scala
assembleDeletionVectorPath(
  targetParentPath: Path,
  id: UUID,
  prefix: String = ""): Path
```

`assembleDeletionVectorPath`...FIXME

---

`assembleDeletionVectorPath` is used when:

* `DeletionVectorDescriptor` is requested to [absolutePath](DeletionVectorDescriptor.md#absolutePath) (for the [uuid marker](#UUID_DV_MARKER))
* `DeletionVectorStoreUtils` is requested to [assembleDeletionVectorPathWithFileSystem](DeletionVectorStoreUtils.md#assembleDeletionVectorPathWithFileSystem)
