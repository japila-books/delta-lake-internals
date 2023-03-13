# StatsProvider

## Creating Instance

`StatsProvider` takes the following to be created:

* [Statistic Column Function](#getStat)

`StatsProvider` is created alongside [DataFiltersBuilder](DataFiltersBuilder.md#statsProvider).

### <span id="getStat"> Statistic Column Function

`StatsProvider` is given a Statistic Column Function when [created](#creating-instance).

```text
StatsColumn => Option[Column]
```

The function is always [getStatsColumnOpt](DataSkippingReaderBase.md#getStatsColumnOpt).

## <span id="getPredicateWithStatType"> getPredicateWithStatType

```scala
getPredicateWithStatType(
  pathToColumn: Seq[String],
  statType: String)(
  f: Column => Column): Option[DataSkippingPredicate]
```

`getPredicateWithStatType` [getPredicateWithStatsColumn](#getPredicateWithStatsColumn) with a `StatsColumn` for the given `statType` and `pathToColumn`, and the given `f` function.

---

`getPredicateWithStatType` is used when:

* `ColumnPredicateBuilder` is requested to [lessThan](ColumnPredicateBuilder.md#lessThan), [lessThanOrEqual](ColumnPredicateBuilder.md#lessThanOrEqual), [greaterThan](ColumnPredicateBuilder.md#greaterThan), [greaterThanOrEqual](ColumnPredicateBuilder.md#greaterThanOrEqual)
* `DataFiltersBuilder` is requested to [constructDataFilters](DataFiltersBuilder.md#constructDataFilters) (for `IsNull` predicate)

### <span id="getPredicateWithStatsColumn"> getPredicateWithStatsColumn

```scala
getPredicateWithStatsColumn(
  statCol: StatsColumn)(
  f: Column => Column): Option[DataSkippingPredicate]
```

`getPredicateWithStatsColumn` uses the [getStat](#getStat) function to look up the given `statCol` and, if found (`stat`), creates a `DataSkippingPredicate` with the following:

* The result of applying the `f` function to `stat`
* The given `statCol`

## <span id="getPredicateWithStatTypes"> getPredicateWithStatTypes

```scala
getPredicateWithStatTypes(
  pathToColumn: Seq[String],
  statType1: String,
  statType2: String)(
  f: (Column, Column) => Column): Option[DataSkippingPredicate]
getPredicateWithStatTypes(
  pathToColumn: Seq[String],
  statType1: String,
  statType2: String,
  statType3: String)(
  f: (Column, Column, Column) => Column): Option[DataSkippingPredicate]
```

`getPredicateWithStatTypes` [getPredicateWithStatsColumns](#getPredicateWithStatsColumns) with a `StatsColumn` for all the given `statType`s and `pathToColumn`, and the given `f` function.

---

`getPredicateWithStatTypes` is used when:

* `ColumnPredicateBuilder` is requested to [equalTo](ColumnPredicateBuilder.md#equalTo), [notEqualTo](ColumnPredicateBuilder.md#notEqualTo)
* `DataFiltersBuilder` is requested to [constructDataFilters](DataFiltersBuilder.md#constructDataFilters) (for `StartsWith` predicate)
