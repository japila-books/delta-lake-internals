# MultiDimClusteringFunctions

`MultiDimClusteringFunctions` utility offers Spark SQL functions for multi-dimensional clustering.

## <span id="range_partition_id"> range_partition_id

```scala
range_partition_id(
  col: Column,
  numPartitions: Int): Column
```

`range_partition_id` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) with [RangePartitionId](RangePartitionId.md) unary expression.

`range_partition_id` is used when:

* `ZOrderClustering` utility is used for the [clustering expression](ZOrderClustering.md#getClusteringExpression)
