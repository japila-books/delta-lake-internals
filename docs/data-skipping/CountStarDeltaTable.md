# CountStarDeltaTable Scala Extractor

`CountStarDeltaTable` is an extractor object ([Scala]({{ scala.docs }}/tour/extractor-objects.html)) to [extractGlobalCount](#extractGlobalCount) for an [Aggregate](#unapply) logical operator.

## <span id="unapply"> Matching Aggregate

```scala
unapply(
  plan: Aggregate): Option[Long]
```

`unapply` [extractGlobalCount](#extractGlobalCount) for an `Aggregate` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Aggregate)) logical operator with the following:

* No grouping expressions
* `Alias(AggregateExpression(Count(Seq(Literal(1, _))), Complete, false, None, _), _)` aggregate expression
* [DeltaTable](../DeltaTable.md#unapply) over a [TahoeLogFileIndex](../TahoeLogFileIndex.md) with no [partition filters](../TahoeLogFileIndex.md#partitionFilters)

Otherwise, `unapply` gives `None` (to indicate no match).

---

`unapply` is used when:

* `OptimizeMetadataOnlyDeltaQuery` is requested to [optimizeQueryWithMetadata](OptimizeMetadataOnlyDeltaQuery.md#optimizeQueryWithMetadata)

## <span id="extractGlobalCount"> extractGlobalCount

```scala
extractGlobalCount(
  tahoeLogFileIndex: TahoeLogFileIndex): Option[Long]
```

`extractGlobalCount` [gets a DeltaScanGenerator](OptimizeMetadataOnlyDeltaQuery.md#getDeltaScanGenerator) for the given [TahoeLogFileIndex](../TahoeLogFileIndex.md).

`extractGlobalCount` requests the `DeltaScanGenerator` to [filesWithStatsForScan](DeltaScanGenerator.md#filesWithStatsForScan) (that gives a `DataFrame`) to execute the following aggregations on:

* `sum("stats.numRecords")`
* `count(when(col("stats.numRecords").isNull, 1))`
