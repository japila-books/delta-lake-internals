# RowId

## extractHighWatermark { #extractHighWatermark }

```scala
extractHighWatermark(
  snapshot: Snapshot): Option[Long]
```

`extractHighWatermark`...FIXME

---

`extractHighWatermark` is used when:

* `OptimisticTransactionImpl` is requested to [commitImpl](../OptimisticTransactionImpl.md#commitImpl)
* `RowId` is requested to [assignFreshRowIds](#assignFreshRowIds)

## isSupported { #isSupported }

```scala
isSupported(
  protocol: Protocol): Boolean
```

`isSupported` [isSupported](RowTracking.md#isSupported) with the given [Protocol](../Protocol.md).

---

`isSupported` is used when:

* `ConflictChecker` is requested to [reassignOverlappingRowIds](../ConflictChecker.md#reassignOverlappingRowIds)
* `RowId` is requested to [isEnabled](#isEnabled), [assignFreshRowIds](#assignFreshRowIds), [checkStatsCollectedIfRowTrackingSupported](#checkStatsCollectedIfRowTrackingSupported)

## isEnabled { #isEnabled }

```scala
isEnabled(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`isEnabled` holds `true` when the following are all met:

1. [delta.enableRowTracking](../table-properties/DeltaConfigs.md#enableRowTracking) table property is enabled ([in the given Metadata](../table-properties/DeltaConfig.md#fromMetaData))
1. Row Tracking feature [is supported](#isSupported)

!!! note "RowTracking"
    This is an exact copy of [RowTracking.isEnabled](RowTracking.md#isEnabled).

---

`isEnabled` is used when:

* `RowId` is requested to [verifyMetadata](#verifyMetadata)

## assignFreshRowIds { #assignFreshRowIds }

```scala
assignFreshRowIds(
  protocol: Protocol,
  snapshot: Snapshot,
  actions: Iterator[Action]): Iterator[Action]
```

`assignFreshRowIds`...FIXME

---

`assignFreshRowIds` is used when:

* `OptimisticTransactionImpl` is requested to [commitLarge](../OptimisticTransactionImpl.md#commitLarge), [prepareCommit](../OptimisticTransactionImpl.md#prepareCommit)

## checkStatsCollectedIfRowTrackingSupported { #checkStatsCollectedIfRowTrackingSupported }

```scala
checkStatsCollectedIfRowTrackingSupported(
  protocol: Protocol,
  convertToDeltaShouldCollectStats: Boolean,
  statsCollectionEnabled: Boolean): Unit
```

??? warning "Procedure"
    `checkStatsCollectedIfRowTrackingSupported` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`checkStatsCollectedIfRowTrackingSupported` throws a `DeltaIllegalStateException` when either the given `convertToDeltaShouldCollectStats` or `statsCollectionEnabled` flag are disabled (`false`).

Otherwise, `checkStatsCollectedIfRowTrackingSupported` does nothing.

---

`checkStatsCollectedIfRowTrackingSupported` is used when:

* `ConvertToDeltaCommandBase` is requested to [performConvert](../commands/convert/ConvertToDeltaCommand.md#performConvert)

## verifyMetadata { #verifyMetadata }

```scala
verifyMetadata(
  oldProtocol: Protocol,
  newProtocol: Protocol,
  oldMetadata: Metadata,
  newMetadata: Metadata,
  isCreatingNewTable: Boolean): Unit
```

??? warning "Procedure"
    `verifyMetadata` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`verifyMetadata` throws an `UnsupportedOperationException` when...FIXME

---

`verifyMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal)
