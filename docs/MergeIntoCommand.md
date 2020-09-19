# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](DeltaCommand.md).

`MergeIntoCommand` is a logical command (Spark SQL's [RunnableCommand](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/RunnableCommand/)).

## Creating Instance

`MergeIntoCommand` takes the following to be created:

* <span id="source"> Source Data (`LogicalPlan`)
* <span id="target"> Target Data (`LogicalPlan`)
* <span id="targetFileIndex"> [TahoeFileIndex](TahoeFileIndex.md)
* <span id="condition"> Condition Expression
* <span id="matchedClauses"> Matched Clauses (`Seq[DeltaMergeIntoMatchedClause]`)
* <span id="notMatchedClause"> Optional Non-Matched Clause (`Option[DeltaMergeIntoInsertClause]`)
* <span id="migratedSchema"> Migrated Schema

`MergeIntoCommand` is created when [PreprocessTableMerge](PreprocessTableMerge.md) logical resolution rule is executed (on a [DeltaMergeInto](DeltaMergeInto.md) logical command).

## <span id="run"> Executing Command

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run`...FIXME

`run` is part of the `RunnableCommand` ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/RunnableCommand/)) abstraction.

### <span id="writeAllChanges"> writeAllChanges

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile]): Seq[AddFile]
```

`writeAllChanges`...FIXME

`writeAllChanges` is used when `MergeIntoCommand` is requested to [run](#run).

### <span id="findTouchedFiles"> findTouchedFiles

```scala
findTouchedFiles(
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile]): LogicalPlan
```

`findTouchedFiles`...FIXME

`findTouchedFiles` is used when `MergeIntoCommand` is requested to [run](#run).

### <span id="buildTargetPlanWithFiles"> buildTargetPlanWithFiles

```scala
buildTargetPlanWithFiles(
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile]): LogicalPlan
```

`buildTargetPlanWithFiles`...FIXME

`buildTargetPlanWithFiles` is used when `MergeIntoCommand` is requested to [run](#run) (via [findTouchedFiles](#findTouchedFiles) and [writeAllChanges](#writeAllChanges)).
