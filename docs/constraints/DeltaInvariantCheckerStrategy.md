# DeltaInvariantCheckerStrategy Execution Planning Strategy

`DeltaInvariantCheckerStrategy` is a `SparkStrategy` ([Spark SQL]({{ book.spark_sql }}/execution-planning-strategies/SparkStrategy/)) to [plan](#apply) a [DeltaInvariantChecker](DeltaInvariantChecker.md) unary logical operator (with constraints attached) into a [DeltaInvariantCheckerExec](DeltaInvariantCheckerExec.md) for execution.

!!! danger
    `DeltaInvariantCheckerStrategy` does not seem to be used at all.

## Creating Instance

`DeltaInvariantCheckerStrategy` is a Scala object and takes no input arguments to be created.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` is part of the `SparkStrategy` ([Spark SQL]({{ book.spark_sql }}/execution-planning-strategies/SparkStrategy/#apply)) abstraction.

For a given [DeltaInvariantChecker](DeltaInvariantChecker.md) unary logical operator with constraints attached, `apply` creates a [DeltaInvariantCheckerExec](DeltaInvariantCheckerExec.md) unary physical operator. Otherwise, `apply` does nothing (_noop_).
