# IndexedChangeFileSeq

## Creating Instance

`IndexedChangeFileSeq` takes the following to be created:

* <span id="fileActionsItr"> `IndexedFile`s (`Iterator[IndexedFile]`)
* <span id="isInitialSnapshot"> `isInitialSnapshot` flag

`IndexedChangeFileSeq` is created when:

* `DeltaSourceCDCSupport` is requested to [getFileChangesForCDC](change-data-feed/DeltaSourceCDCSupport.md#getFileChangesForCDC)

## <span id="filterFiles"> filterFiles

```scala
filterFiles(
  fromVersion: Long,
  fromIndex: Long,
  limits: Option[AdmissionLimits],
  endOffset: Option[DeltaSourceOffset] = None): Iterator[IndexedFile]
```

`filterFiles`...FIXME

`filterFiles` is used when:

* `DeltaSourceCDCSupport` is requested to [getFileChangesForCDC](change-data-feed/DeltaSourceCDCSupport.md#getFileChangesForCDC)

## <span id="isValidIndexedFile"> isValidIndexedFile

```scala
isValidIndexedFile(
  indexedFile: IndexedFile,
  fromVersion: Long,
  fromIndex: Long,
  endOffset: Option[DeltaSourceOffset]): Boolean
```

`isValidIndexedFile`...FIXME

`isValidIndexedFile` is used when:

* `IndexedChangeFileSeq` is requested to [filterFiles](#filterFiles)

### <span id="moreThanFrom"> moreThanFrom

```scala
moreThanFrom(
  indexedFile: IndexedFile,
  fromVersion: Long,
  fromIndex: Long): Boolean
```

`moreThanFrom`...FIXME
