# TableFeatureProtocolUtils

## <span id="FEATURE_PROP_PREFIX"> delta.feature Property Prefix { #delta.feature }

`TableFeatureProtocolUtils` defines the following property prefix for table features:

```text
delta.feature.
```

`delta.feature` is used when:

* `DeltaConfigsBase` is requested to [validateConfigurations](../DeltaConfigs.md#validateConfigurations), [mergeGlobalConfigs](../DeltaConfigs.md#mergeGlobalConfigs), [normalizeConfigKeys](../DeltaConfigs.md#normalizeConfigKeys), [normalizeConfigKey](../DeltaConfigs.md#normalizeConfigKey)
* `Snapshot` is requested to [getProperties](../Snapshot.md#getProperties)
* `Protocol` is requested to [assertMetadataContainsNoProtocolProps](../Protocol.md#assertMetadataContainsNoProtocolProps)
* `TableFeatureProtocolUtils` is requested to [propertyKey](#propertyKey), [getSupportedFeaturesFromTableConfigs](#getSupportedFeaturesFromTableConfigs), [isTableProtocolProperty](#isTableProtocolProperty)

## isTableProtocolProperty { #isTableProtocolProperty }

```scala
isTableProtocolProperty(
  key: String): Boolean
```

`isTableProtocolProperty` holds `true` when the given `key` is one of the following:

* [delta.minReaderVersion](../Protocol.md#MIN_READER_VERSION_PROP)
* [delta.minWriterVersion](../Protocol.md#MIN_WRITER_VERSION_PROP)
* [delta.ignoreProtocolDefaults](../DeltaConfigs.md#CREATE_TABLE_IGNORE_PROTOCOL_DEFAULTS)
* The `key` starts with the [delta.feature.](#FEATURE_PROP_PREFIX) prefix

---

`isTableProtocolProperty` is used when:

* `DeltaConfigsBase` is requested to [mergeGlobalConfigs](../DeltaConfigs.md#mergeGlobalConfigs)
* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal)
* `Protocol` is requested to [forNewTable](../Protocol.md#forNewTable)

## getSupportedFeaturesFromTableConfigs { #getSupportedFeaturesFromTableConfigs }

```scala
getSupportedFeaturesFromTableConfigs(
  configs: Map[String, String]): Set[TableFeature]
```

`getSupportedFeaturesFromTableConfigs`...FIXME

---

`getSupportedFeaturesFromTableConfigs` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal)
* `Protocol` is requested to [minProtocolComponentsFromMetadata](../Protocol.md#minProtocolComponentsFromMetadata)

## Property Key of Table Feature { #propertyKey }

```scala
propertyKey(
  feature: TableFeature): String
propertyKey(
  featureName: String): String
```

`propertyKey` is the following text:

```text
delta.feature.[featureName]
```

---

`propertyKey` is used when:

* `DeltaTable` is requested to [addFeatureSupport](../DeltaTable.md#addFeatureSupport)

## getSupportedFeaturesFromTableConfigs { #getSupportedFeaturesFromTableConfigs }

```scala
getSupportedFeaturesFromTableConfigs(
  configs: Map[String, String]): Set[TableFeature]
```

`getSupportedFeaturesFromTableConfigs` takes all the `delta.feature.`-prefixed keys in the given `configs` collection and makes sure that all `supported` or `enabled`.

!!! note "`enabled` Deprecated"
    `enabled` is deprecated.

If there is a table feature not `supported` or [there's no table feature by a name](TableFeature.md#featureNameToFeature), `getSupportedFeaturesFromTableConfigs` reports an exception.

---

`getSupportedFeaturesFromTableConfigs` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal)
* `Protocol` is requested to [minProtocolComponentsFromMetadata](../Protocol.md#minProtocolComponentsFromMetadata)
