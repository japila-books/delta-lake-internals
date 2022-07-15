# SpaceFillingCurveClustering

`SpaceFillingCurveClustering` is an [extension](#contract) of the [MultiDimClustering](MultiDimClustering.md) abstraction for [space filling curve based clustering algorithms](#implementations).

## Contract

### <span id="getClusteringExpression"> getClusteringExpression

```scala
getClusteringExpression(
  cols: Seq[Column],
  numRanges: Int): Column
```

Used when:

* `SpaceFillingCurveClustering` is requested to execute [multi-dimensional clustering](#cluster)

## Implementations

* [ZOrderClustering](ZOrderClustering.md)

## <span id="cluster"> Multi-Dimensional Clustering

```scala
cluster(
  df: DataFrame,
  colNames: Seq[String],
  approxNumPartitions: Int): DataFrame
```

`cluster` is part of the [MultiDimClustering](MultiDimClustering.md#cluster) abstraction.

`cluster` converts the given `colNames` into `Column`s (using the given `df` dataframe).

`cluster` adds two column expressions (to the given `DataFrame`):

1. `[randomUUID]-rpKey1` for a [clustering expression](#getClusteringExpression) (with the `colNames` and the [spark.databricks.io.skipping.mdc.rangeId.max](../../DeltaSQLConf.md#MDC_NUM_RANGE_IDS) configuration property)
1. `[randomUUID]-rpKey2` for an extra noise (for an independent and identically distributed samples uniformly distributed in `[0.0, 1.0)` using `rand` standard function)

`cluster` uses `rpKey2` column only with [spark.databricks.io.skipping.mdc.addNoise](../../DeltaSQLConf.md#MDC_ADD_NOISE) enabled.

`cluster` repartitions the given `DataFrame` by the `rpKey1` and `rpKey2` partitioning expressions into the `approxNumPartitions` partitions (using [Dataset.repartitionByRange]({{ book.spark_sql }}/Dataset#repartitionByRange) operator).

In the end, `cluster` returns the repartitioned `DataFrame` (with the two columns to be dropped).

### <span id="cluster-demo"> Demo

```scala
import org.apache.spark.sql.delta.skipping.ZOrderClustering
val df = spark.range(5).toDF
val colNames = "id" :: Nil
val approxNumPartitions = 3
val repartByRangeDf = ZOrderClustering.cluster(df, colNames, approxNumPartitions)
```

```scala
println(repartByRangeDf.queryExecution.executedPlan.numberedTreeString)
```

```text
00 AdaptiveSparkPlan isFinalPlan=false
01 +- Project [id#0L]
02    +- Exchange rangepartitioning(1075d2d7-0cd9-4ce2-be11-ff345ff45047-rpKey1#3 ASC NULLS FIRST, f311bca4-4b5a-4bd8-b9e6-5fb05570c8e1-rpKey2#6 ASC NULLS FIRST, 3), REPARTITION_BY_NUM, [id=#21]
03       +- Project [id#0L, cast(interleavebits(partitionerexpr(id#0L, org.apache.spark.RangePartitioner@442452be)) as string) AS 1075d2d7-0cd9-4ce2-be11-ff345ff45047-rpKey1#3, cast(((rand(5298108963717326846) * 255.0) - 128.0) as tinyint) AS f311bca4-4b5a-4bd8-b9e6-5fb05570c8e1-rpKey2#6]
04          +- Range (0, 5, step=1, splits=16)
```

```scala
assert(repartByRangeDf.rdd.getNumPartitions == 3)
```

I'm sure that the demo begs for some more love but let's explore the data in the parquet data files anyway.
The dataset is very basic (yet I'm hoping someone will take it from there).

```scala
repartByRangeDf.write.format("delta").save("/tmp/zorder")
```

```text
$ tree /tmp/zorder
/tmp/zorder
├── _delta_log
│   └── 00000000000000000000.json
├── part-00000-5677c9b7-7439-4365-8233-8f0e6184dcf3-c000.snappy.parquet
├── part-00001-9dfb628f-c225-4d23-acb8-0946f0c3617d-c000.snappy.parquet
└── part-00002-e1172c78-4d47-4947-bd37-f67c72701062-c000.snappy.parquet
```

```text
scala> spark.read.load("/tmp/zorder/part-00000-*").show
+---+
| id|
+---+
|  0|
|  1|
+---+


scala> spark.read.load("/tmp/zorder/part-00001-*").show
+---+
| id|
+---+
|  2|
|  3|
+---+


scala> spark.read.load("/tmp/zorder/part-00002-*").show
+---+
| id|
+---+
|  4|
+---+
```
