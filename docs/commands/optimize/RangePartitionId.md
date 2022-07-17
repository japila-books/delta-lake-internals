# RangePartitionId Unary Expression

`RangePartitionId` is a `UnaryExpression` ([Spark SQL]({{ book.spark_sql }}/expressions/UnaryExpression)) for [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) function.

## Creating Instance

`RangePartitionId` takes the following to be created:

* <span id="child"> Child `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="numPartitions"> Number of partitions

`RangePartitionId` requires the [number of partitions](#numPartitions) to be greater than `0`.

`RangePartitionId` is created when:

* `MultiDimClusteringFunctions` utility is used to [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id)

## <span id="Unevaluable"> Unevaluable

`RangePartitionId` is `Unevaluable` ([Spark SQL]({{ book.spark_sql }}/expressions/Unevaluable)) that is rewritten by [RangePartitionIdRewrite](RangePartitionIdRewrite.md) to [PartitionerExpr](PartitionerExpr.md).

## <span id="checkInputDataTypes"> checkInputDataTypes

```scala
checkInputDataTypes(): TypeCheckResult
```

`checkInputDataTypes` is successful when the `DataType` ([Spark SQL]({{ book.spark_sql }}/types/DataType)) of the [child](#child) expression is row-orderable ([Spark SQL]({{ book.spark_sql }}/expressions/RowOrdering#isOrderable)). Otherwise, `checkInputDataTypes` is negative.

`checkInputDataTypes` is part of the `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression#checkInputDataTypes)) abstraction.
