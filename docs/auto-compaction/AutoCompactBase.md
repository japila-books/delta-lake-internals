# AutoCompactBase

`AutoCompactBase` is an [extension](#contract) of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md) abstraction for [post-commit hooks](#implementations) that [perform auto compaction](#compact).

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

### Compacting If Necessary { #compactIfNecessary }

```scala
compactIfNecessary(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  postCommitSnapshot: Snapshot,
  opType: String,
  maxDeletedRowsRatio: Option[Double]): Seq[OptimizeMetrics]
```

!!! note "`maxDeletedRowsRatio` always undefined (`None`)"

`compactIfNecessary` [prepares an AutoCompactRequest](AutoCompactUtils.md#prepareAutoCompactRequest) to determine whether to [perform auto compaction](#compact) or not (based on [shouldCompact](AutoCompactRequest.md#shouldCompact) flag of the [AutoCompactRequest](AutoCompactRequest.md)).

With [shouldCompact](AutoCompactRequest.md#shouldCompact) flag enabled, `compactIfNecessary` [performs auto compaction](#compact). Otherwise, `compactIfNecessary` returns no [OptimizeMetrics](../commands/optimize/OptimizeMetrics.md).

### getAutoCompactType { #getAutoCompactType }

```scala
getAutoCompactType(
  conf: SQLConf,
  metadata: Metadata): Option[AutoCompactType]
```

??? note "Return Type"
    `Option[AutoCompactType]` is the return type but it's a _fancy_ way to say "enabled" or "not".

    When `getAutoCompactType` returns `Some[AutoCompactType]` it means "enabled" while `None` is "disabled".

`getAutoCompactType` is enabled when either is `true` (in the order of precedence):

1. [spark.databricks.delta.autoCompact.enabled](../configuration-properties/index.md#autoCompact.enabled)
1. (deprecated) [delta.autoOptimize](../table-properties/DeltaConfigs.md#AUTO_OPTIMIZE) table property
1. [delta.autoOptimize.autoCompact](../table-properties/DeltaConfigs.md#AUTO_COMPACT) table property

`getAutoCompactType` defaults to `false` (disabled).

### shouldSkipAutoCompact { #shouldSkipAutoCompact }

```scala
shouldSkipAutoCompact(
  autoCompactTypeOpt: Option[AutoCompactType],
  spark: SparkSession,
  txn: OptimisticTransactionImpl): Boolean
```

`shouldSkipAutoCompact` is enabled (`true`) for the following:

1. The given `autoCompactTypeOpt` is empty (`None`)
1. [isQualifiedForAutoCompact](AutoCompactUtils.md#isQualifiedForAutoCompact) is disabled

## Executing Auto Compaction { #compact }

```scala
compact(
  spark: SparkSession,
  deltaLog: DeltaLog,
  catalogTable: Option[CatalogTable],
  partitionPredicates: Seq[Expression] = Nil,
  opType: String = OP_TYPE,
  maxDeletedRowsRatio: Option[Double] = None): Seq[OptimizeMetrics]
```

`compact` takes the value of the following configuration properties:

* [spark.databricks.delta.autoCompact.maxFileSize](../configuration-properties/index.md#spark.databricks.delta.autoCompact.maxFileSize)
* [spark.databricks.delta.autoCompact.minFileSize](../configuration-properties/index.md#spark.databricks.delta.autoCompact.minFileSize)

`compact`...FIXME
