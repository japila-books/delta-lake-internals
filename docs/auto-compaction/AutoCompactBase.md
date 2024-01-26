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

`run` [determines whether Auto Compaction is enabled or not](#getAutoCompactType).

`run` does nothing and returns (and hence skips auto compacting) when [shouldSkipAutoCompact](#shouldSkipAutoCompact) is enabled.

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

### getAutoCompactType { #getAutoCompactType }

```scala
getAutoCompactType(
  conf: SQLConf,
  metadata: Metadata): Option[AutoCompactType]
```

`getAutoCompactType` is the value of the following (in the order of precedence):

1. [spark.databricks.delta.autoCompact.enabled](../configuration-properties/DeltaSQLConf.md#autoCompact.enabled), if configured.
1. [delta.autoOptimize](../DeltaConfigs.md#AUTO_OPTIMIZE) table property
1. [delta.autoOptimize.autoCompact](../DeltaConfigs.md#AUTO_COMPACT) table property

`getAutoCompactType` defaults to `false`.

### shouldSkipAutoCompact { #shouldSkipAutoCompact }

```scala
shouldSkipAutoCompact(
  autoCompactTypeOpt: Option[AutoCompactType],
  spark: SparkSession,
  txn: OptimisticTransactionImpl): Boolean
```

`shouldSkipAutoCompact` is enabled (`true`) for the following:

1. The given `AutoCompactType` is empty (`None`)
1. [isQualifiedForAutoCompact](AutoCompactUtils.md#isQualifiedForAutoCompact) is disabled
