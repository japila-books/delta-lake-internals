# AppendOnlyTableFeature

`AppendOnlyTableFeature` is a [LegacyWriterFeature](../table-features/LegacyWriterFeature.md) known by the name of [appendOnly](../table-features/TableFeature.md#name) for [Append-Only Tables](index.md).

The [minimum writer protocol version](../table-features/TableFeature.md#minWriterVersion) that supports `AppendOnlyTableFeature` is `2`.

`AppendOnlyTableFeature` is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md) that uses [delta.appendOnly](../DeltaConfigs.md#appendOnly) table property to enable [Append-Only Tables](index.md).

## metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is the value of [delta.appendOnly](../DeltaConfigs.md#IS_APPEND_ONLY) table property (from the [Metadata](../DeltaConfig.md#fromMetaData)).
