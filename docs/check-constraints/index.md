# CHECK Constraints

**CHECK Constraints** are [named SQL expressions](../constraints/Constraint.md#Check) that are used to enforce data quality at table level (at [write time](../TransactionalWrite.md#writeFiles)).

CHECK constraints are registered (_added_) using the following high-level operator:

* [ALTER TABLE ADD CONSTRAINT](../sql/index.md#ALTER-TABLE-ADD-CONSTRAINT) SQL statement

CHECK constraints are de-registered (_dropped_) using the following high-level operator:

* [ALTER TABLE DROP CONSTRAINT](../sql/index.md#ALTER-TABLE-DROP-CONSTRAINT) SQL statement

[DeltaCatalog](../DeltaCatalog.md) is responsible to manage CHECK constraints of a delta table (using [AddConstraint](AddConstraint.md) and [DropConstraint](DropConstraint.md)).

## <span id="minWriterVersion"><span id="Protocol"> Protocol

CHECK constraints require the [Minimum Writer Version](../Protocol.md#minWriterVersion) (of a [delta table](../Protocol.md)) to be at least [3](../Protocol.md#requiredMinimumProtocol-constraints).

## <span id="delta.constraints"> delta.constraints

CHECK constraints are [stored](../constraints/Constraints.md#getCheckConstraints) in the [table configuration](../Metadata.md#configuration) (of a [table metadata](../Metadata.md)) as `delta.constraints.`-keyed entries.

## AlterTableCommands, DeltaCatalog and Delta Commands

At execution, `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand)) is planned as a `AlterTableExec` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableExec)) that requests the active `TableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableCatalog)) to alter a table.

That is when [DeltaCatalog](../DeltaCatalog.md) kicks in to [alter a table](../DeltaCatalog.md#alterTable) as [AlterTableAddConstraintDeltaCommand](../commands/alter/AlterTableAddConstraintDeltaCommand.md).
