# MultiDimClustering

`MultiDimClustering` is an [abstraction](#contract) of [multi-dimensional clustering algorithms](#implementations) (for changing the data layout).

## Contract

### Multi-Dimensional Clustering { #cluster }

```scala
cluster(
  df: DataFrame,
  colNames: Seq[String],
  approxNumPartitions: Int,
  randomizationExpressionOpt: Option[Column]): DataFrame
```

Repartition the given `df` into `approxNumPartitions` based on the provided `colNames`

See:

* [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md#cluster)

!!! note
    `randomizationExpressionOpt` is always undefined (`None`).

Used when:

* `MultiDimClustering` utility is requested to [cluster a DataFrame](#cluster-utility)

## Implementations

* [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md)

## cluster { #cluster-utility }

```scala
cluster(
  df: DataFrame,
  approxNumPartitions: Int,
  colNames: Seq[String],
  curve: String): DataFrame
```

`cluster` asserts that the given `colNames` contains at least one column name. Otherwise, `cluster` reports an `AssertionError`:

```text
assertion failed : Cannot cluster by zero columns!
```

`cluster` selects the multi-dimensional clustering algorithm based on the given `curve` name.

Curve Type | Clustering Algorithm
-----------|---------------------
 `hilbert` | `HilbertClustering`
 `zorder`  | `ZOrderClustering`

??? note "SparkException"
    `cluster` accepts these two algorithms only or throws a `SparkException`:

    ```text
    Unknown curve ([curve]), unable to perform multi dimensional clustering.
    ```

`cluster` requests the clustering implementation to [cluster](SpaceFillingCurveClustering.md#cluster) (with no `randomizationExpressionOpt`).

---

`cluster` is used when:

* `OptimizeExecutor` is requested to [runOptimizeBinJob](OptimizeExecutor.md#runOptimizeBinJob) (with [isMultiDimClustering](OptimizeExecutor.md#isMultiDimClustering) flag enabled)

### <span id="cluster-utility-AssertionError"> AssertionError

`cluster` throws an `AssertionError` when there are no `colNames` specified:

```text
Cannot cluster by zero columns!
```
