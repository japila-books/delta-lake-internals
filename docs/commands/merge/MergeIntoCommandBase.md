# MergeIntoCommandBase

## buildTargetPlanWithFiles { #buildTargetPlanWithFiles }

```scala
buildTargetPlanWithFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile],
  columnsToDrop: Seq[String]): LogicalPlan
```

`buildTargetPlanWithFiles`...FIXME

---

`buildTargetPlanWithFiles` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles) and [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)

### buildTargetPlanWithIndex { #buildTargetPlanWithIndex }

```scala
buildTargetPlanWithIndex(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  fileIndex: TahoeFileIndex,
  columnsToDrop: Seq[String]): LogicalPlan
```

`buildTargetPlanWithIndex`...FIXME
