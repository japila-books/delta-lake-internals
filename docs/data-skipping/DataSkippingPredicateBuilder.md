# DataSkippingPredicateBuilder

`DataSkippingPredicateBuilder` is an [abstraction](#contract) of [predicate builders](#implementations) in [Data Skipping](index.md).

## Contract (Subset)

### <span id="equalTo"> equalTo

```scala
equalTo(
  statsProvider: StatsProvider,
  colPath: Seq[String],
  value: Column): Option[DataSkippingPredicate]
```

`DataSkippingPredicate` that matches files (based on their min/max range) which contains the requested point

See:

* [ColumnPredicateBuilder](ColumnPredicateBuilder.md#equalTo)

Used when:

* `DataFiltersBuilder` is requested to [constructDataFilters](DataFiltersBuilder.md#constructDataFilters) for `EqualTo` predicate

### <span id="greaterThan"> greaterThan

```scala
greaterThan(
  statsProvider: StatsProvider,
  colPath: Seq[String],
  value: Column): Option[DataSkippingPredicate]
```

`DataSkippingPredicate` that matches files (based on their min/max range) which contains values larger than the requested lower bound

See:

* [ColumnPredicateBuilder](ColumnPredicateBuilder.md#greaterThan)

Used when:

* `DataFiltersBuilder` is requested to [constructDataFilters](DataFiltersBuilder.md#constructDataFilters) for `GreaterThan` predicate

## Implementations

* [ColumnPredicateBuilder](ColumnPredicateBuilder.md)
