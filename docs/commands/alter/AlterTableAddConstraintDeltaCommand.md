# AlterTableAddConstraintDeltaCommand

`AlterTableAddConstraintDeltaCommand` is an [AlterDeltaTableCommand](AlterDeltaTableCommand.md).

`AlterTableAddConstraintDeltaCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) and `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData)).

## Creating Instance

`AlterTableAddConstraintDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="name"> Constraint Name
* <span id="exprText"> Constraint SQL Expression (as a text)

`AlterTableAddConstraintDeltaCommand` is created when:

* `DeltaCatalog` is requested to [alter a delta table](../../DeltaCatalog.md#alterTable) (with [AddConstraint](../../constraints/AddConstraint.md) table changes)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run`...FIXME

`run` prints out the following INFO message to the logs:

```text
Checking that [constraint] is satisfied for existing data. This will require a full table scan.
```

`run` requests the `OptimisticTransaction` for the [DeltaLog](../../OptimisticTransaction.md#deltaLog) to create a `DataFrame` (for the snapshot).

`run` uses `where` operator and counts the rows that do not match the constraint.

With no rows violating the check constraint, `run` requests the `OptimisticTransaction` to [commit](../../OptimisticTransaction.md#commit) (with the new `Metadata` and a new [AddConstraint](../../constraints/AddConstraint.md)).

### <span id="run-AnalysisException"> AnalysisException

`run` throws an `AnalysisException` when one or more rows violate the new constraint:

```text
[num] rows in [tableName] violate the new CHECK constraint ([expr])
```
