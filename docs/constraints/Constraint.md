# Constraint

`Constraint` is an [abstraction](#contract) of [table constraints](#implementations) that writers have to assert before writing.

## Contract

### <span id="name"> Name

```scala
name: String
```

Used when:

* `InvariantViolationException` utility is used to [create an InvariantViolationException for a check constraint](InvariantViolationException.md#apply)

## Implementations

??? note "Sealed Trait"
    `Constraint` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

### <span id="Check"> Check

A constraint with a SQL expression ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) to check for when writing out data

### <span id="NotNull"> NotNull

A constraint on a column to be not null

[Name](#name): `NOT NULL`
