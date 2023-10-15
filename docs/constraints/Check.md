# Check

`Check` is a [table constraint](Constraint.md) that is a [SQL expression](#expression) to assert when [writing out data](../commands/WriteIntoDelta.md#extractConstraints).

`Check` is used for the following:

 Component | Name | Expression
-----------|------|-----------
 [IDENTITY Columns](../ColumnWithDefaultExprUtils.md#addDefaultExprsOrReturnConstraints) | `Generated Column` | `EqualNullSafe`
 [WriteIntoDelta](../commands/WriteIntoDelta.md#extractConstraints) | `EXPRESSION(expression)` | An `Expression`
 `CharVarcharConstraint` | `__CHAR_VARCHAR_STRING_LENGTH_CHECK__` |
 [Table Constraints](index.md) | `delta.constraints.`-prefixed key name (from the [metadata configuration](../Metadata.md#configuration)) without the prefix | The constraint text (from the [metadata configuration](../Metadata.md#configuration)) for the key
 [Column Invariants](../column-invariants/index.md) | The name of the `delta.invariants` metadata of a column | The expression of the `delta.invariants` metadata of a column

## Creating Instance

`Check` takes the following to be created:

* <span id="name"> Name
* <span id="expression"> `Expression` ([Spark SQL]({{ book.spark_sql}}/expressions/Expression/))

`Check` is created when:

* `ColumnWithDefaultExprUtils` is requested to [addDefaultExprsOrReturnConstraints](../ColumnWithDefaultExprUtils.md#addDefaultExprsOrReturnConstraints)
* `WriteIntoDelta` is requested to [extractConstraints](../commands/WriteIntoDelta.md#extractConstraints)
* `CharVarcharConstraint` is requested to `stringConstraints`
* `Constraints` is requested to [getCheckConstraints](Constraints.md#getCheckConstraints)
* `Invariants` is requested to [getFromSchema](../column-invariants/Invariants.md#getFromSchema)
