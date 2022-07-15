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

`getClusteringExpression` applies [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) function (with the given `numRanges` number of partitions) on every `Column` (in `cols`).
