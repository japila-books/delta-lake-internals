# ActiveOptimisticTransactionRule Logical Optimization Rule

`ActiveOptimisticTransactionRule` is a logical optimization rule ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)).

## Creating Instance

`ActiveOptimisticTransactionRule` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`ActiveOptimisticTransactionRule` is created when:

* `DeltaSparkSessionExtension` is requested to [inject extensions](DeltaSparkSessionExtension.md#apply)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule#apply)) abstraction.

`apply`...FIXME
