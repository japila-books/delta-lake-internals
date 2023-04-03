# CDCReader

`CDCReader` utility is the key class for CDF and CDC in DeltaLake (per [this comment](https://github.com/delta-io/delta/commit/d90f90b6656648e170835f92152b69f77346dfcf)).

## <span id="getCDCRelation"> getCDCRelation

```scala
getCDCRelation(
  spark: SparkSession,
  deltaLog: DeltaLog,
  snapshotToUse: Snapshot,
  partitionFilters: Seq[Expression],
  conf: SQLConf,
  options: CaseInsensitiveStringMap): BaseRelation
```

!!! note
    `partitionFilters` argument is not used.

`getCDCRelation` [getVersionForCDC](#getVersionForCDC) (with the [startingVersion](../delta/DeltaDataSource.md#CDC_START_VERSION_KEY) and [startingTimestamp](../delta/DeltaDataSource.md#CDC_START_TIMESTAMP_KEY) for the version and timestamp keys, respectively).

`getCDCRelation`...FIXME

`getCDCRelation` is used when:

* `DeltaLog` is requested to [create a relation](../DeltaLog.md#createRelation)

### <span id="getVersionForCDC"> Resolving Version

```scala
getVersionForCDC(
  spark: SparkSession,
  deltaLog: DeltaLog,
  conf: SQLConf,
  options: CaseInsensitiveStringMap,
  versionKey: String,
  timestampKey: String): Option[Long]
```

`getVersionForCDC` uses the given `options` map to get the value of the given `versionKey` key, if available.

!!! note "When `versionKey` and `timestampKey` are specified"
    `versionKey` and `timestampKey` are specified in the given `options` argument that is passed down through [getCDCRelation](#getCDCRelation) unmodified when `DeltaLog` is requested to [create a relation](../DeltaLog.md#createRelation) with non-empty `cdcOptions`.

Otherwise, `getVersionForCDC` uses the given `options` map to get the value of the given `timestampKey` key, if available. `getVersionForCDC`...FIXME

If neither the given `versionKey` nor the `timestampKey` key is available in the `options` map, `getVersionForCDC` returns `None` (_undefined value_).

## <span id="CDC_LOCATION"><span id="_change_data"> _change_data Directory

`CDCReader` defines `_change_data` as the name of the directory (under the data directory) where data changes of a delta table are written out (using [DelayedCommitProtocol](../DelayedCommitProtocol.md#newTaskTempFile)). This directory may contain partition directories.

Used when:

* `DelayedCommitProtocol` is requested for the [newTaskTempFile](../DelayedCommitProtocol.md#newTaskTempFile)

## <span id="CDC_COLUMNS_IN_DATA"> CDF Virtual Columns

```scala
CDC_COLUMNS_IN_DATA: Seq[String]
```

`CDCReader` defines a `CDC_COLUMNS_IN_DATA` collection with [__is_cdc](#CDC_PARTITION_COL) and [_change_type](#CDC_TYPE_COLUMN_NAME) CDF-specific column names.

### <span id="CDC_PARTITION_COL"><span id="__is_cdc"> __is_cdc Partition Column

`CDCReader` defines `__is_cdc` column name to partition on with [Change Data Feed](#isCDCEnabledOnTable) enabled.

`__is_cdc` column is added when `TransactionalWrite` is requested to [performCDCPartition](../TransactionalWrite.md#performCDCPartition) with [CDF enabled on a delta table](#isCDCEnabledOnTable) (and [_change_type](#CDC_TYPE_COLUMN_NAME) among the columns).

If added, `__is_cdc` column becomes the first partitioning column. It is then "consumed" by [DelayedCommitProtocol](../DelayedCommitProtocol.md#cdc) (to write changes to `cdc-`-prefixed files, not `part-`).

`__is_cdc` is one of the [CDF Virtual Columns](#CDC_COLUMNS_IN_DATA).

Used when:

* `DelayedCommitProtocol` is requested to [getFileName](../DelayedCommitProtocol.md#getFileName) and [buildActionFromAddedFile](../DelayedCommitProtocol.md#buildActionFromAddedFile)

### <span id="CDC_TYPE_COLUMN_NAME"><span id="_change_type"> _change_type Column

`CDCReader` defines `_change_type` column name for the column that represents a change type.

`_change_type` is one of the [CDF Virtual Columns](#CDC_COLUMNS_IN_DATA) and among the columns in the [CDF-aware read schema](#cdcReadSchema).

`CDC_TYPE_COLUMN_NAME` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete) (and then [rewriteFiles](../commands/delete/DeleteCommand.md#rewriteFiles))
* `MergeIntoCommand` is requested to [writeAllChanges](../commands/merge/MergeIntoCommand.md#writeAllChanges) (to [matchedClauseOutput](../commands/merge/MergeIntoCommand.md#matchedClauseOutput) and [notMatchedClauseOutput](../commands/merge/MergeIntoCommand.md#notMatchedClauseOutput))
* `UpdateCommand` is requested to [withUpdatedColumns](../commands/update/UpdateCommand.md#withUpdatedColumns)
* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)
* `CdcAddFileIndex` is requested to [matchingFiles](CdcAddFileIndex.md#matchingFiles)
* `TahoeRemoveFileIndex` is requested to [matchingFiles](TahoeRemoveFileIndex.md#matchingFiles)
* `TransactionalWrite` is requested to [performCDCPartition](../TransactionalWrite.md#performCDCPartition)
* `SchemaUtils` utility is used to [normalizeColumnNames](../SchemaUtils.md#normalizeColumnNames)

## <span id="CDC_TYPE_NOT_CDC"> CDC_TYPE_NOT_CDC

```scala
CDC_TYPE_NOT_CDC: String
```

`CDCReader` defines a `CDC_TYPE_NOT_CDC` value that is always `null`.

`CDC_TYPE_NOT_CDC` is used when:

* `DeleteCommand` is requested to [rewriteFiles](../commands/delete/DeleteCommand.md#rewriteFiles)
* `MergeIntoCommand` is requested to [writeAllChanges](../commands/merge/MergeIntoCommand.md#writeAllChanges) (to [matchedClauseOutput](../commands/merge/MergeIntoCommand.md#matchedClauseOutput) and [notMatchedClauseOutput](../commands/merge/MergeIntoCommand.md#notMatchedClauseOutput))
* `UpdateCommand` is requested to [withUpdatedColumns](../commands/update/UpdateCommand.md#withUpdatedColumns)
* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)

## <span id="isCDCRead"> CDC-Aware Table Scan (CDC Read)

```scala
isCDCRead(
  options: CaseInsensitiveStringMap): Boolean
```

`isCDCRead` is `true` when one of the following options is specified (in the given `options`):

1. [readChangeFeed](../delta/DeltaDataSource.md#CDC_ENABLED_KEY) with `true` value
1. (legacy) [readChangeData](../delta/DeltaDataSource.md#CDC_ENABLED_KEY_LEGACY) with `true` value

Otherwise, `isCDCRead` is `false`.

`isCDCRead` is used when:

* `DeltaRelation` utility is used to [fromV2Relation](../DeltaRelation.md#fromV2Relation)
* `DeltaTableV2` is requested to [withOptions](../DeltaTableV2.md#withOptions)
* `DeltaDataSource` is requested for the [streaming source schema](../delta/DeltaDataSource.md#sourceSchema) and to [create a BaseRelation](../delta/DeltaDataSource.md#RelationProvider-createRelation)

## <span id="cdcReadSchema"> CDF-Aware Read Schema (Adding CDF Columns)

```scala
cdcReadSchema(
  deltaSchema: StructType): StructType
```

`cdcReadSchema` adds the CDF columns to the given `deltaSchema`.

 Name | Type
------|-----
 [_change_type](#CDC_TYPE_COLUMN_NAME) | `StringType`
 [_commit_version](#CDC_COMMIT_VERSION) | `LongType`
 [_commit_timestamp](#CDC_COMMIT_TIMESTAMP) | `TimestampType`

`cdcReadSchema` is used when:

* `CDCReader` utility is used to [getCDCRelation](#getCDCRelation) and [scanIndex](#scanIndex)
* `DeltaRelation` utility is used to [fromV2Relation](../DeltaRelation.md#fromV2Relation)
* `OptimisticTransactionImpl` is requested to [performCdcMetadataCheck](../OptimisticTransactionImpl.md#performCdcMetadataCheck)
* `CdcAddFileIndex` is requested for the [partitionSchema](CdcAddFileIndex.md#partitionSchema)
* `TahoeRemoveFileIndex` is requested for the [partitionSchema](TahoeRemoveFileIndex.md#partitionSchema)
* `DeltaDataSource` is requested for the [sourceSchema](../delta/DeltaDataSource.md#sourceSchema)
* `DeltaSourceBase` is requested for the [schema](../delta/DeltaSourceBase.md#schema)
* `DeltaSourceCDCSupport` is requested to [filterCDCActions](DeltaSourceCDCSupport.md#filterCDCActions)

## <span id="changesToDF"> changesToDF

```scala
changesToDF(
  deltaLog: DeltaLog,
  start: Long,
  end: Long,
  changes: Iterator[(Long, Seq[Action])],
  spark: SparkSession,
  isStreaming: Boolean = false): CDCVersionDiffInfo
```

`changesToDF`...FIXME

`changesToDF` is used when:

* `CDCReader` is requested to [changesToBatchDF](#changesToBatchDF)
* `DeltaSourceCDCSupport` is requested to [getCDCFileChangesAndCreateDataFrame](DeltaSourceCDCSupport.md#getCDCFileChangesAndCreateDataFrame)

### <span id="changesToDF-DeltaUnsupportedOperationException"> DeltaUnsupportedOperationException

`changesToDF` makes sure that the [DeltaColumnMappingMode](../Metadata.md#columnMappingMode) is [NoMapping](../column-mapping/DeltaColumnMappingMode.md#NoMapping) or throws a `DeltaUnsupportedOperationException`:

```text
Change data feed (CDF) reads are currently not supported on tables with column mapping enabled.
```

### <span id="scanIndex"> scanIndex

```scala
scanIndex(
  spark: SparkSession,
  index: TahoeFileIndex,
  metadata: Metadata,
  isStreaming: Boolean = false): DataFrame
```

`scanIndex` creates a `LogicalRelation` ([Spark SQL]({{ book.spark_sql }}/LogicalRelation)) with a `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) (with the given [TahoeFileIndex](../TahoeFileIndex.md), [cdcReadSchema](#cdcReadSchema), no bucketing, [DeltaParquetFileFormat](../DeltaParquetFileFormat.md)).

In the end, `scanIndex` wraps it up as a `DataFrame`.

## <span id="isCDCEnabledOnTable"> isCDCEnabledOnTable

```scala
isCDCEnabledOnTable(
  metadata: Metadata): Boolean
```

`isCDCEnabledOnTable` is the value of the [delta.enableChangeDataFeed](../DeltaConfigs.md#CHANGE_DATA_FEED) table property.

`isCDCEnabledOnTable` is used when:

* `OptimisticTransactionImpl` is requested to [performCdcMetadataCheck](../OptimisticTransactionImpl.md#performCdcMetadataCheck) and [performCdcColumnMappingCheck](../OptimisticTransactionImpl.md#performCdcColumnMappingCheck)
* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)
* `CDCReader` is requested to [changesToDF](#changesToDF)
* `TransactionalWrite` is requested to [performCDCPartition](../TransactionalWrite.md#performCDCPartition)

## <span id="CDC_TYPE_INSERT"><span id="insert"> insert Change Type

`CDCReader` defines `insert` value for the value of the [_change_type](#CDC_TYPE_COLUMN_NAME) column in the following:

* [notMatchedClauseOutput](../commands/merge/MergeIntoCommand.md#notMatchedClauseOutput) with [cdcEnabled](../commands/merge/MergeIntoCommand.md#cdcEnabled) (when [writeAllChanges](../commands/merge/MergeIntoCommand.md#writeAllChanges))
* `WriteIntoDelta` is requested to [write data out](../commands/WriteIntoDelta.md#write) (with [isCDCEnabledOnTable](#isCDCEnabledOnTable))
* `CdcAddFileIndex` is requested to [matchingFiles](CdcAddFileIndex.md#matchingFiles)
