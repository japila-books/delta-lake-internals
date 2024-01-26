# Auto Compaction

**Auto Compaction** feature in Delta Lake allows for compacting files after a [successful write](../OptimisticTransactionImpl.md#registerPostCommitHook) into a delta table.

Auto Compaction can be enabled system-wide using [spark.databricks.delta.autoCompact.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.enabled) configuration property.

Auto Compaction can be enabled on a delta table using [delta.autoOptimize.autoCompact](../DeltaConfigs.md#autoOptimize.autoCompact) table property.

??? note "delta.autoOptimize Table Property is Deprecated"
    [delta.autoOptimize](../DeltaConfigs.md#delta.autoOptimize) table property is deprecated.

Auto Compaction uses [AutoCompact](AutoCompact.md) post-commit hook to be [executed](AutoCompactBase.md#run) at a [successful transaction commit](../OptimisticTransactionImpl.md#registerPostCommitHook) if there are files written to a delta table that can leverage compaction after a commit.
