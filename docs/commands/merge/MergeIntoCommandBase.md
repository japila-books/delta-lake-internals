# MergeIntoCommandBase

`MergeIntoCommandBase` is an [extension](#contract) of the `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) abstraction for [merge delta commands](#implementations).

## Contract (Subset)

### runMerge { #runMerge }

```scala
runMerge(
  spark: SparkSession): Seq[Row]
```

See:

* [MergeIntoCommand](MergeIntoCommand.md#runMerge)

Used when:

* `MergeIntoCommandBase` is requested to [run](#run)

## Implementations

* [MergeIntoCommand](MergeIntoCommand.md)

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

## Special Columns

## _row_dropped_ { #ROW_DROPPED_COL }

`_row_dropped_` is used when:

* FIXME
