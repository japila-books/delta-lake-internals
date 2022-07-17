# PartitionerExpr Unary Expression

`PartitionerExpr` is a `UnaryExpression` ([Spark SQL]({{ book.spark_sql }}/expressions/UnaryExpression)) that represents [RangePartitionId](RangePartitionId.md) unary expression at execution (after [RangePartitionIdRewrite](RangePartitionIdRewrite.md) optimization rule).

## Creating Instance

`PartitionerExpr` takes the following to be created:

* <span id="child"> Child `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="partitioner"> `Partitioner` ([Spark Core]({{ book.spark_core }}/rdd/Partitioner))

`PartitionerExpr` is created when:

* `RangePartitionIdRewrite` optimization rule is [executed](RangePartitionIdRewrite.md#apply) (on a `LogicalPlan` with [RangePartitionId](RangePartitionId.md) expressions)

## <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow): Any
```

`eval` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#eval)) abstraction.

---

`eval` requests the [child expression](#child) to `eval` for the given `InternalRow` and uses the evaluation result to update the [GenericInternalRow](#row) at `0`th position.

In the end, `eval` requests the [Partitioner](#partitioner) to `getPartition` for the just-updated [GenericInternalRow](#row).

## <span id="doGenCode"> Code-Generated Expression Evaluation

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode`...FIXME

`doGenCode` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#doGenCode)) abstraction.

## <span id="dataType"> Evaluation Result DataType

```scala
dataType: DataType
```

`dataType` is always `IntegerType`.

`dataType` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#dataType)) abstraction.

## <span id="nullable"> nullable

```scala
nullable: Boolean
```

`nullable` is always `false`.

`nullable` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#nullable)) abstraction.
