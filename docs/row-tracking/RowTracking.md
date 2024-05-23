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

1. [delta.enableRowTracking](../table-properties/DeltaConfigs.md#ROW_TRACKING_ENABLED) table property is enabled ([in the given Metadata](../table-properties/DeltaConfig.md#fromMetaData))
1. Row Tracking feature [is supported](#isSupported)

!!! danger "Not Used"
    `isEnabled` does not seem to be used.

## addPreservedRowTrackingTagIfNotSet { #addPreservedRowTrackingTagIfNotSet }

```scala
addPreservedRowTrackingTagIfNotSet(
  snapshot: SnapshotDescriptor,
  tagsMap: Map[String, String] = Map.empty): Map[String, String]
```

`addPreservedRowTrackingTagIfNotSet`...FIXME

---

`addPreservedRowTrackingTagIfNotSet` is used when:

* [DeleteCommand](../commands/delete/DeleteCommand.md) is executed
* [MergeIntoCommand](../commands/merge/MergeIntoCommand.md) is [executed](../commands/merge/MergeIntoCommand.md#runMerge)
* `OptimizeExecutor` is requested to [commitAndRetry](../commands/optimize/OptimizeExecutor.md#commitAndRetry)
* `UpdateCommand` is requested to [performUpdate](../commands/update/UpdateCommand.md#performUpdate)
* `RemoveColumnMappingCommand` is requested to [executed](../commands/alter/RemoveColumnMappingCommand.md#run)
