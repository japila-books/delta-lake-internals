# OptimizeTableCommand

`OptimizeTableCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)).

## Creating Instance

`OptimizeTableCommand` takes the following to be created:

* <span id="path"> Table Path
* <span id="tableId"> `TableIdentifier`
* <span id="partitionPredicate"> Partition Predicate (optional)

`OptimizeTableCommand` is created when:

* `DeltaSqlAstBuilder` is requested to [parse OPTIMIZE SQL statement](../../sql/DeltaSqlAstBuilder.md#visitOptimizeTable)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` [gets the DeltaLog](../DeltaCommand.md#getDeltaLog) of the Delta table (by the [path](#path) or [tableId](#tableId)).

In the end, `run` creates an [OptimizeExecutor](OptimizeExecutor.md) that is in turn requested to [optimize](OptimizeExecutor.md#optimize).

---

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.
