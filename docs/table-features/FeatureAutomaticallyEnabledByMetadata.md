# FeatureAutomaticallyEnabledByMetadata

`FeatureAutomaticallyEnabledByMetadata` is an [extension](#contract) of the [TableFeature](TableFeature.md) abstraction for [table features](#implementations) that can be enabled via a change in a table metadata.

## Contract

### metadataRequiresFeatureToBeEnabled { #metadataRequiresFeatureToBeEnabled }

```scala
metadataRequiresFeatureToBeEnabled(
  metadata: Metadata,
  spark: SparkSession): Boolean
```

`metadataRequiresFeatureToBeEnabled` is enabled (`true`) for automatically enabled features (based on [metadata](../Metadata.md) configuration)

See:

* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md#metadataRequiresFeatureToBeEnabled)

Used when:

* `Protocol` is requested for the [automatically enabled table features](../Protocol.md#extractAutomaticallyEnabledFeatures)

## Implementations

* `AppendOnlyTableFeature`
* `ChangeDataFeedTableFeature`
* `CheckConstraintsTableFeature`
* `ColumnMappingTableFeature`
* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md)
* `GeneratedColumnsTableFeature`
* `IcebergCompatV1TableFeature`
* `InvariantsTableFeature`
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
