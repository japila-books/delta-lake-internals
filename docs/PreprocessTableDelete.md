# PreprocessTableDelete Logical Resolution Rule

`PreprocessTableDelete` is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to [resolve DeltaDelete commands](#apply) in a logical query plan into [DeleteCommand](commands/DeleteCommand.md)s.

`PreprocessTableDelete` is _installed_ (injected) into a `SparkSession` using [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md).

## Creating Instance

`PreprocessTableDelete` takes the following to be created:

* <span id="conf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf/))

`PreprocessTableDelete` is created when:

* [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md) is executed (and registers Delta SQL support)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)) abstraction.

apply resolves (_replaces_) [DeltaDelete](commands/DeltaDelete.md) logical commands (in a logical query plan) into [DeleteCommand](commands/DeleteCommand.md)s.

### <span id="toCommand"> toCommand

```scala
toCommand(
  d: DeltaDelete): DeleteCommand
```

`toCommand`...FIXME
