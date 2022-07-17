# MultiDimClusteringFunctions

`MultiDimClusteringFunctions` utility offers Spark SQL functions for multi-dimensional clustering.

## <span id="range_partition_id"> range_partition_id

```scala
range_partition_id(
  col: Column,
  numPartitions: Int): Column
```

`range_partition_id` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) with [RangePartitionId](RangePartitionId.md) unary expression (for the given arguments).

`range_partition_id` is used when:

* `ZOrderClustering` utility is used for the [clustering expression](ZOrderClustering.md#getClusteringExpression)

## <span id="interleave_bits"> interleave_bits

```scala
interleave_bits(
  cols: Column*): Column
```

`interleave_bits` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) with [InterleaveBits](InterleaveBits.md) expression (for the expressions of the given columns).

`interleave_bits` is used when:

* `ZOrderClustering` utility is used for the [clustering expression](ZOrderClustering.md#getClusteringExpression)
