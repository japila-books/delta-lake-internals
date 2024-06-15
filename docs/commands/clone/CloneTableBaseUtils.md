# CloneTableBaseUtils

## handleNewDataFiles { #handleNewDataFiles }

```scala
handleNewDataFiles(
  opName: String,
  datasetOfNewFilesToAdd: Dataset[AddFile],
  qualifiedSourceTableBasePath: String,
  destTable: DeltaLog): Dataset[AddFile]
```

`handleNewDataFiles`...FIXME

---

`handleNewDataFiles` is used when:

* `CloneTableBase` is requested to [handleClone](CloneTableBase.md#handleClone)
