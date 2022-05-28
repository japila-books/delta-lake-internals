# DeltaSQLConf &mdash; spark.databricks.delta Configuration Properties

`DeltaSQLConf` contains **spark.databricks.delta**-prefixed configuration properties to configure behaviour of Delta Lake.

## <span id="alterLocation.bypassSchemaCheck"><span id="DELTA_ALTER_LOCATION_BYPASS_SCHEMA_CHECK"> alterLocation.bypassSchemaCheck

**spark.databricks.delta.alterLocation.bypassSchemaCheck** enables Alter Table Set Location on Delta to go through even if the Delta table in the new location has a different schema from the original Delta table

Default: `false`

## <span id="checkLatestSchemaOnRead"><span id="DELTA_SCHEMA_ON_READ_CHECK_ENABLED"> checkLatestSchemaOnRead

**spark.databricks.delta.checkLatestSchemaOnRead** enables a check that ensures that users won't read corrupt data if the source schema changes in an incompatible way.

Default: `true`

Delta always tries to give users the latest version of table data without having to call `REFRESH TABLE` or redefine their DataFrames when used in the context of streaming. There is a possibility that the schema of the latest version of the table may be incompatible with the schema at the time of DataFrame creation.

## <span id="checkpoint.partSize"><span id="DELTA_CHECKPOINT_PART_SIZE"> checkpoint.partSize

**spark.databricks.delta.checkpoint.partSize** (internal) is the limit at which we will start parallelizing the checkpoint. We will attempt to write maximum of this many actions per checkpoint.

Default: `5000000`

## <span id="commitInfo.enabled"><span id="DELTA_COMMIT_INFO_ENABLED"> commitInfo.enabled

**spark.databricks.delta.commitInfo.enabled** controls whether to [log commit information into a Delta log](OptimisticTransactionImpl.md#commitInfo).

Default: `true`

## <span id="commitInfo.userMetadata"><span id="DELTA_USER_METADATA"> commitInfo.userMetadata

**spark.databricks.delta.commitInfo.userMetadata** is an arbitrary user-defined metadata to include in [CommitInfo](CommitInfo.md#userMetadata) (requires [spark.databricks.delta.commitInfo.enabled](#commitInfo.enabled)).

Default: (empty)

## <span id="commitValidation.enabled"><span id="DELTA_COMMIT_VALIDATION_ENABLED"> commitValidation.enabled

**spark.databricks.delta.commitValidation.enabled** (internal) controls whether to perform validation checks before commit or not

Default: `true`

## <span id="convert.metadataCheck.enabled"><span id="DELTA_CONVERT_METADATA_CHECK_ENABLED"> convert.metadataCheck.enabled

**spark.databricks.delta.convert.metadataCheck.enabled** enables validation during convert to delta, if there is a difference between the catalog table's properties and the Delta table's configuration, we should error.

If disabled, merge the two configurations with the same semantics as update and merge

Default: `true`

## <span id="dummyFileManager.numOfFiles"><span id="DUMMY_FILE_MANAGER_NUM_OF_FILES"> dummyFileManager.numOfFiles

**spark.databricks.delta.dummyFileManager.numOfFiles** (internal) controls how many dummy files to write in DummyFileManager

Default: `3`

## <span id="dummyFileManager.prefix"><span id="DUMMY_FILE_MANAGER_PREFIX"> dummyFileManager.prefix

**spark.databricks.delta.dummyFileManager.prefix** (internal) is the file prefix to use in DummyFileManager

Default: `.s3-optimization-`

## <span id="history.maxKeysPerList"><span id="DELTA_HISTORY_PAR_SEARCH_THRESHOLD"> history.maxKeysPerList

**spark.databricks.delta.history.maxKeysPerList** (internal) controls how many commits to list when performing a parallel search.

The default is the maximum keys returned by S3 per list call. Azure can return 5000, therefore we choose 1000.

Default: `1000`

## <span id="history.metricsEnabled"><span id="DELTA_HISTORY_METRICS_ENABLED"> history.metricsEnabled

**spark.databricks.delta.history.metricsEnabled** enables metrics reporting in `DESCRIBE HISTORY` ([CommitInfo](CommitInfo.md) will record the operation metrics when a `OptimisticTransactionImpl` is [committed](OptimisticTransactionImpl.md#commit) and the [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#DELTA_COMMIT_INFO_ENABLED) configuration property is enabled).

Requires [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#DELTA_COMMIT_INFO_ENABLED) configuration property to be enabled

Default: `true`

Used when:

* `OptimisticTransactionImpl` is requested to [getOperationMetrics](OptimisticTransactionImpl.md#getOperationMetrics)
* `ConvertToDeltaCommand` is requested to [streamWrite](commands/convert/ConvertToDeltaCommand.md#streamWrite)
* `SQLMetricsReporting` is requested to [registerSQLMetrics](SQLMetricsReporting.md#registerSQLMetrics)
* `TransactionalWrite` is requested to [writeFiles](TransactionalWrite.md#writeFiles)

!!! note "Github Commit"
    The feature was added as part of [[SC-24567][DELTA] Add additional metrics to Describe Delta History](https://github.com/delta-io/delta/commit/54643efc07dfaa9028d228dcad6502d59e4bdb3a) commit.

## <span id="import.batchSize.schemaInference"><span id="DELTA_IMPORT_BATCH_SIZE_SCHEMA_INFERENCE"> import.batchSize.schemaInference

**spark.databricks.delta.import.batchSize.schemaInference** (internal) is the number of files per batch for schema inference during [import](commands/convert/ConvertToDeltaCommand.md#performConvert-schemaBatchSize).

Default: `1000000`

## <span id="import.batchSize.statsCollection"><span id="DELTA_IMPORT_BATCH_SIZE_STATS_COLLECTION"> import.batchSize.statsCollection

**spark.databricks.delta.import.batchSize.statsCollection** (internal) is the number of files per batch for stats collection during [import](commands/convert/ConvertToDeltaCommand.md#performConvert-schemaBatchSize).

Default: `50000`

## <span id="loadFileSystemConfigsFromDataFrameOptions"><span id="LOAD_FILE_SYSTEM_CONFIGS_FROM_DATAFRAME_OPTIONS"> loadFileSystemConfigsFromDataFrameOptions

**spark.databricks.delta.loadFileSystemConfigsFromDataFrameOptions** (internal) controls whether to load file systems configs provided in `DataFrameReader` or `DataFrameWriter` options when
calling `DataFrameReader.load/DataFrameWriter.save` using a Delta table path.

Not supported for `DataFrameReader.table` and `DataFrameWriter.saveAsTable`

Default: `true`

## <span id="maxSnapshotLineageLength"><span id="DELTA_MAX_SNAPSHOT_LINEAGE_LENGTH"> maxSnapshotLineageLength

**spark.databricks.delta.maxSnapshotLineageLength** (internal) is the maximum lineage length of a Snapshot before Delta forces to build a Snapshot from scratch

Default: `50`

## <span id="merge.maxInsertCount"><span id="MERGE_MAX_INSERT_COUNT"> merge.maxInsertCount

**spark.databricks.delta.merge.maxInsertCount** (internal) is the maximum row count of inserts in each MERGE execution

Default: `10000L`

## <span id="merge.optimizeInsertOnlyMerge.enabled"><span id="MERGE_INSERT_ONLY_ENABLED"> merge.optimizeInsertOnlyMerge.enabled

**spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled** (internal) controls merge without any matched clause (i.e., insert-only merge) will be optimized by avoiding rewriting old files and just inserting new files

Default: `true`

## <span id="merge.optimizeMatchedOnlyMerge.enabled"><span id="MERGE_MATCHED_ONLY_ENABLED"> merge.optimizeMatchedOnlyMerge.enabled

**spark.databricks.delta.merge.optimizeMatchedOnlyMerge.enabled** (internal) controls merge without 'when not matched' clause will be optimized to use a right outer join instead of a full outer join

Default: `true`

## <span id="merge.repartitionBeforeWrite.enabled"><span id="MERGE_REPARTITION_BEFORE_WRITE"> merge.repartitionBeforeWrite.enabled

**spark.databricks.delta.merge.repartitionBeforeWrite.enabled** (internal) controls whether [MERGE](commands/merge/index.md) command repartitions output before writing the files (by the table's partition columns)

Default: `true`

Used when:

* `MergeIntoCommand` is requested to [repartitionIfNeeded](commands/merge/MergeIntoCommand.md#repartitionIfNeeded)

## <span id="optimize.maxFileSize"><span id="DELTA_OPTIMIZE_MAX_FILE_SIZE"> optimize.maxFileSize

**spark.databricks.delta.optimize.maxFileSize** (internal) Target file size produced by [OPTIMIZE](sql/index.md#OPTIMIZE) command.

Default: `1024 * 1024 * 1024`

Used when:

* `OptimizeExecutor` is requested to [optimize](commands/optimize/OptimizeExecutor.md#optimize)

## <span id="optimize.maxThreads"><span id="DELTA_OPTIMIZE_MAX_THREADS"> optimize.maxThreads

**spark.databricks.delta.optimize.maxThreads** (internal) Maximum number of parallel jobs allowed in [OPTIMIZE](sql/index.md#OPTIMIZE) command.
Increasing the maximum parallel jobs allows `OPTIMIZE` command to run faster, but increases the job management on the Spark driver.

Default: `15`

Used when:

* `OptimizeExecutor` is requested to [optimize](commands/optimize/OptimizeExecutor.md#optimize)

## <span id="optimize.minFileSize"><span id="DELTA_OPTIMIZE_MIN_FILE_SIZE"> optimize.minFileSize

**spark.databricks.delta.optimize.minFileSize** (internal) Files which are smaller than this threshold (in bytes) will be grouped together and rewritten as larger files by the [OPTIMIZE](sql/index.md#OPTIMIZE) command.

Default: `1024 * 1024 * 1024`

Used when:

* `OptimizeExecutor` is requested to [optimize](commands/optimize/OptimizeExecutor.md#optimize)

## <span id="partitionColumnValidity.enabled"><span id="DELTA_PARTITION_COLUMN_CHECK_ENABLED"> partitionColumnValidity.enabled

**spark.databricks.delta.partitionColumnValidity.enabled** (internal) enables validation of the partition column names (just like the data columns)

Default: `true`

## <span id="properties.defaults.minReaderVersion"><span id="DELTA_PROTOCOL_DEFAULT_READER_VERSION"> properties.defaults.minReaderVersion

**spark.databricks.delta.properties.defaults.minReaderVersion** is the default reader protocol version to create new tables with, unless a feature that requires a higher version for correctness is enabled.

Default: `1`

Available values: `1`

Used when:

* `Protocol` utility is used to [create a Protocol](Protocol.md#apply)

## <span id="properties.defaults.minWriterVersion"><span id="DELTA_PROTOCOL_DEFAULT_WRITER_VERSION"> properties.defaults.minWriterVersion

**spark.databricks.delta.properties.defaults.minWriterVersion** is the default writer protocol version to create new tables with, unless a feature that requires a higher version for correctness is enabled.

Default: `2`

Available values: `1`, `2`, `3`

Used when:

* `Protocol` utility is used to [create a Protocol](Protocol.md#apply)

## <span id="retentionDurationCheck.enabled"><span id="DELTA_VACUUM_RETENTION_CHECK_ENABLED"> retentionDurationCheck.enabled

**spark.databricks.delta.retentionDurationCheck.enabled** adds a check preventing users from running vacuum with a very short retention period, which may end up corrupting a Delta log.

Default: `true`

## <span id="sampling.enabled"><span id="DELTA_SAMPLE_ESTIMATOR_ENABLED"> sampling.enabled

**spark.databricks.delta.sampling.enabled** (internal) enables sample-based estimation

Default: `false`

## <span id="schema.autoMerge.enabled"><span id="DELTA_SCHEMA_AUTO_MIGRATE"> schema.autoMerge.enabled

**spark.databricks.delta.schema.autoMerge.enabled** enables schema merging on appends and overwrites.

Default: `false`

Equivalent DataFrame option: [mergeSchema](options.md#mergeSchema)

## <span id="snapshotIsolation.enabled"><span id="DELTA_SNAPSHOT_ISOLATION"> snapshotIsolation.enabled

**spark.databricks.delta.snapshotIsolation.enabled** (internal) controls whether queries on Delta tables are guaranteed to have snapshot isolation

Default: `true`

## <span id="snapshotPartitions"><span id="DELTA_SNAPSHOT_PARTITIONS"> snapshotPartitions

**spark.databricks.delta.snapshotPartitions** (internal) is the number of partitions to use for **state reconstruction** (when [building a snapshot](Snapshot.md#stateReconstruction) of a Delta table).

Default: `50`

## <span id="stalenessLimit"><span id="DELTA_ASYNC_UPDATE_STALENESS_TIME_LIMIT"> stalenessLimit

**spark.databricks.delta.stalenessLimit** (in millis) allows you to query the last loaded state of the Delta table without blocking on a table update. You can use this configuration to reduce the latency on queries when up-to-date results are not a requirement. Table updates will be scheduled on a separate scheduler pool in a FIFO queue, and will share cluster resources fairly with your query. If a table hasn't updated past this time limit, we will block on a synchronous state update before running the query.

Default: `0` (no tables can be stale)

## <span id="state.corruptionIsFatal"><span id="DELTA_STATE_CORRUPTION_IS_FATAL"> state.corruptionIsFatal

**spark.databricks.delta.state.corruptionIsFatal** (internal) throws a fatal error when the recreated Delta State doesn't
match committed checksum file

Default: `true`

## <span id="stateReconstructionValidation.enabled"><span id="DELTA_STATE_RECONSTRUCTION_VALIDATION_ENABLED"> stateReconstructionValidation.enabled

**spark.databricks.delta.stateReconstructionValidation.enabled** (internal) controls whether to perform validation checks on the reconstructed state

Default: `true`

## <span id="stats.collect"><span id="DELTA_COLLECT_STATS"> stats.collect

**spark.databricks.delta.stats.collect** (internal) Enables statistics to be collected while writing files into a Delta table

Default: `true`

Used when:

* `TransactionalWrite` is requested to [writeFiles](TransactionalWrite.md#writeFiles)

## <span id="stats.limitPushdown.enabled"><span id="DELTA_LIMIT_PUSHDOWN_ENABLED"> stats.limitPushdown.enabled

**spark.databricks.delta.stats.limitPushdown.enabled** (internal) enables using the limit clause and file statistics to prune files before they are collected to the driver

Default: `true`

## <span id="stats.localCache.maxNumFiles"><span id="DELTA_STATS_SKIPPING_LOCAL_CACHE_MAX_NUM_FILES"> stats.localCache.maxNumFiles

**spark.databricks.delta.stats.localCache.maxNumFiles** (internal) is the maximum number of files for a table to be considered a **delta small table**. Some metadata operations (such as using data skipping) are optimized for small tables using driver local caching and local execution.

Default: `2000`

## <span id="stats.skipping"><span id="DELTA_STATS_SKIPPING"> stats.skipping

**spark.databricks.delta.stats.skipping** (internal) enables statistics for [Data Skipping](data-skipping/index.md) optimization

Default: `true`

## <span id="timeTravel.resolveOnIdentifier.enabled"><span id="RESOLVE_TIME_TRAVEL_ON_IDENTIFIER"> timeTravel.resolveOnIdentifier.enabled

**spark.databricks.delta.timeTravel.resolveOnIdentifier.enabled** (internal) controls whether to resolve patterns as `@v123` and `@yyyyMMddHHmmssSSS` in path identifiers as [time travel](time-travel.md) nodes.

Default: `true`

## <span id="vacuum.parallelDelete.enabled"><span id="DELTA_VACUUM_PARALLEL_DELETE_ENABLED"> vacuum.parallelDelete.enabled

**spark.databricks.delta.vacuum.parallelDelete.enabled** enables parallelizing the deletion of files during [vacuum](commands/vacuum/index.md) command.

Default: `false`

Enabling may result hitting rate limits on some storage backends. When enabled, parallelization is controlled by the default number of shuffle partitions.

## <span id="io.skipping.stringPrefixLength"><span id="DATA_SKIPPING_STRING_PREFIX_LENGTH"> io.skipping.stringPrefixLength

**spark.databricks.io.skipping.stringPrefixLength** (internal) The length of the prefix of string columns to store in the data skipping index

Default: `32`

Used when:

* `StatisticsCollection` is requested for the [statsCollector Column](StatisticsCollection.md#statsCollector)
