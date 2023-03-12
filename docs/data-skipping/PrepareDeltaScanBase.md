# PrepareDeltaScanBase Logical Optimizations

`PrepareDeltaScanBase` is an extension of the `Rule[LogicalPlan]` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule)) abstraction for [logical optimizations](#implementations) that [prepareDeltaScan](#prepareDeltaScan).

## Implementations

* [PrepareDeltaScan](PrepareDeltaScan.md)

## <span id="PredicateHelper"> PredicateHelper

`PrepareDeltaScanBase` is a `PredicateHelper` ([Spark SQL]({{ book.spark_sql }}/PredicateHelper)).

## <span id="apply"> Executing Rule

```scala
apply(
  _plan: LogicalPlan): LogicalPlan
```

With [spark.databricks.delta.stats.skipping](../DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property enabled, `apply` makes sure that the given `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan)) is neither a subquery (`Subquery` or `SupportsSubquery`) nor a `V2WriteCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/V2WriteCommand)) and [prepareDeltaScan](#prepareDeltaScan).

---

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule#apply)) abstraction.

### <span id="prepareDeltaScan"> prepareDeltaScan

```scala
prepareDeltaScan(
  plan: LogicalPlan): LogicalPlan
```

`prepareDeltaScan` finds delta table scans (i.e. [DeltaTable](../DeltaTable.md)s with [TahoeLogFileIndex](../TahoeLogFileIndex.md)).

For a delta table scan, `prepareDeltaScan` [finds a DeltaScanGenerator](#getDeltaScanGenerator) for the `TahoeLogFileIndex`.

`prepareDeltaScan` uses an internal `deltaScans` registry (of canonicalized logical scans and their [Snapshot](../Snapshot.md)s and [DeltaScan](DeltaScan.md)s) to look up the delta table scan or [creates a new entry](#filesForScan).

`prepareDeltaScan` [creates a PreparedDeltaFileIndex](#getPreparedIndex).

In the end, `prepareDeltaScan` [optimizeGeneratedColumns](#optimizeGeneratedColumns).

### <span id="getDeltaScanGenerator"> getDeltaScanGenerator

```scala
getDeltaScanGenerator(
  index: TahoeLogFileIndex): DeltaScanGenerator
```

`getDeltaScanGenerator`...FIXME

### <span id="getPreparedIndex"> getPreparedIndex

```scala
getPreparedIndex(
  preparedScan: DeltaScan,
  fileIndex: TahoeLogFileIndex): PreparedDeltaFileIndex
```

`getPreparedIndex` creates a new [PreparedDeltaFileIndex](PreparedDeltaFileIndex.md) (for the [DeltaScan](DeltaScan.md) and the [TahoeLogFileIndex](../TahoeLogFileIndex.md)).

`getPreparedIndex` requires that the [partitionFilters](../TahoeLogFileIndex.md#partitionFilters) (of the [TahoeLogFileIndex](../TahoeLogFileIndex.md)) are empty or throws an `AssertionError`:

```text
assertion failed: Partition filters should have been extracted by DeltaAnalysis.
```

### <span id="filesForScan"> filesForScan

```scala
filesForScan(
  scanGenerator: DeltaScanGenerator,
  limitOpt: Option[Int],
  projection: Seq[Attribute],
  filters: Seq[Expression],
  delta: LogicalRelation): (Snapshot, DeltaScan)
```

!!! note
    The given `limitOpt` argument is not used.

`filesForScan` prints out the following INFO message to the logs:

```text
DELTA: Filtering files for query
```

`filesForScan` determines the filters for a scan based on [generatedColumn.partitionFilterOptimization.enabled](../generated-columns/GeneratedColumn.md#partitionFilterOptimizationEnabled) configuration property:

* If disabled, `filesForScan` uses the given `filters` expressions unchanged
* With [generatedColumn.partitionFilterOptimization.enabled](../generated-columns/GeneratedColumn.md#partitionFilterOptimizationEnabled) enabled, `filesForScan` [generates the partition filters](../generated-columns/GeneratedColumn.md#generatePartitionFilters) that are used alongside the given `filters` expressions

`filesForScan` requests the given [DeltaScanGenerator](DeltaScanGenerator.md) for the [Snapshot to scan](DeltaScanGenerator.md#snapshotToScan) and a [DeltaScan](DeltaScanGenerator.md#filesForScan) (that are the return pair).

In the end, `filesForScan` prints out the following INFO message to the logs:

```text
DELTA: Done
```

### <span id="optimizeGeneratedColumns"> optimizeGeneratedColumns

```scala
optimizeGeneratedColumns(
  scannedSnapshot: Snapshot,
  scan: LogicalPlan,
  preparedIndex: PreparedDeltaFileIndex,
  filters: Seq[Expression],
  limit: Option[Int],
  delta: LogicalRelation): LogicalPlan
```

`optimizeGeneratedColumns`...FIXME

## Logging

`PrepareDeltaScanBase` is an abstract class and logging is configured using the logger of the [implementations](#implementations).
