# RowTracking

## checkStatsCollectedIfRowTrackingSupported { #checkStatsCollectedIfRowTrackingSupported }

```scala
checkStatsCollectedIfRowTrackingSupported(
  protocol: Protocol,
  convertToDeltaShouldCollectStats: Boolean,
  statsCollectionEnabled: Boolean): Unit
```

??? warning "Procedure"
    `checkStatsCollectedIfRowTrackingSupported` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`checkStatsCollectedIfRowTrackingSupported`...FIXME

---

`checkStatsCollectedIfRowTrackingSupported` is used when:

* [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md) is executed (and [performConvert](../commands/convert/ConvertToDeltaCommand.md#performConvert))

## isSupported { #isSupported }

```scala
isSupported(
  protocol: Protocol): Boolean
```

`isSupported` says whether the given [protocol](../Protocol.md) supports the [Row Tracking](index.md) table feature.

Internally, `isSupported` checks if [RowTrackingFeature](RowTrackingFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the given [Protocol](../Protocol.md).

---

`isSupported` is used when:

* `ConflictChecker` is requested to [reassignRowCommitVersions](../ConflictChecker.md#reassignRowCommitVersions)
* `DefaultRowCommitVersion` is requested to [assignIfMissing](DefaultRowCommitVersion.md#assignIfMissing)
* `MaterializedRowTrackingColumn` is requested to [updateMaterializedColumnName](MaterializedRowTrackingColumn.md#updateMaterializedColumnName)
* `RowId` is requested to [isSupported](RowId.md#isSupported)
* `RowTracking` is requested to [checkStatsCollectedIfRowTrackingSupported](#checkStatsCollectedIfRowTrackingSupported) and [isEnabled](#isEnabled)

## isEnabled { #isEnabled }

```scala
isEnabled(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`isEnabled` is enabled (`true`) when the following are all met:

1. [delta.enableRowTracking](../table-properties/DeltaConfigs.md#ROW_TRACKING_ENABLED) table property is enabled ([in the given table metadata](../table-properties/DeltaConfig.md#fromMetaData))
1. Row Tracking feature [is supported](#isSupported)

---

`isEnabled` throws an `IllegalStateException` when the [delta.enableRowTracking](../table-properties/DeltaConfigs.md#ROW_TRACKING_ENABLED) table property is enabled but the feature [is not supported](#isSupported) by the given [Protocol](../Protocol.md):

```text
Table property 'delta.enableRowTracking' is set on the table
but this table version doesn't support table feature 'delta.feature.rowTracking'.
```

---

`isEnabled` is used when:

* `DefaultRowCommitVersion` is requested to [createDefaultRowCommitVersionField](DefaultRowCommitVersion.md#createDefaultRowCommitVersionField)
* `DeltaScanWithRowTrackingEnabled` is requested to `unapply`
* `MaterializedRowTrackingColumn` is requested to `getAttribute` and `getMaterializedColumnName`
* `RowCommitVersion` is requested to [preserveRowCommitVersions](RowCommitVersion.md#preserveRowCommitVersions)
* `RowId` is requested to [throwIfMaterializedRowIdColumnNameIsInvalid](RowId.md#throwIfMaterializedRowIdColumnNameIsInvalid)
* `RowTracking` is requested to [addPreservedRowTrackingTagIfNotSet](#addPreservedRowTrackingTagIfNotSet)

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

## createMetadataStructFields { #createMetadataStructFields }

```scala
createMetadataStructFields(
  protocol: Protocol,
  metadata: Metadata,
  nullable: Boolean): Iterable[StructField]
```

`createMetadataStructFields`...FIXME

---

`createMetadataStructFields` is used when:

* `DeltaParquetFileFormat` is requested to [metadataSchemaFields](../DeltaParquetFileFormat.md#metadataSchemaFields)

## preserveRowTrackingColumns { #preserveRowTrackingColumns }

```scala
preserveRowTrackingColumns(
  dfWithoutRowTrackingColumns: DataFrame,
  snapshot: SnapshotDescriptor): DataFrame
```

`preserveRowTrackingColumns`...FIXME

---

`preserveRowTrackingColumns` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)
* `OptimizeExecutor` is requested to [runOptimizeBinJob](../commands/optimize/OptimizeExecutor.md#runOptimizeBinJob)
* `UpdateCommand` is requested to [preserveRowTrackingColumns](../commands/update/UpdateCommand.md#preserveRowTrackingColumns)
* `RemoveColumnMappingCommand` is requested to [writeData](../commands/alter/RemoveColumnMappingCommand.md#writeData)
* `ClassicMergeExecutor` is requested to [writeAllChanges](../commands/merge/ClassicMergeExecutor.md#writeAllChanges)
