# PreprocessTableUpdate Logical Resolution Rule

`PreprocessTableUpdate` is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to [resolve DeltaUpdateTable commands](#apply) in a logical query plan into [UpdateCommand](commands/update/UpdateCommand.md)s.

`PreprocessTableUpdate` is _installed_ (injected) into a `SparkSession` using [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md).

## Creating Instance

`PreprocessTableUpdate` takes the following to be created:

* <span id="sqlConf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf/))

`PreprocessTableUpdate` is created when:

* [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md) is executed (and registers Delta SQL support)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)) abstraction.

apply resolves (_replaces_) [DeltaUpdateTable](commands/update/DeltaUpdateTable.md) logical commands (in a logical query plan) into [UpdateCommand](commands/update/UpdateCommand.md)s.

### <span id="toCommand"> toCommand

```scala
toCommand(
  update: DeltaUpdateTable): UpdateCommand
```

`toCommand`...FIXME
