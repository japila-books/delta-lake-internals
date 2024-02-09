# OptimizeTableCommand

`OptimizeTableCommand` is an [OptimizeTableCommandBase](OptimizeTableCommandBase.md) for the following high-level operators:

* [DeltaOptimizeBuilder.executeCompaction](../../DeltaOptimizeBuilder.md#executeCompaction)
* [DeltaOptimizeBuilder.executeZOrderBy](../../DeltaOptimizeBuilder.md#executeZOrderBy)
* [OPTIMIZE](../../sql/index.md#OPTIMIZE) SQL command
* [REORG TABLE](../reorg/index.md) SQL command

`OptimizeTableCommand` uses [OptimizeExecutor](OptimizeExecutor.md) to [optimize](OptimizeExecutor.md#optimize) (when [executed](#run)).

`OptimizeTableCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)).

## Creating Instance

`OptimizeTableCommand` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="userPartitionPredicates"> User-Defined Partition Predicates
* <span id="optimizeContext"> [DeltaOptimizeContext](DeltaOptimizeContext.md)
* <span id="zOrderBy"> `zOrderBy` attributes (aka _interleaveBy_ attributes)

`OptimizeTableCommand` is created when:

* `DeltaOptimizeBuilder` is requested to [execute](../../DeltaOptimizeBuilder.md#execute)
* `DeltaReorgTableCommand` is requested to [optimizeByReorg](../reorg/DeltaReorgTableCommand.md#optimizeByReorg)
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

`apply` creates an [OptimizeTableCommand](#creating-instance) for a delta table (based on the given `path` or `tableIdentifier`).

---

`apply` is used when:

* `DeltaSqlAstBuilder` is requested to [parse OPTIMIZE command](../../sql/DeltaSqlAstBuilder.md#visitOptimizeTable)

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` [extracts the delta table](#getDeltaTable) from the [child](#child) logical plan.

`run` [starts a transaction](../../DeltaTableV2.md#startTransaction) (for this [DeltaTableV2](../../DeltaTableV2.md)).

`run`...FIXME

`run` [validates the zOrderBy columns](OptimizeTableCommandBase.md#validateZorderByColumns) (that may throw `DeltaIllegalArgumentException` or `DeltaAnalysisException` exceptions and so break the command execution).

In the end, `run` creates an [OptimizeExecutor](OptimizeExecutor.md) to [run optimization](OptimizeExecutor.md#optimize) (with the given [userPartitionPredicates](#userPartitionPredicates), the [zOrderBy attributes](#zOrderBy)).

!!! note
    [isAutoCompact](OptimizeExecutor.md#isAutoCompact) flag is disabled (`false`).
