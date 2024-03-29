# CDCReaderImpl

`CDCReaderImpl` is an marker abstraction of [Change Data Feed-aware Readers](#implementations).

!!! note "Fun Fact"
    Despite the suffix (`Impl`), `CDCReaderImpl` is a trait not an implementation (_class_).

## Implementations

* [CDCReader](CDCReader.md)

## Creating CDF-Aware Relation { #getCDCRelation }

```scala
getCDCRelation(
  spark: SparkSession,
  snapshotToUse: Snapshot,
  isTimeTravelQuery: Boolean,
  conf: SQLConf,
  options: CaseInsensitiveStringMap): BaseRelation
```

`getCDCRelation` [getVersionForCDC](#getVersionForCDC) with the following:

* [startingVersion](../spark-connector/DeltaDataSource.md#startingVersion) for the version key
* [startingTimestamp](../spark-connector/DeltaDataSource.md#startingTimestamp) for the timestamp key

`getCDCRelation` [getBatchSchemaModeForTable](#getBatchSchemaModeForTable).

`getCDCRelation` [getVersionForCDC](#getVersionForCDC) with the following:

* [endingVersion](../spark-connector/DeltaDataSource.md#endingVersion) for the version key
* [endingTimestamp](../spark-connector/DeltaDataSource.md#endingTimestamp) for the timestamp key

`getCDCRelation` prints out the following INFO message to the logs:

```text
startingVersion: [startingVersion], endingVersion: [endingVersionOpt]
```

In the end, `getCDCRelation` creates a [DeltaCDFRelation](DeltaCDFRelation.md).

---

`getCDCRelation` is used when:

* `DeltaTableV2` is requested for the [CDC-aware relation](../DeltaTableV2.md#cdcRelation)

### Resolving Version { #getVersionForCDC }

```scala
getVersionForCDC(
  spark: SparkSession,
  deltaLog: DeltaLog,
  conf: SQLConf,
  options: CaseInsensitiveStringMap,
  versionKey: String,
  timestampKey: String): Option[ResolvedCDFVersion]
```

!!! note "FIXME Review Me"

`getVersionForCDC` uses the given `options` map to get the value of the given `versionKey` key, if available.

Otherwise, `getVersionForCDC` uses the given `options` map to get the value of the given `timestampKey` key, if available. `getVersionForCDC`...FIXME

If neither the given `versionKey` nor the `timestampKey` key is available in the `options` map, `getVersionForCDC` returns `None` (_undefined value_).

## Creating Batch DataFrame of Changes { #changesToBatchDF }

```scala
changesToBatchDF(
  deltaLog: DeltaLog,
  start: Long,
  end: Long,
  spark: SparkSession,
  readSchemaSnapshot: Option[Snapshot] = None,
  useCoarseGrainedCDC: Boolean = false): DataFrame
```

`changesToBatchDF` requests the given [DeltaLog](../DeltaLog.md) for the [changes](../DeltaLog.md#getChanges) from the given `start` version (inclusive) until the given `end` version.

In the end, `changesToBatchDF` [creates a DataFrame of changes](#changesToDF) (with the changes per version and `isStreaming` flag disabled).

---

`changesToBatchDF` is used when:

* `DeltaCDFRelation` is requested to [build a scan](DeltaCDFRelation.md#buildScan)

## Creating DataFrame of Changes { #changesToDF }

```scala
changesToDF(
  readSchemaSnapshot: SnapshotDescriptor,
  start: Long,
  end: Long,
  changes: Iterator[(Long, Seq[Action])],
  spark: SparkSession,
  isStreaming: Boolean = false,
  useCoarseGrainedCDC: Boolean = false): CDCVersionDiffInfo
```

??? note "`isStreaming` Input Argument"

    Value | Caller
    ------|-------
    `false` | <ul><li>The default</li><li>`CDCReaderImpl` is requested to [changesToBatchDF](#changesToBatchDF)</li></ul>
    `true` | `DeltaSourceCDCSupport` is requested to [getCDCFileChangesAndCreateDataFrame](DeltaSourceCDCSupport.md#getCDCFileChangesAndCreateDataFrame)

??? note "`useCoarseGrainedCDC` Input Argument"

    `useCoarseGrainedCDC` is disabled (`false`) by default and for all the other known use cases.

`changesToDF` [getTimestampsByVersion](#getTimestampsByVersion).

`changesToDF` requests the [DeltaLog](../SnapshotDescriptor.md#deltaLog) (of the given [SnapshotDescriptor](../SnapshotDescriptor.md)) for the [Snapshot](../SnapshotManagement.md#getSnapshotAt) at the given `start`.

`changesToDF` asserts that one of the following is enabled (or throws a `DeltaAnalysisException`):

* The given `useCoarseGrainedCDC` flag
* [isCDCEnabledOnTable](#isCDCEnabledOnTable)

`changesToDF` reads [spark.databricks.delta.changeDataFeed.unsafeBatchReadOnIncompatibleSchemaChanges.enabled](../configuration-properties/index.md#changeDataFeed.unsafeBatchReadOnIncompatibleSchemaChanges.enabled) configuration property (that can potentially block batch reads, when the given `isStreaming` flag is disabled).

`changesToDF`...FIXME

In the end, `changesToDF` creates a new [CDCVersionDiffInfo](CDCVersionDiffInfo.md) (with the `DataFrame` of the changes).

---

`changesToDF` is used when:

* `CDCReaderImpl` is requested for a [batch DataFrame of changes](#changesToBatchDF)
* `DeltaSourceCDCSupport` is requested for a [streaming DataFrame of changes](DeltaSourceCDCSupport.md#getCDCFileChangesAndCreateDataFrame)

### getDeletedAndAddedRows { #getDeletedAndAddedRows }

```scala
getDeletedAndAddedRows(
  addFileSpecs: Seq[CDCDataSpec[AddFile]],
  removeFileSpecs: Seq[CDCDataSpec[RemoveFile]],
  deltaLog: DeltaLog,
  snapshot: SnapshotDescriptor,
  isStreaming: Boolean,
  spark: SparkSession): Seq[DataFrame]
```

`getDeletedAndAddedRows`...FIXME

### buildCDCDataSpecSeq { #buildCDCDataSpecSeq }

```scala
buildCDCDataSpecSeq[T <: FileAction](
  actionsByVersion: MutableMap[TableVersion, ListBuffer[T]],
  versionToCommitInfo: MutableMap[Long, CommitInfo]): Seq[CDCDataSpec[T]]
```

`buildCDCDataSpecSeq` converts the given `actionsByVersion` into [CDCDataSpec](CDCDataSpec.md)s (with [CommitInfo](../CommitInfo.md)s from the given `versionToCommitInfo` mapping).

### processDeletionVectorActions { #processDeletionVectorActions }

```scala
processDeletionVectorActions(
  addFilesMap: Map[FilePathWithTableVersion, AddFile],
  removeFilesMap: Map[FilePathWithTableVersion, RemoveFile],
  versionToCommitInfo: Map[Long, CommitInfo],
  deltaLog: DeltaLog,
  snapshot: SnapshotDescriptor,
  isStreaming: Boolean,
  spark: SparkSession): Seq[DataFrame]
```

`processDeletionVectorActions`...FIXME

### generateFileActionsWithInlineDv { #generateFileActionsWithInlineDv }

```scala
generateFileActionsWithInlineDv(
  add: AddFile,
  remove: RemoveFile,
  dvStore: DeletionVectorStore,
  deltaLog: DeltaLog): Seq[FileAction]
```

`generateFileActionsWithInlineDv`...FIXME

## Creating DataFrame over Delta-Aware FileIndex { #scanIndex }

```scala
scanIndex(
  spark: SparkSession,
  index: TahoeFileIndexWithSnapshotDescriptor,
  isStreaming: Boolean = false): DataFrame
```

!!! note "HadoopFsRelation"
    In order to understand the `scanIndex`, it is firstly worth to understand the role of `HadoopFsRelation`.

`scanIndex` creates a `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) based on the given `TahoeFileIndexWithSnapshotDescriptor` as follows:

Property | Value
---------|------
`location` | The given `TahoeFileIndexWithSnapshotDescriptor`
`partitionSchema` | The [partitionSchema](../TahoeFileIndex.md#partitionSchema) of the given `TahoeFileIndexWithSnapshotDescriptor`
`dataSchema` | The [CDF-aware read schema](#cdcReadSchema) based on the [schema](../SnapshotDescriptor.md#schema) of the given `TahoeFileIndexWithSnapshotDescriptor`
`bucketSpec` | Undefined (`None`)
`fileFormat` | A new [DeltaParquetFileFormat](../DeltaParquetFileFormat.md)
`options` | The [options](../DeltaLog.md#options) of the [DeltaLog](../TahoeFileIndex.md#deltaLog) of the given `TahoeFileIndexWithSnapshotDescriptor`

`scanIndex` creates a `LogicalRelation` ([Spark SQL]({{ book.spark_sql }}/LogicalRelation)) for the `HadoopFsRelation` (and the given `isStreaming` flag).

In the end, `scanIndex` creates a `DataFrame` for the `LogicalRelation`.

---

`scanIndex` is used when:

* `CDCReaderImpl` is requested to [changesToDF](#changesToDF), [getDeletedAndAddedRows](#getDeletedAndAddedRows), [processDeletionVectorActions](#processDeletionVectorActions)

## CDF-Aware Read Schema (Adding CDF Columns) { #cdcReadSchema }

```scala
cdcReadSchema(
  deltaSchema: StructType): StructType
```

`cdcReadSchema` makes the given schema (`StructType`) of a delta table CDF-aware by appending the following CDF metadata fields:

Column Name | Data Type
-----|----------
 [_change_type](CDCReader.md#CDC_TYPE_COLUMN_NAME) | `StringType`
 [_commit_version](CDCReader.md#CDC_COMMIT_VERSION) | `LongType`
 [_commit_timestamp](CDCReader.md#CDC_COMMIT_TIMESTAMP) | `TimestampType`

---

`cdcReadSchema` is used when:

* `OptimisticTransactionImpl` is requested to [performCdcMetadataCheck](../OptimisticTransactionImpl.md#performCdcMetadataCheck)
* `DeltaCDFRelation` is requested for the [schema](DeltaCDFRelation.md#schema)
* `CDCReaderImpl` is requested to [changesToDF](#changesToDF), [scanIndex](#scanIndex)
* `CdcAddFileIndex` is requested for the [partition schema](CdcAddFileIndex.md#partitionSchema)
* `TahoeRemoveFileIndex` is requested for the [partition schema](TahoeRemoveFileIndex.md#partitionSchema)
* `DeltaDataSource` is requested for the [sourceSchema](../spark-connector/DeltaDataSource.md#sourceSchema)
* `DeltaSourceBase` is requested to [checkReadIncompatibleSchemaChanges](../spark-connector/DeltaSourceBase.md#checkReadIncompatibleSchemaChanges) and for the [schema](../spark-connector/DeltaSourceBase.md#schema)

## CDC-Aware Table Scan (CDC Read) { #isCDCRead }

```scala
isCDCRead(
  options: CaseInsensitiveStringMap): Boolean
```

`isCDCRead` is `true` when one of the following options is specified (in the given `options`) with `true` value (case-insensitive):

1. [readChangeFeed](../spark-connector/DeltaDataSource.md#readChangeFeed)
1. (legacy) [readChangeData](../spark-connector/DeltaDataSource.md#readChangeData)

Otherwise, `isCDCRead` is `false`.

---

`isCDCRead` is used when:

* `DeltaRelation` utility is used to [fromV2Relation](../DeltaRelation.md#fromV2Relation)
* `DeltaTableV2` is requested for the [cdcRelation](../DeltaTableV2.md#cdcRelation), [initialSnapshot](../DeltaTableV2.md#initialSnapshot), [withOptions](../DeltaTableV2.md#withOptions)
* `DeltaDataSource` is requested for the [streaming source schema](../spark-connector/DeltaDataSource.md#sourceSchema) and for a [relation](../spark-connector/DeltaDataSource.md#RelationProvider-createRelation)

## isCDCEnabledOnTable { #isCDCEnabledOnTable }

```scala
isCDCEnabledOnTable(
  metadata: Metadata,
  spark: SparkSession): Boolean
```

`isCDCEnabledOnTable` [checks if the given metadata requires the Change Data Feed feature to be enabled](ChangeDataFeedTableFeature.md#metadataRequiresFeatureToBeEnabled) (based on [delta.enableChangeDataFeed](../table-properties/DeltaConfigs.md#enableChangeDataFeed) table property).

---

`isCDCEnabledOnTable` is used when:

* `OptimisticTransactionImpl` is requested to [performCdcColumnMappingCheck](../OptimisticTransactionImpl.md#performCdcColumnMappingCheck) and [performCdcMetadataCheck](../OptimisticTransactionImpl.md#performCdcMetadataCheck)
* `WriteIntoDelta` is requested to [write data out](../commands/WriteIntoDelta.md#write)
* `CDCReaderImpl` is requested to [create a DataFrame of changes](#changesToDF)
* `TransactionalWrite` is requested to [performCDCPartition](../TransactionalWrite.md#performCDCPartition)

## Logging

`CDCReaderImpl` is an abstract class and logging is configured using the logger of the [implementations](#implementations).
