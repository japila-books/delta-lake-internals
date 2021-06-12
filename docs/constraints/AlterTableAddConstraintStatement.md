# AlterTableAddConstraintStatement

`AlterTableAddConstraintStatement` is a `ParsedStatement` ([Spark SQL]({{ book.spark_sql }}/logical-operators/ParsedStatement)) for [ALTER TABLE ADD CONSTRAINT](../sql/index.md#ALTER-TABLE-ADD-CONSTRAINT) SQL statement.

## Creating Instance

`AlterTableAddConstraintStatement` takes the following to be created:

* <span id="tableName"> Table Name
* <span id="constraintName"> Constraint Name
* <span id="expr"> Expression

## Analysis Phase

`AlterTableAddConstraintStatement` is resolved by [DeltaAnalysis](../DeltaAnalysis.md#AlterTableAddConstraintStatement) logical resolution rule.
