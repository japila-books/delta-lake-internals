# ClassicMergeExecutor

`ClassicMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [merge command](index.md).

`ClassicMergeExecutor` is a [MergeIntoMaterializeSource](MergeIntoMaterializeSource.md)

`ClassicMergeExecutor` is also a [MergeIntoCommandBase](MergeIntoCommandBase.md).

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): (Seq[AddFile], DeduplicateCDFDeletes)
```

`findTouchedFiles`...FIXME

---

`findTouchedFiles` is used when:

* `MergeIntoCommand` is requested to [runMerge](MergeIntoCommand.md#runMerge)

## writeAllChanges { #writeAllChanges }

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile],
  deduplicateCDFDeletes: DeduplicateCDFDeletes): Seq[FileAction]
```

`writeAllChanges`...FIXME

---

`writeAllChanges` is used when:

* `MergeIntoCommand` is requested to [runMerge](MergeIntoCommand.md#runMerge)
