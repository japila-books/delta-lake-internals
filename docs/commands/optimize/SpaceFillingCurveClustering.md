# SpaceFillingCurveClustering

`SpaceFillingCurveClustering` is an [extension](#contract) of the [MultiDimClustering](MultiDimClustering.md) abstraction for [FIXME](#implementations).

## Contract

### <span id="getClusteringExpression"> getClusteringExpression

```scala
getClusteringExpression(
  cols: Seq[Column],
  numRanges: Int): Column
```

Used when:

* `SpaceFillingCurveClustering` is requested to [cluster](#cluster)

## Implementations

* [ZOrderClustering](ZOrderClustering.md)

## <span id="cluster"> cluster

```scala
cluster(
  df: DataFrame,
  colNames: Seq[String],
  approxNumPartitions: Int): DataFrame
```

`cluster`...FIXME

`cluster` is part of the [MultiDimClustering](MultiDimClustering.md#cluster) abstraction.
