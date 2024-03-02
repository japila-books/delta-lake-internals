# Auto Compaction

**Auto Compaction** feature in Delta Lake is responsible for [compacting files](AutoCompactBase.md#compact) upon a [successful write](../OptimisticTransactionImpl.md#registerPostCommitHook) into a delta table.

Auto Compaction can be enabled system-wide or per table using [spark.databricks.delta.autoCompact.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.enabled) configuration property or [delta.autoOptimize.autoCompact](../table-properties/DeltaConfigs.md#autoOptimize.autoCompact) table property, respectively.

??? warning "delta.autoOptimize Table Property Deprecated"
    [delta.autoOptimize](../table-properties/DeltaConfigs.md#delta.autoOptimize) table property is deprecated.

Auto Compaction uses [AutoCompact](AutoCompact.md) post-commit hook to be [executed](AutoCompactBase.md#run) at a [successful transaction commit](../OptimisticTransactionImpl.md#registerPostCommitHook) if there are files written to a delta table that can leverage compaction after a commit.
