# HilbertClustering

`HilbertClustering` is a [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md) for [multi-dimensional clustering](MultiDimClustering.md#cluster-utility) with [hilbert](OptimizeExecutor.md#hilbert) curve.

`HilbertClustering` requires between 2 and [up to 9 columns](MultiDimClusteringFunctions.md#hilbert_index) to cluster by.

??? note "Singleton Object"
    `HilbertClustering` is a Scala **object** which is a class that has exactly one instance. It is created lazily when it is referenced, like a `lazy val`.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

## Clustering Expression { #getClusteringExpression }

??? note "SpaceFillingCurveClustering"

    ```scala
    getClusteringExpression(
      cols: Seq[Column],
      numRanges: Int): Column
    ```

    `getClusteringExpression` is part of the [SpaceFillingCurveClustering](SpaceFillingCurveClustering.md#getClusteringExpression) abstraction.

`getClusteringExpression` creates a `rangeIdCols` as [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) for the given `cols` columns and the `numRanges` number of partitions (_buckets_).

In the end, `getClusteringExpression` [hilbert_index](MultiDimClusteringFunctions.md#hilbert_index) with the following:

* The number of bits being one more than the number of trailing zeros of the int value with at most a single one-bit, in the position of the highest-order ("leftmost") one-bit in the `numRanges` value

    ??? note "Number of Bits Explained"
        Given `numRanges` is `5`, the position of the highest-order ("leftmost") one-bit is `2`.

        ```scala
        val numRanges = 5
        scala> println(s"$numRanges in the two's complement binary representation is ${Integer.toBinaryString(numRanges)}")
        5 in the two's complement binary representation is 101
        ```

        Counting positions from left to right, starting from `0`, gives `2` as the position of the highest-order ("leftmost") one-bit.

        ```scala
        scala> print(s"For ${numRanges}, the int value with at most a single one-bit is ${Integer.highestOneBit(numRanges)}")
        For 5, the int value with at most a single one-bit is 4
        ```

        The int value with at most a single one-bit in the position of the highest-order ("leftmost") one-bit being `2` is `4` (`2^2`).

        The number of zero bits following the lowest-order ("rightmost") one-bit in the two's complement binary representation of the int value (`4`) is `2`.

        ```scala
        scala> println(s"For ${Integer.highestOneBit(numRanges)}, the number of zero bits is ${Integer.numberOfTrailingZeros(Integer.highestOneBit(numRanges))}")
        For 4, the number of zero bits is 2
        ```

        In the end, `getClusteringExpression` uses `3` as the number of bits.

* The [range_partition_id](MultiDimClusteringFunctions.md#range_partition_id) columns
