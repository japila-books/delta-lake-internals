# DataFiltersBuilder

`DataFiltersBuilder` builds data filters for [Data Skipping](index.md).

`DataFiltersBuilder` used when `DataSkippingReaderBase` is requested for the [filesForScan](DataSkippingReaderBase.md#filesForScan) with data filters and [spark.databricks.delta.stats.skipping](../configuration-properties/DeltaSQLConf.md#stats.skipping) enabled.

## Creating Instance

`DataFiltersBuilder` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="dataSkippingType"> [DeltaDataSkippingType](DeltaDataSkippingType.md)

`DataFiltersBuilder` is created when:

* `DataSkippingReaderBase` is requested to [filesForScan](DataSkippingReaderBase.md#filesForScan) (with data filters and [spark.databricks.delta.stats.skipping](../configuration-properties/DeltaSQLConf.md#stats.skipping) enabled)

### <span id="statsProvider"> StatsProvider

`DataFiltersBuilder` creates a [StatsProvider](StatsProvider.md) (for the [getStatsColumnOpt](DataSkippingReaderBase.md#getStatsColumnOpt)) when [created](#creating-instance).

## <span id="apply"> Creating DataSkippingPredicate

```scala
apply(
  dataFilter: Expression): Option[DataSkippingPredicate]
```

`apply` [constructDataFilters](#constructDataFilters) for the given `dataFilter` expression.

---

`apply` is used when:

* `DataSkippingReaderBase` is requested to [filesForScan](DataSkippingReaderBase.md#filesForScan) (with data filters and [spark.databricks.delta.stats.skipping](../configuration-properties/DeltaSQLConf.md#stats.skipping) enabled)

### <span id="constructDataFilters"> constructDataFilters

```scala
constructDataFilters(
  dataFilter: Expression): Option[DataSkippingPredicate]
```

`constructDataFilters` creates a `DataSkippingPredicate` for expression types that can be used for data skipping.

---

`constructDataFilters`...FIXME

For `IsNull` with a skipping-eligible column, `constructDataFilters` requests the [StatsProvider](#statsProvider) for the [getPredicateWithStatType](StatsProvider.md#getPredicateWithStatType) for [nullCount](UsesMetadataFields.md#nullCount) to build a Catalyst expression to match files with null count larger than zero.

```text
nullCount > Literal(0)
```

For `IsNotNull` with a skipping-eligible column, `constructDataFilters` creates `StatsColumn`s for the following:

* [nullCount](UsesMetadataFields.md#nullCount)
* [numRecords](UsesMetadataFields.md#numRecords)

`constructDataFilters` requests the [StatsProvider](#statsProvider) for the [getPredicateWithStatsColumns](StatsProvider.md#getPredicateWithStatsColumns) for the two `StatsColumn`s to build a Catalyst expression to match files with null count less than the row count.

```text
nullCount < numRecords
```

`constructDataFilters`...FIXME

### <span id="constructLiteralInListDataFilters"> constructLiteralInListDataFilters

```scala
constructLiteralInListDataFilters(
  a: Expression,
  possiblyNullValues: Seq[Any]): Option[DataSkippingPredicate]
```

`constructLiteralInListDataFilters`...FIXME
