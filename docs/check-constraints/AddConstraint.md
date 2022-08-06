# AddConstraint

`AddConstraint` is a `TableChange` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableChange)) of [AlterTableAddConstraint](AlterTableAddConstraint.md) command.

## Creating Instance

`AddConstraint` takes the following to be created:

* <span id="constraintName"> Constraint Name
* <span id="expr"> Constraint SQL Expression (text)

`AddConstraint` is created when:

* `AlterTableAddConstraint` command is requested for the [table changes](AlterTableAddConstraint.md#changes)

## Query Execution

`AddConstraint` is resolved to [AlterTableAddConstraintDeltaCommand](../commands/alter/AlterTableAddConstraintDeltaCommand.md) and immediately executed when `DeltaCatalog` is requested to [alter a delta table](../DeltaCatalog.md#alterTable).
