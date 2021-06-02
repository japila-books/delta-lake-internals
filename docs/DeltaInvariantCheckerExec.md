# DeltaInvariantCheckerExec Unary Physical Operator

`DeltaInvariantCheckerExec` is an `UnaryExecNode` ([Spark SQL]({{ book.spark_sql }}/physical-operators/UnaryExecNode)).

## Creating Instance

`DeltaInvariantCheckerExec` takes the following to be created:

* <span id="child"> Child Physical Plan ([SparkPlan]({{ book.spark_sql }}/physical-operators/SparkPlan))
* <span id="constraints"> [Constraint](Constraint.md)s

`DeltaInvariantCheckerExec` is created when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)
* [DeltaInvariantCheckerStrategy](DeltaInvariantCheckerStrategy.md) execution planning strategy is executed
