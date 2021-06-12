# AddConstraint

`AddConstraint` is a `TableChange` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableChange)).

## Creating Instance

`AddConstraint` takes the following to be created:

* <span id="constraintName"> Constraint Name
* <span id="expr"> Expression

`AddConstraint` is created when:

* `DeltaAnalysis` logical resolution rule is [executed](../DeltaAnalysis.md#apply) (on a logical query plan with [AlterTableAddConstraintStatement](AlterTableAddConstraintStatement.md))
