# ClusteringTableFeature

`ClusteringTableFeature` is a [WriterFeature](../table-features/WriterFeature.md) with `clustering` name.

`ClusteringTableFeature` is among the [allSupportedFeaturesMap](../table-features/TableFeature.md#allSupportedFeaturesMap).

`ClusteringTableFeature` is used when `ClusteredTableUtilsBase` is requested for the following:

* [getTableFeatureProperties](ClusteredTableUtilsBase.md#getTableFeatureProperties)
* [isSupported](ClusteredTableUtilsBase.md#isSupported)

## requiredFeatures { #requiredFeatures }

??? note "TableFeature"

    ```scala
    requiredFeatures: Set[TableFeature]
    ```

    `requiredFeatures` is part of the [TableFeature](../table-features/TableFeature.md#requiredFeatures) abstraction.

`requiredFeatures` is a [DomainMetadataTableFeature](../table-features/DomainMetadataTableFeature.md).
