# IcebergCompat

## knownVersions { #knownVersions }

`IcebergCompat` defines a collection of Iceberg Compatibility-related table properties and the versions:

 Table Property | ID
-|-
 [delta.enableIcebergCompatV1](../table-properties/DeltaConfigs.md#ICEBERG_COMPAT_V1_ENABLED) | 1
 [delta.enableIcebergCompatV2](../table-properties/DeltaConfigs.md#ICEBERG_COMPAT_V2_ENABLED) | 2

## isAnyEnabled { #isAnyEnabled }

```scala
isAnyEnabled(
  metadata: Metadata): Boolean
```

`isAnyEnabled` checks if any version of the Iceberg Compatibility (table properties) is enabled (`true`) in the given [Metadata](../Metadata.md).

---

`isAnyEnabled` is used when:

* `UniversalFormat` is requested to [enforceIcebergInvariantsAndDependencies](UniversalFormat.md#enforceIcebergInvariantsAndDependencies)
* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles)
