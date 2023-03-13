# ColumnPredicateBuilder

`ColumnPredicateBuilder` is a [DataSkippingPredicateBuilder](DataSkippingPredicateBuilder.md) that [UsesMetadataFields](UsesMetadataFields.md).

## <span id="equalTo"> equalTo

??? note "Signature"

    ```scala
    equalTo(
      statsProvider: StatsProvider,
      colPath: Seq[String],
      value: Column): Option[DataSkippingPredicate]
    ```

    `equalTo` is part of the [DataSkippingPredicateBuilder](DataSkippingPredicateBuilder.md#equalTo) abstraction.

`equalTo` requests the given [StatsProvider](StatsProvider.md) for [getPredicateWithStatTypes](StatsProvider.md#getPredicateWithStatTypes) for the given `colPath` and the following metadata:

* [minValues](UsesMetadataFields.md#minValues)
* [maxValues](UsesMetadataFields.md#maxValues)

`equalTo` builds a Catalyst expression to match files with the requested `value`:

```text
min <= value && value <= max
```

## <span id="greaterThan"> greaterThan

??? note "Signature"

    ```scala
    greaterThan(
      statsProvider: StatsProvider,
      colPath: Seq[String],
      value: Column): Option[DataSkippingPredicate]
    ```

    `greaterThan` is part of the [DataSkippingPredicateBuilder](DataSkippingPredicateBuilder.md#greaterThan) abstraction.

`greaterThan` requests the given [StatsProvider](StatsProvider.md) for [getPredicateWithStatType](StatsProvider.md#getPredicateWithStatType) for the given `colPath` and the following metadata:

* [maxValues](UsesMetadataFields.md#maxValues)

`greaterThan` builds a Catalyst expression to match files with the requested `value`:

```text
c > value
```
