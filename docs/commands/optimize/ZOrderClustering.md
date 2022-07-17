# ZOrderClustering

`ZOrderClustering` is a [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md) for [MultiDimClustering.cluster](MultiDimClustering.md#cluster-utility) utility.

## <span id="getClusteringExpression"> getClusteringExpression

```scala
getClusteringExpression(
  cols: Seq[Column],
  numRanges: Int): Column
```

`getClusteringExpression` is part of the [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md#getClusteringExpression) abstraction.

---

`getClusteringExpression` creates a [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) function (with the given `numRanges` for the number of partitions) for every `Column` (in `cols`).

In the end, `getClusteringExpression` [interleave_bits](MultiDimClusteringFunctions.md#interleave_bits) with the `range_partition_id` columns and casts the (evaluation) result to `StringType`.
