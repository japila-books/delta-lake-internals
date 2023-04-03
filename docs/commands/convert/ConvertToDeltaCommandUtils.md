# ConvertToDeltaCommandUtils

## createAddFile { #createAddFile }

```scala
createAddFile(
  targetFile: ConvertTargetFile,
  basePath: Path,
  fs: FileSystem,
  conf: SQLConf,
  partitionSchema: Option[StructType],
  useAbsolutePath: Boolean = false): AddFile
```

`createAddFile`...FIXME

---

`createAddFile` is used when:

* `CloneParquetSource` is requested for the [allFiles](../clone/CloneParquetSource.md#allFiles)
* `ConvertToDeltaCommandBase` is requested to [createDeltaActions](ConvertToDeltaCommand.md#createDeltaActions)
