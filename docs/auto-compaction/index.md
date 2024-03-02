# Auto Compaction

**Auto Compaction** feature allows performing [OPTIMIZE](../commands/index.md) command at the end of a transaction (and [compacting files](AutoCompactBase.md#compact) upon a [successful write](../OptimisticTransactionImpl.md#registerPostCommitHook) into a delta table).

Auto Compaction can be enabled system-wide or per table using [spark.databricks.delta.autoCompact.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.enabled) configuration property or [delta.autoOptimize.autoCompact](../table-properties/DeltaConfigs.md#autoOptimize.autoCompact) table property, respectively.

??? warning "delta.autoOptimize Table Property Deprecated"
    [delta.autoOptimize](../table-properties/DeltaConfigs.md#delta.autoOptimize) table property is deprecated.

Auto Compaction uses [AutoCompact](AutoCompact.md) post-commit hook to be [executed](AutoCompactBase.md#run) at a [successful transaction commit](../OptimisticTransactionImpl.md#registerPostCommitHook) if there are files written to a delta table and it even makes sense to run such a heavy file rewritting job.

Eventually, Auto Compaction uses [OptimizeExecutor](../commands/optimize/OptimizeExecutor.md) (with no [zOrderByColumns](../commands/optimize/OptimizeExecutor.md#zOrderByColumns) and the [isAutoCompact](../commands/optimize/OptimizeExecutor.md#isAutoCompact) flag enabled) to run [optimization](../commands/optimize/OptimizeExecutor.md#optimize).

Auto Compaction uses the following configuration properties:

* [spark.databricks.delta.autoCompact.maxFileSize](../configuration-properties/index.md#spark.databricks.delta.autoCompact.maxFileSize)
* [spark.databricks.delta.autoCompact.minFileSize](../configuration-properties/index.md#spark.databricks.delta.autoCompact.minFileSize)
