# LegacyWriterFeature

`LegacyWriterFeature` is a marker extension of the [TableFeature](TableFeature.md) abstraction for [writer table features](#implementations) that were released before [Table Features](index.md) (as a `LegacyFeatureType`).

`LegacyWriterFeature`s enforce that the [minimum reader protocol version required](TableFeature.md#minReaderVersion) is always `0`.

`LegacyWriterFeature` is used when `TableFeatureSupport` is requested to [remove a table feature](TableFeatureSupport.md#removeFeature) (alongside [WriterFeature](WriterFeature.md)s).

## Implementations

??? note "Sealed Abstract Class"
    `LegacyWriterFeature` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).

* [AppendOnlyTableFeature](../append-only-tables/AppendOnlyTableFeature.md)
* [ChangeDataFeedTableFeature](../change-data-feed/ChangeDataFeedTableFeature.md)
* [CheckConstraintsTableFeature](../check-constraints/CheckConstraintsTableFeature.md)
* [GeneratedColumnsTableFeature](../generated-columns/GeneratedColumnsTableFeature.md)
* [IdentityColumnsTableFeature](../identity-columns/IdentityColumnsTableFeature.md)
* [InvariantsTableFeature](../column-invariants/InvariantsTableFeature.md)
* `LegacyReaderWriterFeature`

## Creating Instance

`LegacyWriterFeature` takes the following to be created:

* <span id="name"> [Name](TableFeature.md#name)
* <span id="minWriterVersion"> [Minimum writer protocol version required](TableFeature.md#minWriterVersion)
