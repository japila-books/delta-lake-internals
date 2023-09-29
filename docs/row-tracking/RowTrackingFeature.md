# RowTrackingFeature

`RowTrackingFeature` is a [WriterFeature](../table-features/WriterFeature.md) known by the name of [rowTracking](../table-features/TableFeature.md#name).

With [delta.enableRowTracking](../DeltaConfigs.md#ROW_TRACKING_ENABLED) table property enabled, `RowTrackingFeature` enables [Row Tracking](index.md).

`RowTrackingFeature` is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md).

## Auto-Update Capable Table Feature { #automaticallyUpdateProtocolOfExistingTables }

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

`metadataRequiresFeatureToBeEnabled` is the value of [delta.enableRowTracking](../DeltaConfigs.md#ROW_TRACKING_ENABLED) table property (from the [Metadata](../DeltaConfig.md#fromMetaData)).

## Required Features { #requiredFeatures }

??? note "TableFeature"

    ```scala
    requiredFeatures: Set[TableFeature]
    ```

    `requiredFeatures` is part of the [TableFeature](../table-features/TableFeature.md#requiredFeatures) abstraction.

`requiredFeatures` is a single-element collection:

* [DomainMetadataTableFeature](../table-features/DomainMetadataTableFeature.md)
