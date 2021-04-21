# PreprocessTableMerge Logical Resolution Rule

`PreprocessTableMerge` is a post-hoc logical resolution rule ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule)) to [resolve DeltaMergeInto logical commands](#apply) (in a logical query plan) into [MergeIntoCommand](commands/MergeIntoCommand.md)s.

`PreprocessTableMerge` is injected (_installed_) into a `SparkSession` using [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md).

## Creating Instance

`PreprocessTableMerge` takes the following to be created:

* <span id="conf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf))

`PreprocessTableMerge` is created when:

* `DeltaSparkSessionExtension` is requested to [register Delta SQL support](DeltaSparkSessionExtension.md)
* `DeltaMergeBuilder` is requested to [execute](commands/DeltaMergeBuilder.md#execute)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule#apply)) abstraction.

In summary, `apply` resolves (_replaces_) [DeltaMergeInto](commands/DeltaMergeInto.md) logical commands (in a logical query plan) into corresponding [MergeIntoCommand](commands/MergeIntoCommand.md)s.

Internally, `apply`...FIXME
