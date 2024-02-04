# ZOrderClustering

`ZOrderClustering` is a [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md) for [multi-dimensional clustering](MultiDimClustering.md#cluster-utility) with [zorder](OptimizeExecutor.md#zorder) curve.

## Clustering Expression { #getClusteringExpression }

??? note "SpaceFillingCurveClustering"

    ```scala
    getClusteringExpression(
      cols: Seq[Column],
      numRanges: Int): Column
    ```

    `getClusteringExpression` is part of the [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md#getClusteringExpression) abstraction.

`getClusteringExpression` creates a [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) function (with the given `numRanges` for the number of partitions) for every `Column` (in the given `cols`).

In the end, `getClusteringExpression` [interleave_bits](MultiDimClusteringFunctions.md#interleave_bits) with the `range_partition_id` columns and casts the (evaluation) result to `StringType`.

### Demo { #getClusteringExpression-demo }

For some reason, [getClusteringExpression](#getClusteringExpression) is `protected[skipping]` so let's hop over the fence with the following hack.

Paste the following to `spark-shell` in `:paste -raw` mode:

```scala
package org.apache.spark.sql.delta.skipping
object protectedHack {
  import org.apache.spark.sql.Column
  def getClusteringExpression(
    cols: Seq[Column], numRanges: Int): Column = {
      ZOrderClustering.getClusteringExpression(cols, numRanges)
    }
}
```

```scala
import org.apache.spark.sql.delta.skipping.protectedHack
val clusterExpr = protectedHack.getClusteringExpression(cols = Seq($"x", $"y"), numRanges = 3)
```

```text
scala> println(clusterExpr.expr.numberedTreeString)
00 cast(interleavebits(rangepartitionid('x, 3), rangepartitionid('y, 3)) as string)
01 +- interleavebits(rangepartitionid('x, 3), rangepartitionid('y, 3))
02    :- rangepartitionid('x, 3)
03    :  +- 'x
04    +- rangepartitionid('y, 3)
05       +- 'y
```
