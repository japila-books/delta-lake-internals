# CDCReader

`CDCReader` is a [CDCReaderImpl](CDCReaderImpl.md).

`CDCReader` utility plays the key role in [Change Data Capture](index.md) in Delta Lake (per [this comment]({{ delta.commit }}/d90f90b6656648e170835f92152b69f77346dfcf)).

## <span id="_change_data"> _change_data Directory { #CDC_LOCATION }

`CDCReader` uses `_change_data` as the name of the directory (under the data directory) where data changes of a delta table are written out (using [DelayedCommitProtocol](../DelayedCommitProtocol.md#newTaskTempFile)).

This directory may contain partition directories.

Used when:

* `DelayedCommitProtocol` is requested for the [newTaskTempFile](../DelayedCommitProtocol.md#newTaskTempFile)

## CDF Virtual Columns { #CDC_COLUMNS_IN_DATA }

```scala
CDC_COLUMNS_IN_DATA: Seq[String]
```

`CDCReader` defines a `CDC_COLUMNS_IN_DATA` collection the following CDF-specific column names:

* [__is_cdc](#CDC_PARTITION_COL)
* [_change_type](#CDC_TYPE_COLUMN_NAME)

`CDC_COLUMNS_IN_DATA` is used when:

* `ColumnWithDefaultExprUtils` is requested to [addDefaultExprsOrReturnConstraints](../ColumnWithDefaultExprUtils.md#addDefaultExprsOrReturnConstraints)
* `DeltaColumnMappingBase` is requested for the [DELTA_INTERNAL_COLUMNS](../column-mapping/DeltaColumnMappingBase.md#DELTA_INTERNAL_COLUMNS)

### <span id="__is_cdc"> __is_cdc Virtual Partition Column { #CDC_PARTITION_COL }

`CDCReader` defines `__is_cdc` column name to partition on with [Change Data Feed](#isCDCEnabledOnTable) enabled.

`__is_cdc` column is added when `TransactionalWrite` is requested to [performCDCPartition](../TransactionalWrite.md#performCDCPartition) with [CDF enabled on a delta table](#isCDCEnabledOnTable) (and [_change_type](#CDC_TYPE_COLUMN_NAME) among the columns).

If added, `__is_cdc` column becomes the first partitioning column. It is then "consumed" by [DelayedCommitProtocol](../DelayedCommitProtocol.md#cdc) (to write changes to `cdc-`-prefixed files, not `part-`).

`__is_cdc` is a [virtual column](#CDC_COLUMNS_IN_DATA).

Used when:

* `DelayedCommitProtocol` is requested to [getFileName](../DelayedCommitProtocol.md#getFileName) and [buildActionFromAddedFile](../DelayedCommitProtocol.md#buildActionFromAddedFile)

### <span id="_change_type"> Change Type Column { #CDC_TYPE_COLUMN_NAME }

`CDCReader` defines `_change_type` column name that represents the type of a data change.

Change Type | Command
------------|--------
 [delete](#CDC_TYPE_DELETE_STRING) | [Delete](../commands/delete/DeleteCommand.md#rewriteFiles)
 [insert](#CDC_TYPE_INSERT) | [WriteIntoDelta](../commands/WriteIntoDelta.md#write)
 [update_postimage](#CDC_TYPE_UPDATE_POSTIMAGE) | [Update](../commands/update/UpdateCommand.md#withUpdatedColumns)
 [update_preimage](#CDC_TYPE_UPDATE_PREIMAGE) | [Update](../commands/update/UpdateCommand.md#withUpdatedColumns)

`_change_type` is a [CDF virtual column](#CDC_COLUMNS_IN_DATA) and among the columns in the [CDF-aware read schema](CDCReaderImpl.md#cdcReadSchema).

`_change_type` is among the [cdcAttributes](#cdcAttributes).

### <span id="_commit_version"> Commit Version Column { #CDC_COMMIT_VERSION }

`CDCReader` defines `_commit_version` column name that represents...FIXME

`_commit_version` is among the [DELTA_INTERNAL_COLUMNS](../column-mapping/DeltaColumnMappingBase.md#DELTA_INTERNAL_COLUMNS).

`_commit_version` is among the [cdcAttributes](#cdcAttributes) and the [CDF-aware read schema](CDCReaderImpl.md#cdcReadSchema).

Used when:

* `CdcAddFileIndex` is requested for the [matching files](CdcAddFileIndex.md#matchingFiles)
* `TahoeChangeFileIndex` is requested for the [matching files](TahoeChangeFileIndex.md#matchingFiles) and the [partitionSchema](TahoeChangeFileIndex.md#partitionSchema)
* `TahoeRemoveFileIndex` is requested for the [matching files](TahoeRemoveFileIndex.md#matchingFiles)

## CDC_TYPE_NOT_CDC Literal { #CDC_TYPE_NOT_CDC }

```scala
CDC_TYPE_NOT_CDC: Literal
```

`CDCReader` defines `CDC_TYPE_NOT_CDC` value as a `Literal` expression with `null` value (of `StringType` type).

`CDC_TYPE_NOT_CDC` is used as a special sentinel value for rows that are part of the main table rather than change data.

`CDC_TYPE_NOT_CDC` is used by DML commands when executed with [Change Data Feed](index.md) enabled:

* [Delete](../commands/delete/index.md)
* [Merge](../commands/merge/index.md)
* [Update](../commands/update/index.md)
* [WriteIntoDelta](../commands/WriteIntoDelta.md)

All but `DeleteCommand` commands use `CDC_TYPE_NOT_CDC` with [_change_type](#CDC_TYPE_COLUMN_NAME) as follows:

```scala
Column(CDC_TYPE_NOT_CDC).as("_change_type")
```

`DeleteCommand` uses `CDC_TYPE_NOT_CDC` as follows:

```scala
.withColumn(
  "_change_type",
  Column(If(filterCondition, CDC_TYPE_NOT_CDC, Literal("delete")))
)
```

`CDC_TYPE_NOT_CDC` is used when (with [Change Data Feed](index.md) enabled):

* `DeleteCommand` is requested to [rewriteFiles](../commands/delete/DeleteCommand.md#rewriteFiles)
* `MergeIntoCommand` is requested to [run a merge](../commands/merge/MergeIntoCommand.md#runMerge) (for a non-[insert-only merge](../commands/merge/index.md#insert-only-merges) or with [merge.optimizeInsertOnlyMerge.enabled](../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) disabled that uses `ClassicMergeExecutor` to [write out merge changes](../commands/merge/ClassicMergeExecutor.md#writeAllChanges) with [generateWriteAllChangesOutputCols](../commands/merge/MergeOutputGeneration.md#generateWriteAllChangesOutputCols) and [generateCdcAndOutputRows](../commands/merge/MergeOutputGeneration.md#generateCdcAndOutputRows))
* `UpdateCommand` is requested to [withUpdatedColumns](../commands/update/UpdateCommand.md#withUpdatedColumns)
* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)

## <span id="insert"> insert Change Type { #CDC_TYPE_INSERT }

`CDCReader` uses `insert` value as the value of the [_change_type](#CDC_TYPE_COLUMN_NAME) column for the following:

* `WriteIntoDelta` is requested to [write data out](../commands/WriteIntoDelta.md#write) (with [isCDCEnabledOnTable](#isCDCEnabledOnTable))
* `MergeOutputGeneration` is requested to [generateAllActionExprs](../commands/merge/MergeOutputGeneration.md#generateAllActionExprs) and [generateCdcAndOutputRows](../commands/merge/MergeOutputGeneration.md#generateCdcAndOutputRows)
* `CdcAddFileIndex` is requested for the [matching files](CdcAddFileIndex.md#matchingFiles)
