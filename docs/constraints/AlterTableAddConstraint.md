# AlterTableAddConstraint

`AlterTableAddConstraint` is an `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand)) that represents [ALTER TABLE ADD CONSTRAINT](../sql/index.md#ALTER-TABLE-ADD-CONSTRAINT) SQL statement.

## Creating Instance

`AlterTableAddConstraint` takes the following to be created:

* <span id="table"> Table (`LogicalPlan`)
* <span id="constraintName"> Constraint Name
* <span id="expr"> Constraint SQL Expression (text)

`AlterTableAddConstraint` is created when:

* `DeltaSqlAstBuilder` is requested to [parse ALTER TABLE ADD CONSTRAINT SQL command](../sql/DeltaSqlAstBuilder.md#visitAddTableConstraint)

## <span id="changes"> Table Changes

```scala
changes: Seq[TableChange]
```

`changes` is part of the `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand#changes)) abstraction.

---

`changes` gives a single-element collection with an [AddConstraint](AddConstraint.md) (with the [constraintName](#constraintName) and [expr](#expr)).
