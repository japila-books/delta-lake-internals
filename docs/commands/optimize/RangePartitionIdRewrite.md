# RangePartitionIdRewrite Optimization Rule

`RangePartitionIdRewrite` is an optimization rule (`Rule[LogicalPlan]`) to [rewrite RangePartitionIds to PartitionerExprs](#apply).

## Creating Instance

`RangePartitionIdRewrite` takes the following to be created:

* <span id="session"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`RangePartitionIdRewrite` is created when:

* `DeltaSparkSessionExtension` is requested to [register delta extensions](../../DeltaSparkSessionExtension.md#apply)

## <span id="sampleSizeHint"><span id="sampleSizePerPartition"> sampleSizePerPartition Hint

`RangePartitionIdRewrite` uses `spark.sql.execution.rangeExchange.sampleSizePerPartition` ([Spark SQL]({{ book.spark_sql }}/configuration-properties#spark.sql.execution.rangeExchange.sampleSizePerPartition)) configuration property for `samplePointsPerPartitionHint` for a `RangePartitioner` ([Spark Core]({{ book.spark_core }}/rdd/RangePartitioner)) when [executed](#apply).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule#apply)) abstraction.

---

`apply` transforms `UnaryNode`s with [RangePartitionId](RangePartitionId.md) unary expressions in the given `LogicalPlan` (from the children first and up).

For every `RangePartitionId`, `apply` creates a new logical query plan for sampling (based on the [child expression](RangePartitionId.md#child) of the `RangePartitionId`).

```scala
import org.apache.spark.sql.functions.lit
val expr = lit(5).expr

import org.apache.spark.sql.catalyst.expressions.Alias
val aliasedExpr = Alias(expr, "__RPI_child_col__")()
```

`apply` changes the current call site to the following:

```text
RangePartitionId([childExpr], [numPartitions]) sampling
```

!!! note "Call Site"
    A call site is used in web UI and `SparkListener`s for all jobs submitted from the current and child threads.

`apply` creates a `RangePartitioner` ([Spark Core]({{ book.spark_core }}/rdd/RangePartitioner)) (with the [number of partition](RangePartitionId.md#numPartitions) of the `RangePartitionId`, the RDD of the query plan for sampling, `ascending` flag enabled, and the [sampleSizePerPartition hint](#sampleSizeHint)).

In the end, `apply` creates a [PartitionerExpr](PartitionerExpr.md) with the [child expression](RangePartitionId.md#child) (of the `RangePartitionId`) and the `RangePartitioner`.
