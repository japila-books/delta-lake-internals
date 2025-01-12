---
title: GenerateIdentityValues
---

# GenerateIdentityValues Non-Deterministic Leaf Expression

`GenerateIdentityValues` is a non-deterministic `LeafExpression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/#LeafExpression)).

`GenerateIdentityValues` uses [PartitionIdentityValueGenerator](PartitionIdentityValueGenerator.md) to [generate the next IDENTITY value](PartitionIdentityValueGenerator.md#next).

## Creating Instance

`GenerateIdentityValues` takes the following to be created:

* <span id="generator"> [PartitionIdentityValueGenerator](PartitionIdentityValueGenerator.md)

`GenerateIdentityValues` is created using [apply](#apply) utility.

## Create GenerateIdentityValues { #apply }

```scala
apply(
  start: Long,
  step: Long,
  highWaterMarkOpt: Option[Long]): GenerateIdentityValues
```

`apply` creates a [GenerateIdentityValues](#creating-instance) with a new [PartitionIdentityValueGenerator](PartitionIdentityValueGenerator.md) with the given input arguments.

---

`apply` is used when:

* `IdentityColumn` is requested to [createIdentityColumnGenerationExpr](IdentityColumn.md#createIdentityColumnGenerationExpr)

## initializeInternal { #initializeInternal }

??? note "Nondeterministic"

    ```scala
    initializeInternal(
      partitionIndex: Int): Unit
    ```

    `initializeInternal` is part of the `Nondeterministic` ([Spark SQL]({{ book.spark_sql }}/expressions/Nondeterministic/#initializeInternal)) abstraction.

`initializeInternal` requests this [PartitionIdentityValueGenerator](#generator) to [initialize](PartitionIdentityValueGenerator.md#initialize) with the given `partitionIndex`.

## evalInternal { #evalInternal }

??? note "Nondeterministic"

    ```scala
    evalInternal(
      input: InternalRow): Long
    ```

    `evalInternal` is part of the `Nondeterministic` ([Spark SQL]({{ book.spark_sql }}/expressions/Nondeterministic/#evalInternal)) abstraction.

`evalInternal` requests this [PartitionIdentityValueGenerator](#generator) for the [next IDENTITY value](PartitionIdentityValueGenerator.md#next).

## Nullable { #nullable }

??? note "Expression"

    ```scala
    nullable: Boolean
    ```

    `nullable` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/#nullable)) abstraction.

`nullable` is always `false`.

## Generating Java Source Code for Code-Generated Expression Evaluation { #doGenCode }

??? note "Expression"

    ```scala
    doGenCode(
      ctx: CodegenContext,
      ev: ExprCode): ExprCode
    ```

    `doGenCode` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/#doGenCode)) abstraction.

`doGenCode` generates a Java source code with this [PartitionIdentityValueGenerator](#generator) to be [initialized](PartitionIdentityValueGenerator.md#initialize) (for the current `partitionIndex`) followed by requesting the [next IDENTITY value](PartitionIdentityValueGenerator.md#next).

```scala
import org.apache.spark.sql.delta.GenerateIdentityValues

val expr = GenerateIdentityValues(start = 0, step = 1, highWaterMarkOpt = None)

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext

val code = expr.genCode(ctx).code
println(code)
```

```text
final long value_0 = ((org.apache.spark.sql.delta.PartitionIdentityValueGenerator) references[0] /* generator */).next();
```
