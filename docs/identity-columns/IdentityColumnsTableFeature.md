# IdentityColumnsTableFeature

`IdentityColumnsTableFeature` is a [LegacyWriterFeature](../table-features/LegacyWriterFeature.md) with the following properties:

Feature Property | Value
-|-
 [name](../table-features/LegacyWriterFeature.md#name) | `identityColumns`
 [minWriterVersion](../table-features/LegacyWriterFeature.md#minWriterVersion) | 6

`IdentityColumnsTableFeature` [can be enabled via table metadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md).

## metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      protocol: Protocol,
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is enabled (`true`) when the [table schema](../Metadata.md#schema) (from the given [Metadata](../Metadata.md)) [has an identity column](../ColumnWithDefaultExprUtils.md#hasIdentityColumn).
