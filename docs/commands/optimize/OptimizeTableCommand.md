# OptimizeTableCommand

`OptimizeTableCommand` is an [OptimizeTableCommandBase](OptimizeTableCommandBase.md).

## Creating Instance

`OptimizeTableCommand` takes the following to be created:

* <span id="path"> Table Path
* <span id="tableId"> `TableIdentifier`
* <span id="partitionPredicate"> Partition Predicate (optional)
* <span id="zOrderBy"> `zOrderBy` attributes

`OptimizeTableCommand` is created when:

* `DeltaSqlAstBuilder` is requested to [parse OPTIMIZE SQL statement](../../sql/DeltaSqlAstBuilder.md#visitOptimizeTable)
* `DeltaOptimizeBuilder` is requested to [execute](../../DeltaOptimizeBuilder.md#execute)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` [gets the DeltaLog](../DeltaCommand.md#getDeltaLog) of the Delta table (by the [path](#path) or [tableId](#tableId)).

In the end, `run` creates an [OptimizeExecutor](OptimizeExecutor.md) that is in turn requested to [optimize](OptimizeExecutor.md#optimize).

---

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

## <span id="LeafRunnableCommand"> LeafRunnableCommand

`OptimizeTableCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)).
