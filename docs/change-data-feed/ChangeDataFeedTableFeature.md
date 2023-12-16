# ChangeDataFeedTableFeature

`ChangeDataFeedTableFeature` is a [LegacyWriterFeature](../table-features/LegacyWriterFeature.md) with the following properties:

Property | Value
---------|------
 [Name](../table-features/LegacyWriterFeature.md#name) | `changeDataFeed`
 [Minimum writer protocol version](../table-features/LegacyWriterFeature.md#minWriterVersion) | `4`

`ChangeDataFeedTableFeature` is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md) that uses [delta.enableChangeDataFeed](../DeltaConfigs.md#enableChangeDataFeed) table property to control [Change Data Feed](index.md) feature.

## metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is the value of [delta.enableChangeDataFeed](../DeltaConfigs.md#enableChangeDataFeed) table property in (the [configuration](../Metadata.md#configuration) of) the given [Metadata](../Metadata.md).
