# AppendOnlyTableFeature

`AppendOnlyTableFeature` is a [LegacyWriterFeature](../table-features/LegacyWriterFeature.md) with the following properties:

Property | Value
---------|------
 [Name](../table-features/LegacyWriterFeature.md#name) | `appendOnly`
 [Minimum writer protocol version](../table-features/LegacyWriterFeature.md#minWriterVersion) | `2`

`AppendOnlyTableFeature` is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md) that uses [delta.appendOnly](../DeltaConfigs.md#appendOnly) table property to control [Append-Only Tables](index.md) feature.

## metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is the value of [delta.appendOnly](../DeltaConfigs.md#IS_APPEND_ONLY) table property (from the [Metadata](../DeltaConfig.md#fromMetaData)).
