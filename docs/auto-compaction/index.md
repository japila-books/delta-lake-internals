# Auto Compaction

**Auto Compaction** feature in Delta Lake uses [AutoCompact](AutoCompact.md) post-commit hook to [run](AutoCompactBase.md#run) at a [successful transaction commit](../OptimisticTransactionImpl.md#registerPostCommitHook).
