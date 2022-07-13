# MultiDimClustering

`MultiDimClustering` is an [abstraction](#contract) of [multi-dimensional clustering algorithms](#implementations) (for changing the data layout).

## Contract

### <span id="contract-cluster"> cluster

```scala
cluster(
  df: DataFrame,
  colNames: Seq[String],
  approxNumPartitions: Int): DataFrame
```

!!! note
    It can be surprising to find out that this method is never really used.
    The reason is that there is a companion object `MultiDimClustering` with [cluster](#cluster-utility) utility of the same signature that simply [ZOrderClustering.cluster](ZOrderClustering.md#cluster) (bypassing any virtual calls as if there were multiple [implementations](#implementations) but there is just one).

## Implementations

* [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md)

## <span id="cluster"> cluster

```scala
cluster(
  df: DataFrame,
  approxNumPartitions: Int,
  colNames: Seq[String]): DataFrame
```

`cluster` does [Z-Order clustering](ZOrderClustering.md#cluster).

`cluster` asserts that there are `colNames` specified or throws an `AssertionError`:

```text
Cannot cluster by zero columns!
```

`cluster` is used when:

* `OptimizeExecutor` is requested to [runOptimizeBinJob](OptimizeExecutor.md#runOptimizeBinJob) (with [isMultiDimClustering](OptimizeExecutor.md#isMultiDimClustering) flag enabled)
