# DeletionVectorsTableFeature

`DeletionVectorsTableFeature` is a [ReaderWriterFeature](ReaderWriterFeature.md) with [FeatureAutomaticallyEnabledByMetadata](FeatureAutomaticallyEnabledByMetadata.md).

## Name { #name }

??? note "ReaderWriterFeature"

    ```scala
    name: String
    ```

    `name` is part of the [ReaderWriterFeature](ReaderWriterFeature.md#name) abstraction.

`name` is `deletionVectors`.

## automaticallyUpdateProtocolOfExistingTables { #automaticallyUpdateProtocolOfExistingTables }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    automaticallyUpdateProtocolOfExistingTables: Boolean
    ```

    `automaticallyUpdateProtocolOfExistingTables` is part of the [FeatureAutomaticallyEnabledByMetadata](FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables) abstraction.

`automaticallyUpdateProtocolOfExistingTables` is always enabled (`true`).

## metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is the value of [delta.enableDeletionVectors](../DeltaConfigs.md#enableDeletionVectors) table property.
