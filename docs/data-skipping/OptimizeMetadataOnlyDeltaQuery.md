# OptimizeMetadataOnlyDeltaQuery

`OptimizeMetadataOnlyDeltaQuery` is an [abstraction](#contract) of [metadata-only PrepareDeltaScans](#implementations).

## Contract

### <span id="getDeltaScanGenerator"> getDeltaScanGenerator

```scala
getDeltaScanGenerator(
  index: TahoeLogFileIndex): DeltaScanGenerator
```

[DeltaScanGenerator](DeltaScanGenerator.md) for the given [TahoeLogFileIndex](../TahoeLogFileIndex.md)

See:

* [PrepareDeltaScanBase](PrepareDeltaScanBase.md#getDeltaScanGenerator)

Used when:

* `CountStarDeltaTable` is requested to [extractGlobalCount](CountStarDeltaTable.md#extractGlobalCount)

## Implementations

* [PrepareDeltaScanBase](PrepareDeltaScanBase.md)

## <span id="optimizeQueryWithMetadata"> optimizeQueryWithMetadata

```scala
optimizeQueryWithMetadata(
  plan: LogicalPlan): LogicalPlan
```

`optimizeQueryWithMetadata` uses [stats.numRecords](UsesMetadataFields.md#NUM_RECORDS) statistic for [CountStarDeltaTable](CountStarDeltaTable.md#unapply) queries and so making them very fast by being metadata-only.

---

`optimizeQueryWithMetadata` transforms the given `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan)) (with subqueries, children and every node itself) to replace a [CountStarDeltaTable](CountStarDeltaTable.md#unapply) with a `LocalRelation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LocalRelation)).

---

`optimizeQueryWithMetadata` is used when:

* `PrepareDeltaScanBase` logical optimization is requested to [execute](PrepareDeltaScanBase.md#apply)

## extractGlobalCount { #extractGlobalCount }

```scala
extractGlobalCount(
  tahoeLogFileIndex: TahoeLogFileIndex): Option[Long]
```

`extractGlobalCount`...FIXME

---

`extractGlobalCount` is used when:

* `CountStarDeltaTable` is requested to [destruct Aggregate logical operator](CountStarDeltaTable.md#unapply)
* `ShowCountStarDeltaTable` is requested to [destruct Aggregate logical operator](ShowCountStarDeltaTable.md#unapply)
