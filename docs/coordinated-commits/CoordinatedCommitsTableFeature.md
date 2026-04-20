# CoordinatedCommitsTableFeature

`CoordinatedCommitsTableFeature` is a [WriterFeature](../table-features/WriterFeature.md) with [coordinatedCommits-preview](../table-features/WriterFeature.md#name) name.

`CoordinatedCommitsTableFeature` is a [FeatureAutomaticallyEnabledByMetadata](#FeatureAutomaticallyEnabledByMetadata) table feature by [delta.coordinatedCommits.commitCoordinator-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_NAME) table property.

`CoordinatedCommitsTableFeature` is a [RemovableFeature](../table-features/RemovableFeature.md).

## FeatureAutomaticallyEnabledByMetadata { #FeatureAutomaticallyEnabledByMetadata }

`CoordinatedCommitsTableFeature` is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md).

### automaticallyUpdateProtocolOfExistingTables { #automaticallyUpdateProtocolOfExistingTables }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    automaticallyUpdateProtocolOfExistingTables: Boolean
    ```

    `automaticallyUpdateProtocolOfExistingTables` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables) abstraction.

`automaticallyUpdateProtocolOfExistingTables` is always enabled (`true`).

### metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

??? note "FeatureAutomaticallyEnabledByMetadata"

    ```scala
    metadataRequiresFeatureToBeEnabled(
      protocol: Protocol,
      metadata: Metadata,
      spark: SparkSession): Boolean
    ```

    `metadataRequiresFeatureToBeEnabled` is part of the [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) abstraction.

`metadataRequiresFeatureToBeEnabled` is enabled (`true`) when [delta.coordinatedCommits.commitCoordinator-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_NAME) table property [can be found](../table-properties/DeltaConfig.md#fromMetaData) in the given [Metadata](../Metadata.md).

## Required Table Features { #requiredFeatures }

??? note "TableFeature"

    ```scala
    requiredFeatures: Set[TableFeature]
    ```

    `requiredFeatures` is part of the [TableFeature](../table-features/TableFeature.md#requiredFeatures) abstraction.

`requiredFeatures` is a collection with the following [table features](../table-features/TableFeature.md):

* [InCommitTimestampTableFeature](../table-features/InCommitTimestampTableFeature.md)
* [VacuumProtocolCheckTableFeature](../table-features/VacuumProtocolCheckTableFeature.md)
