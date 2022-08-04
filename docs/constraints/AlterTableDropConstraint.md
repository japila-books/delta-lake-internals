# AlterTableDropConstraint

`AlterTableDropConstraint` is an `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand)) for [ALTER TABLE DROP CONSTRAINT](../sql/index.md#ALTER-TABLE-DROP-CONSTRAINT) SQL command.

## Creating Instance

`AlterTableDropConstraint` takes the following to be created:

* <span id="table"> Table (`LogicalPlan`)
* <span id="constraintName"> Constraint Name
* <span id="ifExists"> `ifExists` flag

`AlterTableDropConstraint` is created when:

* `DeltaSqlAstBuilder` is requested to [parse ALTER TABLE DROP CONSTRAINT SQL command](../sql/DeltaSqlAstBuilder.md#visitAddTableConstraint)

## <span id="changes"> Table Changes

```scala
changes: Seq[TableChange]
```

`changes` is part of the `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand#changes)) abstraction.

---

`changes` gives a single-element collection with an [DropConstraint](DropConstraint.md) (with the [constraintName](#constraintName) and [ifExists](#ifExists) flag).
