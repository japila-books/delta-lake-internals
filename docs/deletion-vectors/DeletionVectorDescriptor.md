# DeletionVectorDescriptor

`DeletionVectorDescriptor` describes a [deletion vector](index.md) attached to a file.

## Creating Instance

`DeletionVectorDescriptor` takes the following to be created:

* [Storage Type](#storageType)
* <span id="pathOrInlineDv"> Path or an inline deletion vector
* <span id="offset"> Offset
* <span id="sizeInBytes"> Size (in bytes)
* <span id="cardinality"> Cardinality
* <span id="maxRowIndex"> maxRowIndex

`DeletionVectorDescriptor` is created using the following utilities:

* [onDiskWithRelativePath](#onDiskWithRelativePath)
* [onDiskWithAbsolutePath](#onDiskWithAbsolutePath)
* [inlineInLog](#inlineInLog)
* [EMPTY](#EMPTY)

### <span id="PATH_DV_MARKER"><span id="INLINE_DV_MARKER"><span id="UUID_DV_MARKER"> Storage Type { #storageType }

```scala
storageType: String
```

`DeletionVectorDescriptor` is given a **storage type** that indicates how the deletion vector is stored.

The storage types of a deletion vector can be one of the following:

Storage Type | Format | Description
-|-|-
 `p`(ath) | `<absolute path>` | Stored in a file that is available at an [absolute path](DeletionVectorDescriptor.md#pathOrInlineDv)
 `i`(nline) | `<base85 encoded bytes>` | Stored inline in the transaction log
 `u`(uid) | `<random prefix - optional><base85 encoded uuid>` | (UUID-based) Stored in a file with a [path relative to the data directory of a delta table](DeletionVectorDescriptor.md#pathOrInlineDv)

## Creating Empty Deletion Vector { #EMPTY }

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

## copyWithAbsolutePath { #copyWithAbsolutePath }

```scala
copyWithAbsolutePath(
  tableLocation: Path): DeletionVectorDescriptor
```

`copyWithAbsolutePath` creates a new copy of this `DeletionVectorDescriptor`.

For [uuid](#UUID_DV_MARKER) storage type, `copyWithAbsolutePath` replaces the following:

Attribute | New Value
-|-
 [Storage type](#storageType) | [p](#PATH_DV_MARKER)
 [Path](#pathOrInlineDv) | The [absolute path](#absolutePath) based on the given `tableLocation`

---

`copyWithAbsolutePath` is used when:

* `DeltaFileOperations` is requested to [makePathsAbsolute](../DeltaFileOperations.md#makePathsAbsolute)

## Absolute Path { #absolutePath }

```scala
absolutePath(
  tableLocation: Path): Path
```

`absolutePath`...FIXME

---

`absolutePath` is used when:

* `DeletionVectorDescriptor` is requested to [copyWithAbsolutePath](#copyWithAbsolutePath) (for [SHALLOW CLONE](../commands/clone/index.md) command)
* `DeletionVectorStoredBitmap` is requested for the [absolute path of this on-disk deletion vector](DeletionVectorStoredBitmap.md#onDiskPath)
* [VACUUM](../commands/vacuum/index.md) command is executed (and [getDeletionVectorRelativePath](../commands/vacuum/VacuumCommandImpl.md#getDeletionVectorRelativePath))

## assembleDeletionVectorPath { #assembleDeletionVectorPath }

```scala
assembleDeletionVectorPath(
  targetParentPath: Path,
  id: UUID,
  prefix: String = ""): Path
```

`assembleDeletionVectorPath` creates a new `Path` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) for the given `targetParentPath` and `fileName` (and the optional `prefix`).

---

`assembleDeletionVectorPath` is used when:

* `DeletionVectorDescriptor` is requested to [absolutePath](#absolutePath) (for the [uuid marker](#UUID_DV_MARKER))
* `DeletionVectorStoreUtils` is requested to [assembleDeletionVectorPathWithFileSystem](DeletionVectorStoreUtils.md#assembleDeletionVectorPathWithFileSystem)

## isOnDisk { #isOnDisk }

```scala
isOnDisk: Boolean
```

`isOnDisk` is the negation (_opposite_) of the [isInline](#isInline) flag.

---

`isOnDisk` is used when:

* `VacuumCommandImpl` is requested for the [path of an on-disk deletion vector](../commands/vacuum/VacuumCommandImpl.md#getDeletionVectorRelativePath)
* `DeletionVectorStoredBitmap` is requested to [isOnDisk](DeletionVectorStoredBitmap.md#isOnDisk)
* `StoredBitmap` utility is requested to [create a StoredBitmap](StoredBitmap.md#create)

## isInline { #isInline }

```scala
isInline: Boolean
```

`isInline` holds true for the [storageType](#storageType) being [i](#INLINE_DV_MARKER).

---

`isInline` is used when:

* `DeletionVectorDescriptor` is requested to [inlineData](#inlineData), [isOnDisk](#isOnDisk)
* `DeletionVectorStoredBitmap` is requested to [isInline](DeletionVectorStoredBitmap.md#isInline)
* `StoredBitmap` is requested to [inline](StoredBitmap.md#inline)
