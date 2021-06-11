# DeltaInvariantCheckerExec Unary Physical Operator

`DeltaInvariantCheckerExec` is an `UnaryExecNode` ([Spark SQL]({{ book.spark_sql }}/physical-operators/UnaryExecNode)) to [assert constraints](#doExecute).

## Creating Instance

`DeltaInvariantCheckerExec` takes the following to be created:

* <span id="child"> Child Physical Plan ([SparkPlan]({{ book.spark_sql }}/physical-operators/SparkPlan))
* <span id="constraints"> [Constraint](Constraint.md)s

`DeltaInvariantCheckerExec` is created when:

* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles)
* [DeltaInvariantCheckerStrategy](DeltaInvariantCheckerStrategy.md) execution planning strategy is executed

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the `SparkPlan` ([Spark SQL]({{ book.spark_sql }}/physical-operators/SparkPlan#doExecute)) abstraction.

`doExecute` [builds invariants](#buildInvariantChecks) for the given [constraints](#constraints) and applies (_evaluates_) them to every row from the [child physical operator](#child).

`doExecute` simply requests the [child physical operator](#child) to execute (and becomes a noop) for no [constraints](#constraints).

### <span id="buildInvariantChecks"> Building Invariants

```scala
buildInvariantChecks(
  output: Seq[Attribute],
  constraints: Seq[Constraint],
  spark: SparkSession): Seq[CheckDeltaInvariant]
```

`buildInvariantChecks` converts the given [Constraint](Constraint.md)s into [CheckDeltaInvariant](CheckDeltaInvariant.md)s.
