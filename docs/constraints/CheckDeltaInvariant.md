# CheckDeltaInvariant

`CheckDeltaInvariant` is a `UnaryExpression` ([Spark SQL]({{ book.spark_sql }}/expressions/UnaryExpression)) for [DeltaInvariantCheckerExec](DeltaInvariantCheckerExec.md) physical operator.

## Creating Instance

`CheckDeltaInvariant` takes the following to be created:

* <span id="child"> Child Expression ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="columnExtractors"> Column Extractors (`Map[String, Expression]`)
* <span id="constraint"> [Constraint](Constraint.md)

`CheckDeltaInvariant` is created using [withBoundReferences](#withBoundReferences) and when:

* `DeltaInvariantCheckerExec` physical operator is [executed](DeltaInvariantCheckerExec.md#doExecute)

## <span id="eval"> Evaluating Expression

```scala
eval(
  input: InternalRow): Any
```

`eval` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#eval)) abstraction.

`eval` [asserts the constraint](#assertRule) on the input `InternalRow`.

### <span id="assertRule"> Asserts Constraint

```scala
assertRule(
  input: InternalRow): Unit
```

`assertRule`...FIXME

## <span id="withBoundReferences"> Creating CheckDeltaInvariant with BoundReferences

```scala
withBoundReferences(
  input: AttributeSeq): CheckDeltaInvariant
```

`withBoundReferences`...FIXME

`withBoundReferences` is used when:

* `DeltaInvariantCheckerExec` physical operator is [executed](DeltaInvariantCheckerExec.md#doExecute)
