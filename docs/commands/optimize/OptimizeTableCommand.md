# OptimizeTableCommand

`OptimizeTableCommand` is a [OptimizeTableCommandBase](OptimizeTableCommandBase.md) for the following high-level operators:

* [DeltaOptimizeBuilder.executeCompaction](../../DeltaOptimizeBuilder.md#executeCompaction)
* [DeltaOptimizeBuilder.executeZOrderBy](../../DeltaOptimizeBuilder.md#executeZOrderBy)
* [OPTIMIZE](../../sql/index.md#OPTIMIZE) SQL command
* [REORG TABLE](../reorg/index.md) SQL command

`OptimizeTableCommand` uses [OptimizeExecutor](OptimizeExecutor.md) to [optimize](OptimizeExecutor.md#optimize) (when [executed](#run)).

## Creating Instance

`OptimizeTableCommand` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="userPartitionPredicates"> User-Defined Partition Predicates
* <span id="optimizeContext"> [DeltaOptimizeContext](DeltaOptimizeContext.md)
* <span id="zOrderBy"> `zOrderBy` attributes (aka _interleaveBy_ attributes)

`OptimizeTableCommand` is created when:

* `DeltaOptimizeBuilder` is requested to [execute](../../DeltaOptimizeBuilder.md#execute)
* `DeltaReorgTableCommand` is [executed](../reorg/DeltaReorgTableCommand.md#run)
* `OptimizeTableCommand` is requested to [apply](#apply)

## Creating OptimizeTableCommand { #apply }

```scala
apply(
  path: Option[String],
  tableIdentifier: Option[TableIdentifier],
  userPartitionPredicates: Seq[String],
  optimizeContext: DeltaOptimizeContext = DeltaOptimizeContext())(
  zOrderBy: Seq[UnresolvedAttribute]): OptimizeTableCommand
```

`apply`...FIXME

---

`apply` is used when:

* `DeltaSqlAstBuilder` is requested to [parse OPTIMIZE command](../../sql/DeltaSqlAstBuilder.md#visitOptimizeTable)

## Executing Command { #run }

??? note "Signature"
    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` [gets the DeltaLog](../DeltaCommand.md#getDeltaLog) of the delta table (by the given [path](#path) or [TableIdentifier](#tableId)).

`run` [validates the zOrderBy columns](OptimizeTableCommandBase.md#validateZorderByColumns) (that may throw `DeltaIllegalArgumentException` or `DeltaAnalysisException` exceptions and so break the command execution).

In the end, `run` creates an [OptimizeExecutor](OptimizeExecutor.md) for [optimize](OptimizeExecutor.md#optimize) (with the given [userPartitionPredicates](#userPartitionPredicates), the [zOrderBy attributes](#zOrderBy))
