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

### <span id="build"> build

```scala
build(): StructField
```

Creates a `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField))

### <span id="comment"> comment

```scala
comment(
  comment: String): DeltaColumnBuilder
```

### <span id="dataType"> dataType

```scala
dataType(
  dataType: DataType): DeltaColumnBuilder
dataType(
  dataType: String): DeltaColumnBuilder
```

### <span id="generatedAlwaysAs"> generatedAlwaysAs

```scala
generatedAlwaysAs(
  expr: String): DeltaColumnBuilder
```

Registers the [Generation Expression](#generationExpr) of this field

### <span id="nullable"> nullable

```scala
nullable(
  nullable: Boolean): DeltaColumnBuilder
```

## <span id="generationExpr"> Generation Expression

```scala
generationExpr: Option[String] = None
```

`DeltaColumnBuilder` uses `generationExpr` internal registry for the [generatedAlwaysAs](#generatedAlwaysAs) expression.

When requested to [build a StructField](#build), `DeltaColumnBuilder` registers `generationExpr` under [delta.generationExpression](DeltaSourceUtils.md#GENERATION_EXPRESSION_METADATA_KEY) key in the metadata (of this field).
