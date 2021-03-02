# DeltaAnalysis Logical Resolution Rule

`DeltaAnalysis` is a logical resolution rule ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)).

## Creating Instance

`DeltaAnalysis` takes the following to be created:

* <span id="session"> `SparkSession`
* <span id="conf"> `SQLConf`

`DeltaAnalysis` is created when:

* `DeltaSparkSessionExtension` is requested to [inject Delta extensions](DeltaSparkSessionExtension.md)

## Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/#apply)) abstraction.

`apply` resolves logical operators.

### <span id="AlterTableAddConstraintStatement"> AlterTableAddConstraintStatement

`apply` creates an `AlterTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTable)) logical command with an `AddConstraint` table change.

### <span id="AlterTableDropConstraintStatement"> AlterTableDropConstraintStatement

`apply` creates an `AlterTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTable)) logical command with an `DropConstraint` table change.

### <span id="AppendDelta"> AppendDelta

### <span id="DataSourceV2Relation"> DataSourceV2Relation

### <span id="DeleteFromTable"> DeleteFromTable

### <span id="DeltaTable"> DeltaTable

### <span id="MergeIntoTable"> MergeIntoTable

### <span id="OverwriteDelta"> OverwriteDelta

### <span id="UpdateTable"> UpdateTable
