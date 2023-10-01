# DeletionVectorsTableFeature

`DeletionVectorsTableFeature` is a [ReaderWriterFeature](../table-features/ReaderWriterFeature.md) known by the name of [deletionVectors](../table-features/TableFeature.md#name).

With [delta.enableDeletionVectors](../DeltaConfigs.md#enableDeletionVectors) table property enabled, `DeletionVectorsTableFeature` enables [Deletion Vectors](index.md).

`DeletionVectorsTableFeature` is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md).

## automaticallyUpdateProtocolOfExistingTables { #automaticallyUpdateProtocolOfExistingTables }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    automaticallyUpdateProtocolOfExistingTables: Boolean
    ```

    `automaticallyUpdateProtocolOfExistingTables` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables) abstraction.

`automaticallyUpdateProtocolOfExistingTables` is always enabled (`true`).

## metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is the value of [delta.enableDeletionVectors](../DeltaConfigs.md#enableDeletionVectors) table property (from the [Metadata](../DeltaConfig.md#fromMetaData)).