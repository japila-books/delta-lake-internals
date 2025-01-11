---
title: Invariants
---

# Invariants Utility

## <span id="INVARIANTS_FIELD"><span id="delta.invariants"> delta.invariants

`Invariants` defines `delta.invariants` for the [column invariants](index.md) of a delta table.

`delta.invariants` contains a JSON-encoded SQL expression.

## <span id="getFromSchema"> Extracting Constraints from Schema

```scala
getFromSchema(
  schema: StructType,
  spark: SparkSession): Seq[Constraint]
```

`getFromSchema` finds columns (top-level or nested) that are non-nullable and have [delta.invariants](#INVARIANTS_FIELD) metadata.

For every parent of the columns, `getFromSchema` creates [NotNull](../constraints/Constraint.md#NotNull) constraints.

For the columns themselves, `getFromSchema` creates [Check](../constraints/Constraints.md#Check) constraints.

---

`getFromSchema` is used when:

* `Constraints` utility is used to [extract table constraints](../constraints/Constraints.md#getAll)
* `Protocol` utility is used to [determine the required minimum protocol](../Protocol.md#requiredMinimumProtocol)

## <span id="Rule"> Rule

`Invariants` utility defines a `Rule` abstraction.

`Rule` has a name.

### <span id="ArbitraryExpression"> ArbitraryExpression

`ArbitraryExpression` is a [Rule](#Rule) with the following:

* `EXPRESSION([expression])` name
* An `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
