---
tags:
  - DeveloperApi
---

# DeltaColumnBuilder

`DeltaColumnBuilder` is a [builder interface](#operators) to [create columns](#build) programmatically.

`DeltaColumnBuilder` is [created](#creating-instance) using [DeltaTable.columnBuilder](DeltaTable.md#columnBuilder) utility.

In the end, `DeltaColumnBuilder` is supposed to be [built](#build).

## io.delta.tables Package

`DeltaColumnBuilder` belongs to `io.delta.tables` package.

```scala
import io.delta.tables.DeltaColumnBuilder
```

## Creating Instance

`DeltaColumnBuilder` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="colName"> Column Name

## Operators

### Build StructField { #build }

```scala
build(): StructField
```

Creates a `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField)) (possibly with some field metadata)

### comment { #comment }

```scala
comment(
  comment: String): DeltaColumnBuilder
```

### dataType { #dataType }

```scala
dataType(
  dataType: DataType): DeltaColumnBuilder
dataType(
  dataType: String): DeltaColumnBuilder
```

### generatedAlwaysAs { #generatedAlwaysAs }

```scala
generatedAlwaysAs(
  expr: String): DeltaColumnBuilder
```

Registers the [Generation Expression](#generationExpr) of this field

### generatedAlwaysAsIdentity { #generatedAlwaysAsIdentity }

```scala
generatedAlwaysAsIdentity(
  start: Long,
  step: Long): DeltaColumnBuilder
```

Sets the following:

Property | Value
-|-
[identityStart](#identityStart) | `start`
[identityStep](#identityStep) | `step`
[identityAllowExplicitInsert](#identityAllowExplicitInsert) | `false`

### generatedByDefaultAsIdentity { #generatedByDefaultAsIdentity }

```scala
generatedByDefaultAsIdentity(
  start: Long,
  step: Long): DeltaColumnBuilder
```

Sets the following:

Property | Value
-|-
[identityStart](#identityStart) | `start`
[identityStep](#identityStep) | `step`
[identityAllowExplicitInsert](#identityAllowExplicitInsert) | `true`

### nullable { #nullable }

```scala
nullable(
  nullable: Boolean): DeltaColumnBuilder
```

## Generation Expression { #generationExpr }

```scala
generationExpr: Option[String] = None
```

`DeltaColumnBuilder` uses `generationExpr` internal registry for the [generatedAlwaysAs](#generatedAlwaysAs) expression.

When requested to [build a StructField](#build), `DeltaColumnBuilder` registers `generationExpr` under [delta.generationExpression](spark-connector/DeltaSourceUtils.md#GENERATION_EXPRESSION_METADATA_KEY) key in the metadata (of this field).

## identityAllowExplicitInsert { #identityAllowExplicitInsert }

```scala
identityAllowExplicitInsert: Option[Boolean] = None
```

`identityAllowExplicitInsert` flag is used to indicate a call to the following methods:

Method | Value
-|-
[generatedAlwaysAsIdentity](#generatedAlwaysAsIdentity) | `false`
[generatedByDefaultAsIdentity](#generatedByDefaultAsIdentity) | `true`

`identityAllowExplicitInsert` is used to [build a StructField](#build).
