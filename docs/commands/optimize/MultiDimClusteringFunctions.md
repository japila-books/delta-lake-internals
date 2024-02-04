# MultiDimClusteringFunctions

`MultiDimClusteringFunctions` utility offers Spark SQL functions for multi-dimensional clustering.

## range_partition_id { #range_partition_id }

```scala
range_partition_id(
  col: Column,
  numPartitions: Int): Column
```

`range_partition_id` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) with [RangePartitionId](RangePartitionId.md) unary expression (for the given arguments).

---

`range_partition_id` is used when:

* `ZOrderClustering` utility is used for the [clustering expression](ZOrderClustering.md#getClusteringExpression)

## interleave_bits { #interleave_bits }

```scala
interleave_bits(
  cols: Column*): Column
```

`interleave_bits` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) with [InterleaveBits](InterleaveBits.md) expression (for the expressions of the given columns).

---

`interleave_bits` is used when:

* `ZOrderClustering` utility is used for the [clustering expression](ZOrderClustering.md#getClusteringExpression)

## hilbert_index { #hilbert_index }

```scala
hilbert_index(
  numBits: Int,
  cols: Column*): Column
```

`hilbert_index` creates a `Column` ([Spark SQL]({{ book.spark_sql }}/Column)) to execute one of the following `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) based on the _hilbertBits_:

* [HilbertLongIndex](HilbertLongIndex.md) for up to 64 hilbert bits
* [HilbertByteArrayIndex](HilbertByteArrayIndex.md), otherwise

The _hilbertBits_ is the number of columns (`cols`) multiplied by the number of bits (`numBits`).

??? note "SparkException: Hilbert indexing can only be used on 9 or fewer columns"
    `hilbert_index` throws a `SparkException` for 10 or more columns (`cols`).

    ```text
    Hilbert indexing can only be used on 9 or fewer columns.
    ```

---

`hilbert_index` is used when:

* `HilbertClustering` is requested for the [clustering expression](HilbertClustering.md#getClusteringExpression)
