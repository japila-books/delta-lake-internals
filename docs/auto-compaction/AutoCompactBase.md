# AutoCompactBase

`AutoCompactBase` is an [extension](#contract) of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md) abstraction for [post-commit hooks](#implementations) that [perform auto compaction](#run).

## Implementations

* [AutoCompact](AutoCompact.md)

## Name { #name }

??? note "PostCommitHook"

    ```scala
    name: String
    ```

    `name` is part of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md#name) abstraction.

`name` is **Auto Compact**.

## Executing Post-Commit Hook { #run }

??? note "PostCommitHook"

    ```scala
    run(
      spark: SparkSession,
      txn: OptimisticTransactionImpl,
      committedVersion: Long,
      postCommitSnapshot: Snapshot,
      actions: Seq[Action]): Unit
    ```

    `run` is part of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md#run) abstraction.

`run` [determines the type of AutoCompact](#getAutoCompactType).

`run` returns (and hence skips auto compacting) when [shouldSkipAutoCompact](#shouldSkipAutoCompact) is enabled.

In the end, `run` [compactIfNecessary](#compactIfNecessary) with the following:

* `delta.commit.hooks.autoOptimize` operation name
* `maxDeletedRowsRatio` unspecified (`None`)

### compactIfNecessary { #compactIfNecessary }

```scala
compactIfNecessary(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  postCommitSnapshot: Snapshot,
  opType: String,
  maxDeletedRowsRatio: Option[Double]): Seq[OptimizeMetrics]
```

`compactIfNecessary` [prepareAutoCompactRequest](AutoCompactUtils.md#prepareAutoCompactRequest).

When [shouldCompact](AutoCompactRequest.md#shouldCompact) is disabled, `compactIfNecessary` returns no [OptimizeMetrics](../commands/optimize/OptimizeMetrics.md).

Otherwise, with [shouldCompact](AutoCompactRequest.md#shouldCompact) turned on, `compactIfNecessary` [performs auto compaction](AutoCompact.md#compact).
