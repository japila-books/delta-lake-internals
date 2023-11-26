---
title: InterleaveBits
---

# InterleaveBits Expression

`InterleaveBits` is an `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) for [interleave_bits](MultiDimClusteringFunctions.md#interleave_bits) function.

## Creating Instance

`InterleaveBits` takes the following to be created:

* <span id="children"> Child `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`InterleaveBits` is created when:

* `MultiDimClusteringFunctions` utility is used to [interleave_bits](MultiDimClusteringFunctions.md#interleave_bits)

## <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow): Any
```

`eval` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#eval)) abstraction.

---

`eval` requests all the [child expressions](#children) to `eval` (with the given `InternalRow`). `eval` replaces `null` values with `0`, keeps `Int`-typed results and throws an `IllegalArgumentException` for others:

```text
[name] expects only inputs of type Int, but got: [any] of type [type]
```

`eval` updates the `ints` array with the values.

`eval` computes Z-values for all the multidimensional data points (cf. [Z-order curve](https://en.wikipedia.org/wiki/Z-order_curve)).

In the end, `eval` returns a byte array (4 times larger than the number of [children expressions](#children)).

## <span id="ExpectsInputTypes"> ExpectsInputTypes

`InterleaveBits` is an `ExpectsInputTypes` ([Spark SQL]({{ book.spark_sql }}/expressions/ExpectsInputTypes)).

## <span id="inputTypes"> inputTypes

```scala
inputTypes: Seq[DataType]
```

`inputTypes` is part of the `ExpectsInputTypes` ([Spark SQL]({{ book.spark_sql }}/expressions/ExpectsInputTypes#inputTypes)) abstraction.

---

`inputTypes` is `IntegerType` for all the [child expressions](#children).

## <span id="CodegenFallback"> CodegenFallback

`InterleaveBits` is an `CodegenFallback` ([Spark SQL]({{ book.spark_sql }}/expressions/CodegenFallback)).

## <span id="dataType"> Evaluation Result DataType

```scala
dataType: DataType
```

`dataType` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#dataType)) abstraction.

---

`dataType` is always `BinaryType`.

## <span id="nullable"> nullable

```scala
nullable: Boolean
```

`nullable` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#nullable)) abstraction.

`nullable` is always `false`.
