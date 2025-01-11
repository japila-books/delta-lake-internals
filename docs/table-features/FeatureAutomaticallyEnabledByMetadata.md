# FeatureAutomaticallyEnabledByMetadata

`FeatureAutomaticallyEnabledByMetadata` is an [extension](#contract) of the [TableFeature](TableFeature.md) abstraction for [table features](#implementations) that can be enabled via a change in a table metadata.

## Contract

### metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

```scala
metadataRequiresFeatureToBeEnabled(
  metadata: Metadata,
  spark: SparkSession): Boolean
```

Controls whether this [TableFeature](TableFeature.md) should be enabled because its metadata requirements are satisfied (e.g., a table property is enabled in the [configuration](../Metadata.md#configuration) of the given [Metadata](../Metadata.md))

Enabled (`true`) for automatically enabled features (based on [metadata](../Metadata.md) configuration)

See:

* [AppendOnlyTableFeature](../append-only-tables/AppendOnlyTableFeature.md#metadataRequiresFeatureToBeEnabled)
* [ChangeDataFeedTableFeature](../change-data-feed/ChangeDataFeedTableFeature.md#metadataRequiresFeatureToBeEnabled)
* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md#metadataRequiresFeatureToBeEnabled)
* [IdentityColumnsTableFeature](../identity-columns/IdentityColumnsTableFeature.md#metadataRequiresFeatureToBeEnabled)
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md#metadataRequiresFeatureToBeEnabled)

Used when:

* `Protocol` is requested for the [automatically enabled table features](../Protocol.md#extractAutomaticallyEnabledFeatures)

## Implementations

* [AppendOnlyTableFeature](../append-only-tables/AppendOnlyTableFeature.md)
* [ChangeDataFeedTableFeature](../change-data-feed/ChangeDataFeedTableFeature.md)
* [CheckConstraintsTableFeature](../check-constraints/CheckConstraintsTableFeature.md)
* [ColumnMappingTableFeature](../column-mapping/ColumnMappingTableFeature.md)
* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md)
* [GeneratedColumnsTableFeature](../generated-columns/GeneratedColumnsTableFeature.md)
* `IcebergCompatV1TableFeature`
* [InvariantsTableFeature](../column-invariants/InvariantsTableFeature.md)
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md)
* `TimestampNTZTableFeature`

??? note "Sealed Trait"
    `FeatureAutomaticallyEnabledByMetadata` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#sealed).

## Auto-Update Capable Table Feature { #automaticallyUpdateProtocolOfExistingTables }

```scala
automaticallyUpdateProtocolOfExistingTables: Boolean
```

`automaticallyUpdateProtocolOfExistingTables` is enabled (`true`) for a [legacy feature](TableFeature.md#isLegacyFeature) only by default.

!!! note "Auto-Update Capable Table Feature"
    Non-legacy features are supposed to override this method to become **auto-update capable**.

See:

* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md#automaticallyUpdateProtocolOfExistingTables)
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md#automaticallyUpdateProtocolOfExistingTables)

---

`automaticallyUpdateProtocolOfExistingTables` is used when:

* `Protocol` is requested to [assertMetadataTableFeaturesAutomaticallySupported](../Protocol.md#assertMetadataTableFeaturesAutomaticallySupported)
