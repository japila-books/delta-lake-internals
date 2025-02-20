# Configuration Properties

Configuration properties are a way to control features of Delta Lake for the whole cluster (`SparkSession`, to be precise) and hence for all tables created by the cluster.

??? note "Table Properties"
    Unlike configuration properties, [Table Properties](../table-properties/index.md) are per table only.

## spark.databricks.delta { #spark.databricks.delta }

Configuration properties use `spark.databricks.delta` prefix.

### <span id="alterLocation.bypassSchemaCheck"><span id="DELTA_ALTER_LOCATION_BYPASS_SCHEMA_CHECK"> alterLocation.bypassSchemaCheck

**spark.databricks.delta.alterLocation.bypassSchemaCheck**

Enables Alter Table Set Location on Delta to go through even if the Delta table in the new location has a different schema from the original Delta table

Default: `false`

### <span id="alterTable.changeColumn.checkExpressions"><span id="DELTA_ALTER_TABLE_CHANGE_COLUMN_CHECK_EXPRESSIONS"> alterTable.changeColumn.checkExpressions

**spark.databricks.delta.alterTable.changeColumn.checkExpressions** (internal)

Given an [ALTER TABLE CHANGE COLUMN](../commands/alter/index.md) command, check whether [Constraints](../constraints/index.md) or [Generated Columns](../generated-columns/index.md) use expressions that reference this column (that will be affected by this change and should be changed along).

Turn this off when there is an issue with expression checking logic that prevents a valid column change from going through.

Default: `true`

Used when:

* `AlterDeltaTableCommand` is requested to [checkDependentExpressions](../commands/alter/AlterDeltaTableCommand.md#checkDependentExpressions)

### <span id="DELTA_AUTO_COMPACT_ENABLED"><span id="spark.databricks.delta.autoCompact.enabled"> autoCompact.enabled { #autoCompact.enabled }

**spark.databricks.delta.autoCompact.enabled**

Enables [Auto Compaction](../auto-compaction/index.md) on all writes across all delta tables in this session.

Default: `false`

Used when:

* `AutoCompactBase` is requested for the [type of Auto Compaction](../auto-compaction/AutoCompactBase.md#getAutoCompactType)

### <span id="autoCompact.maxFileSize"><span id="DELTA_AUTO_COMPACT_MAX_FILE_SIZE"> autoCompact.maxFileSize { #spark.databricks.delta.autoCompact.maxFileSize }

**spark.databricks.delta.autoCompact.maxFileSize**

(internal) Target file size produced by [Auto Compaction](../auto-compaction/index.md)

Default: `128 * 1024 * 1024` (`128MB`)

Used when:

* `AutoCompactBase` is requested to [compact](../auto-compaction/AutoCompactBase.md#compact)

### <span id="autoCompact.minFileSize"><span id="DELTA_AUTO_COMPACT_MIN_FILE_SIZE"> autoCompact.minFileSize { #spark.databricks.delta.autoCompact.minFileSize }

**spark.databricks.delta.autoCompact.minFileSize**

**(internal)** Files which are smaller than this threshold (in bytes) will be grouped together and rewritten as larger files in [Auto Compaction](../auto-compaction/index.md)

Default: The half of [spark.databricks.delta.autoCompact.maxFileSize](#autoCompact.maxFileSize)

Used when:

* `OptimisticTransactionImpl` is requested to [createAutoCompactStatsCollector](../OptimisticTransactionImpl.md#createAutoCompactStatsCollector)
* `AutoCompactBase` is requested to [compact](../auto-compaction/AutoCompactBase.md#compact)

### <span id="DELTA_AUTO_COMPACT_MODIFIED_PARTITIONS_ONLY_ENABLED"><span id="spark.databricks.delta.autoCompact.modifiedPartitionsOnly.enabled"> autoCompact.modifiedPartitionsOnly.enabled { #autoCompact.modifiedPartitionsOnly.enabled }

**(internal)** **spark.databricks.delta.autoCompact.modifiedPartitionsOnly.enabled**

When enabled, [Auto Compaction](../auto-compaction/index.md) works only on the modified partitions of the delta transaction that triggers compaction.

Default: `true`

Used when:

* `AutoCompactBase` is requested to [isModifiedPartitionsOnlyAutoCompactEnabled](../auto-compaction/AutoCompactUtils.md#isModifiedPartitionsOnlyAutoCompactEnabled)

### <span id="DELTA_AUTO_COMPACT_NON_BLIND_APPEND_ENABLED"><span id="spark.databricks.delta.autoCompact.nonBlindAppend.enabled"> autoCompact.nonBlindAppend.enabled { #autoCompact.nonBlindAppend.enabled }

**(internal)** **spark.databricks.delta.autoCompact.nonBlindAppend.enabled**

When enabled, [Auto Compaction](../auto-compaction/index.md) is only triggered by non-blind-append write transactions.

Default: `false`

Used when:

* `AutoCompactBase` is requested to [isNonBlindAppendAutoCompactEnabled](../auto-compaction/AutoCompactUtils.md#isNonBlindAppendAutoCompactEnabled)

### <span id="changeDataFeed.unsafeBatchReadOnIncompatibleSchemaChanges.enabled"><span id="DELTA_CDF_UNSAFE_BATCH_READ_ON_INCOMPATIBLE_SCHEMA_CHANGES"> changeDataFeed.unsafeBatchReadOnIncompatibleSchemaChanges.enabled

**(internal)** **spark.databricks.delta.changeDataFeed.unsafeBatchReadOnIncompatibleSchemaChanges.enabled**

Enables (_unblocks_) reading change data in batch (e.g. using `table_changes()`) on a delta table with column mapping schema operations

It is currently blocked due to potential data loss and schema confusion, and hence considered risky.

Default: `false`

Used when:

* `CDCReaderImpl` is requested for a [DataFrame of changes](../change-data-feed/CDCReaderImpl.md#changesToDF)

### <span id="checkLatestSchemaOnRead"><span id="DELTA_SCHEMA_ON_READ_CHECK_ENABLED"> checkLatestSchemaOnRead

**spark.databricks.delta.checkLatestSchemaOnRead** enables a check that ensures that users won't read corrupt data if the source schema changes in an incompatible way.

Default: `true`

Delta always tries to give users the latest version of table data without having to call `REFRESH TABLE` or redefine their DataFrames when used in the context of streaming. There is a possibility that the schema of the latest version of the table may be incompatible with the schema at the time of DataFrame creation.

### <span id="spark.databricks.delta.checkpoint.partSize"><span id="DELTA_CHECKPOINT_PART_SIZE"> checkpoint.partSize { #checkpoint.partSize }

**spark.databricks.delta.checkpoint.partSize**

**(internal)** The limit checkpoint parallelization starts at. It attempts to write maximum of this many actions per checkpoint.

Default: (undefined) (and assumed `1`)

Must be a positive `long` number

Used when:

* `Checkpoints` is requested to [write out a state checkpoint](../checkpoints/Checkpoints.md#writeCheckpoint)

### <span id="clusteredTable.enableClusteringTablePreview"><span id="DELTA_CLUSTERING_TABLE_PREVIEW_ENABLED"> clusteredTable.enableClusteringTablePreview { #spark.databricks.delta.clusteredTable.enableClusteringTablePreview }

**spark.databricks.delta.clusteredTable.enableClusteringTablePreview**

**(internal)** Controls [Liquid Clustering](../liquid-clustering/index.md)

Default: `false`

Used when:

* `ClusteredTableUtilsBase` is requested to [validatePreviewEnabled](../liquid-clustering/ClusteredTableUtilsBase.md#validatePreviewEnabled)
* `DeltaErrorsBase` is requested to [clusteringTablePreviewDisabledException](../DeltaErrorsBase.md#clusteringTablePreviewDisabledException)

### <span id="commitInfo.enabled"><span id="DELTA_COMMIT_INFO_ENABLED"> commitInfo.enabled

**spark.databricks.delta.commitInfo.enabled** controls whether to [log commit information into a Delta log](../OptimisticTransactionImpl.md#commitInfo).

Default: `true`

### <span id="commitInfo.userMetadata"><span id="DELTA_USER_METADATA"> commitInfo.userMetadata

**spark.databricks.delta.commitInfo.userMetadata** is an arbitrary user-defined metadata to include in [CommitInfo](../CommitInfo.md#userMetadata) (requires [spark.databricks.delta.commitInfo.enabled](#commitInfo.enabled)).

Default: (empty)

### <span id="commitLock.enabled"><span id="DELTA_COMMIT_LOCK_ENABLED"> commitLock.enabled

**spark.databricks.delta.commitLock.enabled** (internal) controls [whether or not to use a lock on a delta table at transaction commit](../OptimisticTransactionImpl.md#lockCommitIfEnabled).

Default: (undefined)

Used when:

* `OptimisticTransactionImpl` is requested to [isCommitLockEnabled](../OptimisticTransactionImpl.md#isCommitLockEnabled)

### <span id="commitValidation.enabled"><span id="DELTA_COMMIT_VALIDATION_ENABLED"> commitValidation.enabled

**spark.databricks.delta.commitValidation.enabled** (internal) controls whether to perform validation checks before commit or not

Default: `true`

### <span id="convert.metadataCheck.enabled"><span id="DELTA_CONVERT_METADATA_CHECK_ENABLED"> convert.metadataCheck.enabled

**spark.databricks.delta.convert.metadataCheck.enabled** enables validation during convert to delta, if there is a difference between the catalog table's properties and the Delta table's configuration, we should error.

If disabled, merge the two configurations with the same semantics as update and merge

Default: `true`

### <span id="DELETE_USE_PERSISTENT_DELETION_VECTORS"> delete.deletionVectors.persistent { #delete.deletionVectors.persistent }

**spark.databricks.delta.delete.deletionVectors.persistent**

Enables [persistent Deletion Vectors](../deletion-vectors/index.md) in [DELETE](../commands/delete/index.md) command

Default: `true`

### <span id="DELETION_VECTORS_USE_METADATA_ROW_INDEX"> deletionVectors.useMetadataRowIndex { #deletionVectors.useMetadataRowIndex }

**spark.databricks.delta.deletionVectors.useMetadataRowIndex**

**(internal)** Enables using the Parquet reader generated `row_index` column for filtering deleted rows with [Deletion Vectors](../deletion-vectors/index.md) (that gives predicate pushdown and file splitting in scans).

Default: `true`

Used when:

* `DeltaParquetFileFormat` is requested to [buildReaderWithPartitionValues](../DeltaParquetFileFormat.md#buildReaderWithPartitionValues)
* `ScanWithDeletionVectors` is requested to [createScanWithSkipRowColumn](../deletion-vectors/ScanWithDeletionVectors.md#createScanWithSkipRowColumn)
* `DeletionVectorBitmapGenerator` is requested to [buildRowIndexSetsForFilesMatchingCondition](../deletion-vectors/DeletionVectorBitmapGenerator.md#buildRowIndexSetsForFilesMatchingCondition)
* `DMLWithDeletionVectorsHelper` is requested to [replaceFileIndex](../deletion-vectors/DMLWithDeletionVectorsHelper.md#replaceFileIndex)

### <span id="dummyFileManager.numOfFiles"><span id="DUMMY_FILE_MANAGER_NUM_OF_FILES"> dummyFileManager.numOfFiles

**spark.databricks.delta.dummyFileManager.numOfFiles** (internal) controls how many dummy files to write in DummyFileManager

Default: `3`

### <span id="dummyFileManager.prefix"><span id="DUMMY_FILE_MANAGER_PREFIX"> dummyFileManager.prefix

**spark.databricks.delta.dummyFileManager.prefix** (internal) is the file prefix to use in DummyFileManager

Default: `.s3-optimization-`

### <span id="dynamicPartitionOverwrite.enabled"><span id="DYNAMIC_PARTITION_OVERWRITE_ENABLED"> dynamicPartitionOverwrite.enabled { #spark.databricks.delta.dynamicPartitionOverwrite.enabled }

**spark.databricks.delta.dynamicPartitionOverwrite.enabled**

**(internal)** Enables [Dynamic Partition Overwrite](../dynamic-partition-overwrite/index.md) (whether to overwrite partitions dynamically when `partitionOverwriteMode` is `dynamic` in either the SQL configuration or a `DataFrameWriter` option).
When disabled, `partitionOverwriteMode` will be ignored.

Default: `true`

Used when:

* `DeltaWriteOptionsImpl` is requested to [isDynamicPartitionOverwriteMode](../spark-connector/DeltaWriteOptionsImpl.md#isDynamicPartitionOverwriteMode)

### <span id="spark.databricks.delta.history.maxKeysPerList"><span id="DELTA_HISTORY_PAR_SEARCH_THRESHOLD"> history.maxKeysPerList { #history.maxKeysPerList }

**spark.databricks.delta.history.maxKeysPerList**

(internal) How many commits to list when performing a parallel search

Default: `1000`

The default is the maximum keys returned by S3 per [ListObjectsV2]({{ s3.api }}/API_ListObjectsV2.html) call. Microsoft Azure can return up to `5000` blobs (including all `BlobPrefix` elements) in a single [List Blobs](https://learn.microsoft.com/en-us/rest/api/storageservices/list-blobs) API call, and hence the default `1000`.

Used when:

* `DeltaLog` is requested for the [DeltaHistoryManager](../DeltaLog.md#history)

### <span id="DELTA_HISTORY_METRICS_ENABLED"> history.metricsEnabled { #history.metricsEnabled }

**spark.databricks.delta.history.metricsEnabled**

Enables metrics reporting in `DESCRIBE HISTORY` ([CommitInfo](../CommitInfo.md) will record the operation metrics when a `OptimisticTransactionImpl` is [committed](../OptimisticTransactionImpl.md#commit)).

Requires [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#DELTA_COMMIT_INFO_ENABLED) configuration property to be enabled

Default: `true`

Used when:

* `OptimisticTransactionImpl` is requested to [getOperationMetrics](../OptimisticTransactionImpl.md#getOperationMetrics)
* `ConvertToDeltaCommand` is requested to [streamWrite](../commands/convert/ConvertToDeltaCommand.md#streamWrite)
* `SQLMetricsReporting` is requested to [registerSQLMetrics](../SQLMetricsReporting.md#registerSQLMetrics)
* `TransactionalWrite` is requested to [writeFiles](../TransactionalWrite.md#writeFiles)

!!! note "Github Commit"
    The feature was added as part of [[SC-24567][DELTA] Add additional metrics to Describe Delta History]({{ delta.commit }}/54643efc07dfaa9028d228dcad6502d59e4bdb3a) commit.

### <span id="DELTA_IDENTITY_COLUMN_ENABLED"><span id="spark.databricks.delta.identityColumn.enabled"> identityColumn.enabled { #identityColumn.enabled }

**spark.databricks.delta.identityColumn.enabled**

Enables [IDENTITY column](../identity-columns/index.md) support (writer table feature)

Default: `true`

Used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal)

### <span id="DELTA_IMPORT_BATCH_SIZE_SCHEMA_INFERENCE"> import.batchSize.schemaInference { #import.batchSize.schemaInference }

**spark.databricks.delta.import.batchSize.schemaInference** (internal) is the number of files per batch for schema inference during [import](../commands/convert/ConvertToDeltaCommand.md#performConvert-schemaBatchSize).

Default: `1000000`

### <span id="import.batchSize.statsCollection"><span id="DELTA_IMPORT_BATCH_SIZE_STATS_COLLECTION"> import.batchSize.statsCollection

**spark.databricks.delta.import.batchSize.statsCollection** (internal) is the number of files per batch for stats collection during [import](../commands/convert/ConvertToDeltaCommand.md#performConvert-schemaBatchSize).

Default: `50000`

### <span id="io.skipping.mdc.addNoise"><span id="MDC_ADD_NOISE"> io.skipping.mdc.addNoise

**spark.databricks.io.skipping.mdc.addNoise** (internal) controls whether or not to add a random byte as a suffix to the interleaved bits when computing the Z-order values for MDC. This can help deal with skew, but may have a negative impact on overall min/max skipping effectiveness.

Default: `true`

Used when:

* `SpaceFillingCurveClustering` is requested to [cluster](../commands/optimize/SpaceFillingCurveClustering.md#cluster)

### <span id="io.skipping.mdc.rangeId.max"><span id="MDC_NUM_RANGE_IDS"> io.skipping.mdc.rangeId.max

**spark.databricks.io.skipping.mdc.rangeId.max** (internal) controls the domain of `rangeId` values to be interleaved. The bigger, the better granularity, but at the expense of performance (more data gets sampled).

Default: `1000`

Must be greater than `1`

Used when:

* `SpaceFillingCurveClustering` is requested to [cluster](../commands/optimize/SpaceFillingCurveClustering.md#cluster)

### <span id="io.skipping.stringPrefixLength"><span id="DATA_SKIPPING_STRING_PREFIX_LENGTH"> io.skipping.stringPrefixLength

**spark.databricks.io.skipping.stringPrefixLength** (internal) The length of the prefix of string columns to store in the data skipping index

Default: `32`

Used when:

* `StatisticsCollection` is requested for the [statsCollector Column](../StatisticsCollection.md#statsCollector)

### <span id="lastCommitVersionInSession"><span id="DELTA_LAST_COMMIT_VERSION_IN_SESSION"> lastCommitVersionInSession

**spark.databricks.delta.lastCommitVersionInSession** is the version of the last commit made in the `SparkSession` for any delta table (after `OptimisticTransactionImpl` is done with [doCommit](../OptimisticTransactionImpl.md#doCommit) or `DeltaCommand` with [commitLarge](../commands/DeltaCommand.md#commitLarge))

Default: (undefined)

### <span id="loadFileSystemConfigsFromDataFrameOptions"><span id="LOAD_FILE_SYSTEM_CONFIGS_FROM_DATAFRAME_OPTIONS"> loadFileSystemConfigsFromDataFrameOptions

**spark.databricks.delta.loadFileSystemConfigsFromDataFrameOptions** (internal) controls whether to load file systems configs provided in `DataFrameReader` or `DataFrameWriter` options when
calling `DataFrameReader.load/DataFrameWriter.save` using a Delta table path.

Not supported for `DataFrameReader.table` and `DataFrameWriter.saveAsTable`

Default: `true`

### <span id="maxCommitAttempts"><span id="DELTA_MAX_RETRY_COMMIT_ATTEMPTS"> maxCommitAttempts

**spark.databricks.delta.maxCommitAttempts** (internal) is the maximum number of commit attempts to try for a single commit before failing

Default: `10000000`

Used when:

* `OptimisticTransactionImpl` is requested to [doCommitRetryIteratively](../OptimisticTransactionImpl.md#doCommitRetryIteratively)

### <span id="maxSnapshotLineageLength"><span id="DELTA_MAX_SNAPSHOT_LINEAGE_LENGTH"> maxSnapshotLineageLength

**spark.databricks.delta.maxSnapshotLineageLength** (internal) is the maximum lineage length of a Snapshot before Delta forces to build a Snapshot from scratch

Default: `50`

### <span id="MERGE_USE_PERSISTENT_DELETION_VECTORS"> merge.deletionVectors.persistent { #merge.deletionVectors.persistent }

**spark.databricks.delta.merge.deletionVectors.persistent**

**(internal)** Enables [persistent Deletion Vectors](../deletion-vectors/index.md) in [MERGE](../commands/merge/index.md) command

Default: `true`

Used when:

* `MergeIntoCommandBase` is requested to [shouldWritePersistentDeletionVectors](../commands/merge/MergeIntoCommandBase.md#shouldWritePersistentDeletionVectors)

### <span id="MERGE_MATERIALIZE_SOURCE"> merge.materializeSource { #merge.materializeSource }

**spark.databricks.delta.merge.materializeSource**

**(internal)** When to materialize the source plan during [MERGE](../commands/merge/index.md) execution

Value | Meaning
------|--------
 `all` | source always materialized
 `auto` | sources not materialized unless non-deterministic
 `none` | source never materialized

Default: `auto`

Used when:

* `MergeIntoMaterializeSource` is requested to [shouldMaterializeSource](../commands/merge/MergeIntoMaterializeSource.md#shouldMaterializeSource)

### <span id="MERGE_MATERIALIZE_SOURCE_MAX_ATTEMPTS"> merge.materializeSource.maxAttempts { #merge.materializeSource.maxAttempts }

**spark.databricks.delta.merge.materializeSource.maxAttempts**

How many times retry execution of [MERGE command](../commands/merge/index.md) in case the data (an RDD block) of the materialized source RDD is lost

Default: `4`

Used when:

* `MergeIntoMaterializeSource` is requested to [runWithMaterializedSourceLostRetries](../commands/merge/MergeIntoMaterializeSource.md#runWithMaterializedSourceLostRetries)

### <span id="MERGE_MATERIALIZE_SOURCE_RDD_STORAGE_LEVEL"> merge.materializeSource.rddStorageLevel { #merge.materializeSource.rddStorageLevel }

**spark.databricks.delta.merge.materializeSource.rddStorageLevel**

**(internal)** What `StorageLevel` to use to persist the source RDD

Default: `DISK_ONLY`

Used when:

* `MergeIntoMaterializeSource` is requested to [prepare the source table](../commands/merge/MergeIntoMaterializeSource.md#prepareSourceDFAndReturnMaterializeReason)

### <span id="MERGE_MATERIALIZE_SOURCE_RDD_STORAGE_LEVEL_RETRY"> merge.materializeSource.rddStorageLevelRetry { #merge.materializeSource.rddStorageLevelRetry }

**spark.databricks.delta.merge.materializeSource.rddStorageLevelRetry**

**(internal)** What `StorageLevel` to use to persist the source RDD when MERGE is retried

Default: `DISK_ONLY_2`

Used when:

* `MergeIntoMaterializeSource` is requested to [prepare the source table](../commands/merge/MergeIntoMaterializeSource.md#prepareSourceDFAndReturnMaterializeReason)

### <span id="merge.maxInsertCount"><span id="MERGE_MAX_INSERT_COUNT"> merge.maxInsertCount

**spark.databricks.delta.merge.maxInsertCount** (internal) is the maximum row count of inserts in each MERGE execution

Default: `10000L`

### <span id="MERGE_INSERT_ONLY_ENABLED"> merge.optimizeInsertOnlyMerge.enabled { #merge.optimizeInsertOnlyMerge.enabled }

**spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled**

**(internal)** Enables extra optimization for [insert-only merges](../commands/merge/index.md#insert-only-merges) by avoiding rewriting old files and just inserting new files

Default: `true`

Used when:

* `MergeIntoCommand` is requested to [run a merge](../commands/merge/MergeIntoCommand.md#runMerge) (for [insert-only merge write](../commands/merge/MergeIntoCommand.md#writeOnlyInserts))
* `MergeIntoMaterializeSource` is requested to [shouldMaterializeSource](../commands/merge/MergeIntoMaterializeSource.md#shouldMaterializeSource) (for an insert-only merge)

### <span id="MERGE_MATCHED_ONLY_ENABLED"> merge.optimizeMatchedOnlyMerge.enabled { #merge.optimizeMatchedOnlyMerge.enabled }

**spark.databricks.delta.merge.optimizeMatchedOnlyMerge.enabled**

**(internal)** Enables optimization of [matched-only merges](../commands/merge/index.md#matched-only-merges) to use a RIGHT OUTER join (instead of a FULL OUTER join) while [writing out all merge changes](../commands/merge/ClassicMergeExecutor.md#writeAllChanges)

Default: `true`

### <span id="MERGE_REPARTITION_BEFORE_WRITE"> merge.repartitionBeforeWrite.enabled { #merge.repartitionBeforeWrite.enabled }

**spark.databricks.delta.merge.repartitionBeforeWrite.enabled**

**(internal)** Enables repartitioning of [merge](../commands/merge/index.md) output (by the partition columns of a target table if partitioned) before [write data(frame) out](../commands/merge/MergeIntoCommandBase.md#writeFiles)

Default: `true`

Used when:

* `MergeIntoCommandBase` is requested to [write data(frame) out](../commands/merge/MergeIntoCommandBase.md#writeFiles)

### <span id="optimize.maxFileSize"><span id="DELTA_OPTIMIZE_MAX_FILE_SIZE"> optimize.maxFileSize { #spark.databricks.delta.optimize.maxFileSize }

**spark.databricks.delta.optimize.maxFileSize**

(internal) Target file size produced by [OPTIMIZE](../commands/optimize/index.md) command.

Default: `1024 * 1024 * 1024` (`1GB`)

Used when:

* `OptimizeExecutor` is requested to [optimize](../commands/optimize/OptimizeExecutor.md#optimize)

### <span id="optimize.maxThreads"><span id="DELTA_OPTIMIZE_MAX_THREADS"> optimize.maxThreads

**spark.databricks.delta.optimize.maxThreads** (internal) Maximum number of parallel jobs allowed in [OPTIMIZE](../sql/index.md#OPTIMIZE) command.
Increasing the maximum parallel jobs allows `OPTIMIZE` command to run faster, but increases the job management on the Spark driver.

Default: `15`

Used when:

* `OptimizeExecutor` is requested to [optimize](../commands/optimize/OptimizeExecutor.md#optimize)

### <span id="optimize.minFileSize"><span id="DELTA_OPTIMIZE_MIN_FILE_SIZE"> optimize.minFileSize

**spark.databricks.delta.optimize.minFileSize**

(internal) Files which are smaller than this threshold (in bytes) will be grouped together and rewritten as larger files by the [OPTIMIZE](../sql/index.md#OPTIMIZE) command.

Default: `1024 * 1024 * 1024` (`1GB`)

Used when:

* `OptimizeExecutor` is requested to [optimize](../commands/optimize/OptimizeExecutor.md#optimize)

### <span id="optimize.repartition.enabled"><span id="DELTA_OPTIMIZE_REPARTITION_ENABLED"> optimize.repartition.enabled { #spark.databricks.delta.optimize.repartition.enabled }

**spark.databricks.delta.optimize.repartition.enabled**

(internal) Use `Dataset.repartition(1)` instead of `Dataset.coalesce(1)` to merge small files.
`Dataset.coalesce(1)` is executed with only 1 task, if there are many tiny files within a bin (e.g. 1000 files of 50MB), it cannot be optimized with more executors.
On the other hand, `Dataset.repartition(1)` incurs a shuffle stage yet the job can be distributed.

Default: `false`

Used when:

* `OptimizeExecutor` is requested to [optimize](../commands/optimize/OptimizeExecutor.md#optimize) (and [runOptimizeBinJob](../commands/optimize/OptimizeExecutor.md#runOptimizeBinJob))

### <span id="DELTA_OPTIMIZE_ZORDER_COL_STAT_CHECK"> optimize.zorder.checkStatsCollection.enabled { #optimize.zorder.checkStatsCollection.enabled }

**spark.databricks.delta.optimize.zorder.checkStatsCollection.enabled**

(internal) Controls whether there are [column statistics](../StatisticsCollection.md#statCollectionSchema) available for the `zOrderBy` columns of [OPTIMIZE](../commands/optimize/index.md) command

Default: `true`

Used when:

* `OptimizeTableCommandBase` is requested to [validate zOrderBy columns](../commands/optimize/OptimizeTableCommandBase.md#validateZorderByColumns) (and [zOrderingOnColumnWithNoStatsException](../DeltaErrorsBase.md#zOrderingOnColumnWithNoStatsException))

### <span id="partitionColumnValidity.enabled"><span id="DELTA_PARTITION_COLUMN_CHECK_ENABLED"> partitionColumnValidity.enabled

**spark.databricks.delta.partitionColumnValidity.enabled** (internal) enables validation of the partition column names (just like the data columns)

Default: `true`

Used when:

* `OptimisticTransactionImpl` is requested to [verify a new metadata](../OptimisticTransactionImpl.md#verifyNewMetadata) (with [NoMapping](../column-mapping/DeltaColumnMappingMode.md#NoMapping) column mapping mode)

### <span id="properties.defaults.minReaderVersion"><span id="DELTA_PROTOCOL_DEFAULT_READER_VERSION"> properties.defaults.minReaderVersion

**spark.databricks.delta.properties.defaults.minReaderVersion** is the default reader protocol version to create new tables with, unless a feature that requires a higher version for correctness is enabled.

Default: `1`

Available values: `1`

Used when:

* `Protocol` utility is used to [create a Protocol](../Protocol.md#apply)

### <span id="properties.defaults.minWriterVersion"><span id="DELTA_PROTOCOL_DEFAULT_WRITER_VERSION"> properties.defaults.minWriterVersion

**spark.databricks.delta.properties.defaults.minWriterVersion** is the default writer protocol version to create new tables with, unless a feature that requires a higher version for correctness is enabled.

Default: `2`

Available values: `1`, `2`, `3`

Used when:

* `Protocol` utility is used to [create a Protocol](../Protocol.md#apply)

### <span id="REPLACEWHERE_CONSTRAINT_CHECK_ENABLED"> replaceWhere.constraintCheck.enabled { #replaceWhere.constraintCheck.enabled }

**spark.databricks.delta.replaceWhere.constraintCheck.enabled**

Controls whether or not [replaceWhere](../spark-connector/options.md#replaceWhere) on arbitrary expression and arbitrary columns enforces [constraints](../constraints/index.md) to replace the target table only when all the rows in the source dataframe match that constraint.

If disabled, it will skip the constraint check and replace with all the rows from the new dataframe.

Default: `true`

Used when:

* `WriteIntoDelta` is requested to [extract constraints](../commands/WriteIntoDelta.md#extractConstraints)

### <span id="retentionDurationCheck.enabled"><span id="DELTA_VACUUM_RETENTION_CHECK_ENABLED"> retentionDurationCheck.enabled

**spark.databricks.delta.retentionDurationCheck.enabled** adds a check preventing users from running vacuum with a very short retention period, which may end up corrupting a Delta log.

Default: `true`

### <span id="sampling.enabled"><span id="DELTA_SAMPLE_ESTIMATOR_ENABLED"> sampling.enabled

**spark.databricks.delta.sampling.enabled** (internal) enables sample-based estimation

Default: `false`

### <span id="DELTA_SCHEMA_AUTO_MIGRATE"> schema.autoMerge.enabled { #schema.autoMerge.enabled }

**spark.databricks.delta.schema.autoMerge.enabled**

Enables schema merging on appends (UPDATEs) and overwrites (INSERTs).

Default: `false`

Equivalent DataFrame option: [mergeSchema](../spark-connector/options.md#mergeSchema)

Used when:

* `DeltaMergeInto` utility is used to [resolveReferencesAndSchema](../commands/merge/DeltaMergeInto.md#resolveReferencesAndSchema)
* `MetadataMismatchErrorBuilder` is requested to `addSchemaMismatch`
* `DeltaWriteOptionsImpl` is requested for [canMergeSchema](../spark-connector/DeltaWriteOptionsImpl.md#canMergeSchema)
* `MergeIntoCommand` is requested for [canMergeSchema](../commands/merge/MergeIntoCommand.md#canMergeSchema)

### <span id="DELTA_SCHEMA_REMOVE_SPARK_INTERNAL_METADATA"> schema.removeSparkInternalMetadata { #schema.removeSparkInternalMetadata }

(internal) **spark.databricks.delta.schema.removeSparkInternalMetadata**

Whether to remove leaked Spark's internal metadata from the table schema before returning
to Spark.
These internal metadata might be stored unintentionally in tables created by
old Spark versions.

Default: `true`

Used when:

* `DeltaTableUtils` utility is used to [removeInternalMetadata](../DeltaTableUtils.md#removeInternalMetadata)

### <span id="schema.typeCheck.enabled"><span id="DELTA_SCHEMA_TYPE_CHECK"> schema.typeCheck.enabled

**spark.databricks.delta.schema.typeCheck.enabled** (internal) controls whether to check unsupported data types while updating a table schema

Disabling this flag may allow users to create unsupported Delta tables and should only be used when trying to read/write legacy tables.

Default: `true`

Used when:

* `OptimisticTransactionImpl` is requested for [checkUnsupportedDataType flag](../OptimisticTransactionImpl.md#checkUnsupportedDataType)
* `DeltaErrorsBase` is requested to [unsupportedDataTypes](../DeltaErrors.md#unsupportedDataTypes)

### <span id="snapshotIsolation.enabled"><span id="DELTA_SNAPSHOT_ISOLATION"> snapshotIsolation.enabled

**spark.databricks.delta.snapshotIsolation.enabled** (internal) controls whether queries on Delta tables are guaranteed to have snapshot isolation

Default: `true`

### <span id="snapshotPartitions"><span id="DELTA_SNAPSHOT_PARTITIONS"> snapshotPartitions

**spark.databricks.delta.snapshotPartitions** (internal) is the number of partitions to use for **state reconstruction** (when [building a snapshot](../Snapshot.md#stateReconstruction) of a Delta table).

Default: `50`

### <span id="stalenessLimit"><span id="DELTA_ASYNC_UPDATE_STALENESS_TIME_LIMIT"> stalenessLimit

**spark.databricks.delta.stalenessLimit** (in millis) allows you to query the last loaded state of the Delta table without blocking on a table update. You can use this configuration to reduce the latency on queries when up-to-date results are not a requirement. Table updates will be scheduled on a separate scheduler pool in a FIFO queue, and will share cluster resources fairly with your query. If a table hasn't updated past this time limit, we will block on a synchronous state update before running the query.

Default: `0` (no tables can be stale)

### <span id="state.corruptionIsFatal"><span id="DELTA_STATE_CORRUPTION_IS_FATAL"> state.corruptionIsFatal

**spark.databricks.delta.state.corruptionIsFatal** (internal) throws a fatal error when the recreated Delta State doesn't
match committed checksum file

Default: `true`

### <span id="stateReconstructionValidation.enabled"><span id="DELTA_STATE_RECONSTRUCTION_VALIDATION_ENABLED"> stateReconstructionValidation.enabled

**spark.databricks.delta.stateReconstructionValidation.enabled** (internal) controls whether to perform validation checks on the reconstructed state

Default: `true`

### <span id="stats.collect"><span id="DELTA_COLLECT_STATS"> stats.collect { #spark.databricks.delta.stats.collect }

**spark.databricks.delta.stats.collect**

(internal) Enables statistics to be collected while writing files into a delta table

Default: `true`

Used when:

* [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md) is executed
* `TransactionalWrite` is requested to [write data out](../TransactionalWrite.md#writeFiles) (and [getOptionalStatsTrackerAndStatsCollection](../TransactionalWrite.md#getOptionalStatsTrackerAndStatsCollection))

### <span id="stats.collect.using.tableSchema"><span id="DELTA_COLLECT_STATS_USING_TABLE_SCHEMA"> stats.collect.using.tableSchema { #spark.databricks.delta.stats.collect.using.tableSchema }

**spark.databricks.delta.stats.collect.using.tableSchema**

(internal) When collecting stats while writing files into Delta table (with [spark.databricks.delta.stats.collect](#stats.collect) enabled), whether to use the table schema (`true`) or the DataFrame schema (`false`) as the stats collection schema.

Default: `true`

Used when:

* `TransactionalWrite` is requested to [getOptionalStatsTrackerAndStatsCollection](../TransactionalWrite.md#getOptionalStatsTrackerAndStatsCollection)

### <span id="stats.limitPushdown.enabled"><span id="DELTA_LIMIT_PUSHDOWN_ENABLED"> stats.limitPushdown.enabled

**spark.databricks.delta.stats.limitPushdown.enabled** (internal) enables using the limit clause and file statistics to prune files before they are collected to the driver

Default: `true`

### <span id="stats.localCache.maxNumFiles"><span id="DELTA_STATS_SKIPPING_LOCAL_CACHE_MAX_NUM_FILES"> stats.localCache.maxNumFiles

**spark.databricks.delta.stats.localCache.maxNumFiles** (internal) is the maximum number of files for a table to be considered a **delta small table**. Some metadata operations (such as using data skipping) are optimized for small tables using driver local caching and local execution.

Default: `2000`

### <span id="stats.skipping"><span id="DELTA_STATS_SKIPPING"> stats.skipping

**spark.databricks.delta.stats.skipping** (internal) enables [Data Skipping](../data-skipping/index.md)

Default: `true`

Used when:

* `DataSkippingReaderBase` is requested for the [files to scan](../data-skipping/DataSkippingReaderBase.md#filesForScan)
* `PrepareDeltaScanBase` logical optimization is [executed](../data-skipping/PrepareDeltaScanBase.md#apply)

### <span id="DELTA_STREAMING_ENABLE_SCHEMA_TRACKING"> streaming.schemaTracking.enabled { #streaming.schemaTracking.enabled }

**spark.databricks.delta.streaming.schemaTracking.enabled**

**(internal)** Controls whether the [delta streaming source](../spark-connector/DeltaDataSource.md) can support non-additive schema evolution for operations such as rename or drop column on column mapping enabled tables

Default: `true`

Used when:

* `DeltaErrorsBase` is requested to [blockStreamingReadsWithIncompatibleColumnMappingSchemaChanges](../DeltaErrorsBase.md#blockStreamingReadsWithIncompatibleColumnMappingSchemaChanges)
* `DeltaDataSource` is requested for a [DeltaSourceMetadataTrackingLog](../spark-connector/DeltaDataSource.md#getMetadataTrackingLogForDeltaSource)

### <span id="DELTA_STREAMING_UNSAFE_READ_ON_INCOMPATIBLE_COLUMN_MAPPING_SCHEMA_CHANGES"> streaming.unsafeReadOnIncompatibleColumnMappingSchemaChanges.enabled { #streaming.unsafeReadOnIncompatibleColumnMappingSchemaChanges.enabled }

**spark.databricks.delta.streaming.unsafeReadOnIncompatibleColumnMappingSchemaChanges.enabled**

**(internal)** Controls (possibly unsafe) streaming read on delta tables with column mapping schema operations (e.g. rename or drop column) that could lead to data loss and schema confusion.

Default: `false`

Used when:

* `DeltaSourceBase` is requested for the [allowUnsafeStreamingReadOnColumnMappingSchemaChanges](../spark-connector/DeltaSourceBase.md#allowUnsafeStreamingReadOnColumnMappingSchemaChanges)

### <span id="RESOLVE_TIME_TRAVEL_ON_IDENTIFIER"> timeTravel.resolveOnIdentifier.enabled { #timeTravel.resolveOnIdentifier.enabled }

**spark.databricks.delta.timeTravel.resolveOnIdentifier.enabled**

**(internal)** Enables [time travel](../time-travel/index.md) patterns (as `@v123` and `@yyyyMMddHHmmssSSS`) in the path identifiers of delta tables

Default: `true`

### <span id="UPDATE_USE_PERSISTENT_DELETION_VECTORS"> update.deletionVectors.persistent { #update.deletionVectors.persistent }

**spark.databricks.delta.update.deletionVectors.persistent**

**(internal)** Enables [persistent Deletion Vectors](../deletion-vectors/index.md) in [UPDATE](../commands/update/index.md) command

Default: `true`

Used when:

* [UpdateCommand](../commands/update/UpdateCommand.md) is executed (and [shouldWritePersistentDeletionVectors](../commands/update/UpdateCommand.md#shouldWritePersistentDeletionVectors))

### <span id="vacuum.parallelDelete.enabled"><span id="DELTA_VACUUM_PARALLEL_DELETE_ENABLED"> vacuum.parallelDelete.enabled

**spark.databricks.delta.vacuum.parallelDelete.enabled** enables parallelizing the deletion of files during [vacuum](../commands/vacuum/index.md) command.

Default: `false`

Enabling may result hitting rate limits on some storage backends. When enabled, parallelization is controlled by the default number of shuffle partitions.

### <span id="write.txnAppId"><span id="DELTA_IDEMPOTENT_DML_TXN_APP_ID"> write.txnAppId { #spark.databricks.delta.write.txnAppId }

**spark.databricks.delta.write.txnAppId**

**(internal)** The user-defined application ID a write will be committed with.
If specified, [spark.databricks.delta.write.txnVersion](#spark.databricks.delta.write.txnVersion) has to be set, too.

Default: (undefined)

Used when:

* `DeltaCommand` is requested for the [txnVersion and txnAppId](../commands/DeltaCommand.md#getTxnVersionAndAppId)

### <span id="write.txnVersion"><span id="DELTA_IDEMPOTENT_DML_TXN_VERSION"> write.txnVersion { #spark.databricks.delta.write.txnVersion }

**spark.databricks.delta.write.txnVersion**

**(internal)** The user-defined transaction version a write will be committed with.
If specified, [spark.databricks.delta.write.txnAppId](#spark.databricks.delta.write.txnAppId) has to be set, too.
To ensure idempotency, `txnVersion`s across different writes need to be monotonically increasing.

Default: (undefined)

Used when:

* `DeltaCommand` is requested to [create a SetTransaction action](../commands/DeltaCommand.md#createSetTransaction), for the [txnVersion and txnAppId](../commands/DeltaCommand.md#getTxnVersionAndAppId) and [hasBeenExecuted](../commands/DeltaCommand.md#hasBeenExecuted)

### <span id="write.txnVersion.autoReset.enabled"><span id="DELTA_IDEMPOTENT_DML_AUTO_RESET_ENABLED"> write.txnVersion.autoReset.enabled

**spark.databricks.delta.write.txnVersion.autoReset.enabled**

**(internal)** When enabled, automatically resets [spark.databricks.delta.write.txnVersion](#spark.databricks.delta.write.txnVersion) after every write

If the `txnAppId` and `txnVersion` both [come from the session config](../commands/DeltaCommand.md#getTxnVersionAndAppId) (based on [write.txnAppId](#write.txnAppId) and [write.txnVersion](#write.txnVersion), respectively), [spark.databricks.delta.write.txnVersion](#spark.databricks.delta.write.txnVersion) is reset (_unset_), after skipping the current transaction, as a safety measure to prevent data loss if the user forgets to manually reset `txnVersion`

Default: `false`

Used when:

* `DeltaCommand` is requested to [create a SetTransaction action](../commands/DeltaCommand.md#createSetTransaction) and [hasBeenExecuted](../commands/DeltaCommand.md#hasBeenExecuted)

## spark.delta.logStore.class { #spark.delta.logStore.class }

The fully-qualified class name of a [LogStore](../storage/LogStore.md)

Default: [HDFSLogStore](../storage/HDFSLogStore.md)

Used when:

* `LogStoreProvider` is requested for a [LogStore](../storage/LogStoreProvider.md#createLogStore)
