---
title: DeltaFileOperations
---

# DeltaFileOperations Utilities

## listUsingLogStore { #listUsingLogStore }

```scala
listUsingLogStore(
  logStore: LogStore,
  subDirs: Iterator[String],
  recurse: Boolean,
  hiddenFileNameFilter: String => Boolean): Iterator[SerializableFileStatus]
```

`listUsingLogStore`...FIXME

`listUsingLogStore` is used when:

* `DeltaFileOperations` utility is used to [recurseDirectories](#recurseDirectories), [recursiveListDirs](#recursiveListDirs) and [localListDirs](#localListDirs)

## localListDirs { #localListDirs }

```scala
localListDirs(
  spark: SparkSession,
  dirs: Seq[String],
  recursive: Boolean = true,
  fileFilter: String => Boolean = defaultHiddenFileFilter): Seq[SerializableFileStatus]
```

`localListDirs`...FIXME

`localListDirs` seems not used.

## makePathsAbsolute { #makePathsAbsolute }

```scala
makePathsAbsolute(
  qualifiedTablePath: String,
  files: Dataset[AddFile]): Dataset[AddFile]
```

`makePathsAbsolute`...FIXME

---

`makePathsAbsolute` is used when:

* `CloneTableBaseUtils` is requested to [handleNewDataFiles](commands/clone/CloneTableBaseUtils.md#handleNewDataFiles)

## recurseDirectories { #recurseDirectories }

```scala
recurseDirectories(
  logStore: LogStore,
  filesAndDirs: Iterator[SerializableFileStatus],
  hiddenFileNameFilter: String => Boolean): Iterator[SerializableFileStatus]
```

`recurseDirectories`...FIXME

`recurseDirectories` is used when:

* `DeltaFileOperations` utility is used to [listUsingLogStore](#listUsingLogStore) and [recursiveListDirs](#recursiveListDirs)

## recursiveListDirs { #recursiveListDirs }

```scala
recursiveListDirs(
  spark: SparkSession,
  subDirs: Seq[String],
  hadoopConf: Broadcast[SerializableConfiguration],
  hiddenFileNameFilter: String => Boolean = defaultHiddenFileFilter,
  fileListingParallelism: Option[Int] = None): Dataset[SerializableFileStatus]
```

`recursiveListDirs`...FIXME

`recursiveListDirs` is used when:

* `ManualListingFileManifest` is requested to [doList](commands/convert/ManualListingFileManifest.md#doList)
* `VacuumCommand` utility is used to [gc](commands/vacuum/VacuumCommand.md#gc)

## tryDeleteNonRecursive { #tryDeleteNonRecursive }

```scala
tryDeleteNonRecursive(
  fs: FileSystem,
  path: Path,
  tries: Int = 3): Boolean
```

`tryDeleteNonRecursive`...FIXME

`tryDeleteNonRecursive` is used when:

* `VacuumCommandImpl` is requested to [delete](commands/vacuum/VacuumCommandImpl.md#delete)
