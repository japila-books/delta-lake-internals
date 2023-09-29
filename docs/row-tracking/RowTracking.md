# RowTracking

## isSupported { #isSupported }

```scala
isSupported(
  protocol: Protocol): Boolean
```

`isSupported` checks if [RowTrackingFeature](RowTrackingFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the given [Protocol](../Protocol.md).

---

`isSupported` is used when:

* `ConflictChecker` is requested to [reassignRowCommitVersions](../ConflictChecker.md#reassignRowCommitVersions)
* `DefaultRowCommitVersion` is requested to [assignIfMissing](DefaultRowCommitVersion.md#assignIfMissing)
* `RowId` is requested to [isSupported](RowId.md#isSupported)
* `RowTracking` is requested to [isEnabled](#isEnabled)

## isEnabled { #isEnabled }

```scala
isEnabled(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`isEnabled` is enabled (`true`) when the following are all met:

1. [delta.enableRowTracking](../DeltaConfigs.md#ROW_TRACKING_ENABLED) table property is enabled ([in the given Metadata](../DeltaConfig.md#fromMetaData))
1. Row Tracking feature [is supported](#isSupported)

!!! danger "Not Used"
    `isEnabled` does not seem to be used.
