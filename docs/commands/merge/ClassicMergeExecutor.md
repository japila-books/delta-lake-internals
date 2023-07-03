# ClassicMergeExecutor

`ClassicMergeExecutor` is an [extension](#contract) of the [MergeIntoCommandBase](MergeIntoCommandBase.md) abstraction for [merge commands](#implementations).

`ClassicMergeExecutor` is a [MergeIntoMaterializeSource](MergeIntoMaterializeSource.md)

`ClassicMergeExecutor` is a [MergeOutputGeneration](MergeOutputGeneration.md)

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
