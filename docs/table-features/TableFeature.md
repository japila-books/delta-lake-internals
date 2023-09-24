# TableFeature

`TableFeature` is an abstraction of [table features](#implementations).

`TableFeature` is `Serializable` ([Java]({{ java.api }}/java/io/Serializable.html)).

## Creating Instance

`TableFeature` takes the following to be created:

* [name](#name)
* <span id="minReaderVersion"> `minReaderVersion`
* <span id="minWriterVersion"> `minWriterVersion`

!!! note "Abstract Class"
    `TableFeature` is an abstract class and cannot be created directly. It is created indirectly for the [concrete TableFeatures](#implementations).

### Name { #name }

```scala
name: String
```

The name of this table feature

The name can only be a combination of letters, `-`s (dashes) and `_`s (underscores).

Used when:

* `DeltaLog` is requested to [assertTableFeaturesMatchMetadata](../DeltaLog.md#assertTableFeaturesMatchMetadata) (for reporting purposes)
* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal) and [recordProtocolChanges](../OptimisticTransactionImpl.md#recordProtocolChanges)
* `TableFeature` is requested to [allSupportedFeaturesMap](TableFeature.md#allSupportedFeaturesMap)
* `Protocol` is requested to [forTableFeature](../Protocol.md#forTableFeature)
* `TableFeatureSupport` is requested to [withFeature](TableFeatureSupport.md#withFeature), [canUpgradeTo](TableFeatureSupport.md#canUpgradeTo), [isFeatureSupported](TableFeatureSupport.md#isFeatureSupported), [propertyKey](TableFeatureSupport.md#propertyKey), [defaultPropertyKey](TableFeatureSupport.md#defaultPropertyKey)
* `DescribeDeltaDetailCommand` is executed (and requested to [describeDeltaTable](../commands/describe-detail/DescribeDeltaDetailCommand.md#describeDeltaTable))

## Implementations

* `LegacyWriterFeature`
* `WriterFeature`

??? note "Sealed Abstract Class"
    `TableFeature` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).
