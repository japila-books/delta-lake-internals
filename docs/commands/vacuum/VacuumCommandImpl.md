# VacuumCommandImpl

`VacuumCommandImpl` is a [DeltaCommand](../DeltaCommand.md).

!!! note
    `VacuumCommandImpl` is a Scala trait just to let Databricks provide a commercial version of vacuum command.

## delete { #delete }

```scala
delete(
  diff: Dataset[String],
  spark: SparkSession,
  basePath: String,
  hadoopConf: Broadcast[SerializableConfiguration],
  parallel: Boolean): Long
```

`delete`...FIXME

---

`delete` is used when:

* `VacuumCommand` is requested to [gc](VacuumCommand.md#gc)

## getValidRelativePathsAndSubdirs { #getValidRelativePathsAndSubdirs }

```scala
getValidRelativePathsAndSubdirs(
  action: FileAction,
  fs: FileSystem,
  basePath: Path,
  relativizeIgnoreError: Boolean): Seq[String]
```

`getValidRelativePathsAndSubdirs`...FIXME

---

`getValidRelativePathsAndSubdirs` is used when:

* `VacuumCommand` is requested to [gc](VacuumCommand.md#gc) (and [getValidFilesFromSnapshot](VacuumCommand.md#getValidFilesFromSnapshot))

### getDeletionVectorRelativePath { #getDeletionVectorRelativePath }

```scala
getDeletionVectorRelativePath(
  action: FileAction): Option[Path]
```

`getDeletionVectorRelativePath`...FIXME
