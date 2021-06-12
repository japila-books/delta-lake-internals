# Table Constraints

Delta Lake allows for table constraints using the following SQL statements:

* [ALTER TABLE ADD CONSTRAINT](../sql/index.md#ALTER-TABLE-ADD-CONSTRAINT)
* [ALTER TABLE DROP CONSTRAINT](../sql/index.md#ALTER-TABLE-DROP-CONSTRAINT)

Table constraints can be one of the following:

* [Column-Level Invariants](Invariants.md#getFromSchema)
* [Table-Level Check Constraints](Constraints.md#getCheckConstraints)
* [Generated Columns Constraints](../GeneratedColumn.md#addGeneratedColumnsOrReturnConstraints)

Column-level invariants require [Protocol](../Protocol.md) to be at least `2` for the writer version.

[DeltaCatalog](../DeltaCatalog.md) is used to add or remove constraints of a delta table (using [AddConstraint](AddConstraint.md) and [DropConstraint](DropConstraint.md)).

## References

* [Constraints](https://docs.databricks.com/delta/delta-constraints.html)
