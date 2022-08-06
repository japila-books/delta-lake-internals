# Column Invariants

!!! note
    As per [this comment](https://github.com/delta-io/delta/blob/58b25108e1e275fa7e2ff4ba758184a19270cf15/core/src/main/scala/org/apache/spark/sql/delta/constraints/Constraints.scala#L34-L39), column invariants are old-style and users should use [CHECK constraints](../check-constraints/index.md):

    > Utilities for handling constraints. Right now this includes:
    > 
    >   * Column-level invariants (including both NOT NULL constraints and an old style of CHECK constraint specified in the column metadata)
    >   * Table-level CHECK constraints

**Column Invariants** are SQL expressions that are used to enforce data quality at column level (at [write time](../TransactionalWrite.md#writeFiles) using [DeltaInvariantCheckerExec](../constraints/DeltaInvariantCheckerExec.md)).

Column Invariants are associated with [any top-level or nested columns](Invariants.md#getFromSchema). If with a nested column, all parent columns have to be non-nullable (by [NotNull](../constraints/Constraint.md#NotNull) constraints).

Column invariants are column-level (not table-wide) yet use the same [Check](../constraints/Constraints.md#Check) constraint as [CHECK constraints](../check-constraints/index.md). In other words, column invariants are single-column CHECK constraints (i.e., limited to a single column).

## delta.invariants

Column invariants are [stored](Invariants.md#getFromSchema) in the [table schema](../Metadata.md#schema) (of a [table metadata](../Metadata.md)) as JSON-encoded SQL expressions as [delta.invariants](Invariants.md#delta.invariants) metadata of a column.
