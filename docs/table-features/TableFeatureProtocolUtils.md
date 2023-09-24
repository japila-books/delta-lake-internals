# TableFeatureProtocolUtils

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
