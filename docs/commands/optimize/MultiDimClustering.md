# MultiDimClustering

`MultiDimClustering` is an [abstraction](#contract) of [multi-dimensional clustering algorithms](#implementations) (for changing the data layout).

## Contract

### <span id="cluster"> cluster

```scala
cluster(
  df: DataFrame,
  colNames: Seq[String],
  approxNumPartitions: Int): DataFrame
```

!!! note
    It can be surprising to find out that this method is never really used.
    The reason is that there is a companion object `MultiDimClustering` with the [cluster](#cluster-utility) utility of the same signature that simply [ZOrderClustering.cluster](SpaceFillingCurveClustering.md#cluster) (bypassing any virtual calls as if there were multiple [implementations](#implementations) yet there is just one).

## Implementations

* [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md)

## <span id="cluster-utility"> cluster

```scala
cluster(
  df: DataFrame,
  approxNumPartitions: Int,
  colNames: Seq[String]): DataFrame
```

`cluster` does [Z-Order clustering](SpaceFillingCurveClustering.md#cluster).

`cluster` is used when:

* `OptimizeExecutor` is requested to [runOptimizeBinJob](OptimizeExecutor.md#runOptimizeBinJob) (with [isMultiDimClustering](OptimizeExecutor.md#isMultiDimClustering) flag enabled)

### <span id="cluster-utility-AssertionError"> AssertionError

`cluster` throws an `AssertionError` when there are no `colNames` specified:

```text
Cannot cluster by zero columns!
```
