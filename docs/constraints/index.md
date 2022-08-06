# Table Constraints

Table constraints can be one of the following:

* [Column-Level Invariants](Invariants.md#getFromSchema)
* [Table-Level CHECK Constraints](../check-constraints/index.md)
* [Generated Columns Constraints](../generated-columns/GeneratedColumn.md#addGeneratedColumnsOrReturnConstraints)

Column-level invariants require [Protocol](../Protocol.md) to be at least `2` for the writer version.

## References

* [Constraints](https://docs.databricks.com/delta/delta-constraints.html)
