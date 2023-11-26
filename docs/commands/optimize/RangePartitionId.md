---
title: RangePartitionId
---

# RangePartitionId Unary Expression

`RangePartitionId` is a `UnaryExpression` ([Spark SQL]({{ book.spark_sql }}/expressions/UnaryExpression)) that represents [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) function in a logical query plan (until it is resolved into [PartitionerExpr](PartitionerExpr.md) by [RangePartitionIdRewrite](RangePartitionIdRewrite.md) optimization).

## Creating Instance

`RangePartitionId` takes the following to be created:

* <span id="child"> Child `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="numPartitions"> Number of partitions

`RangePartitionId` requires the [number of partitions](#numPartitions) to be greater than `0`.

`RangePartitionId` is created when:

* [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) function is used

## <span id="Unevaluable"> Unevaluable

`RangePartitionId` is `Unevaluable` ([Spark SQL]({{ book.spark_sql }}/expressions/Unevaluable)) that is rewritten by [RangePartitionIdRewrite](RangePartitionIdRewrite.md) to [PartitionerExpr](PartitionerExpr.md).

## <span id="checkInputDataTypes"> checkInputDataTypes

```scala
checkInputDataTypes(): TypeCheckResult
```

`checkInputDataTypes` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#checkInputDataTypes)) abstraction.

---

`checkInputDataTypes` is successful when the `DataType` ([Spark SQL]({{ book.spark_sql }}/types/DataType)) of the [child](#child) expression is row-orderable ([Spark SQL]({{ book.spark_sql }}/expressions/RowOrdering#isOrderable)). Otherwise, `checkInputDataTypes` is negative.

## <span id="dataType"> Evaluation Result DataType

```scala
dataType: DataType
```

`dataType` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#dataType)) abstraction.

---

`dataType` is always `IntegerType`.

## <span id="nullable"> nullable

```scala
nullable: Boolean
```

`nullable` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#nullable)) abstraction.

---

`nullable` is always `false`.
