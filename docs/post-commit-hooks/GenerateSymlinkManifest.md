---
title: GenerateSymlinkManifest
---

# GenerateSymlinkManifest (GenerateSymlinkManifestImpl)

`GenerateSymlinkManifest` is a [post-commit hook](PostCommitHook.md) to generate [incremental](#generateIncrementalManifest) and [full](#generateFullManifest) Hive-style manifests for delta tables.

`GenerateSymlinkManifest` is registered when `OptimisticTransactionImpl` is requested to [commit](../OptimisticTransaction.md#commit) (with [delta.compatibility.symlinkFormatManifest.enabled](../table-properties/DeltaConfigs.md#SYMLINK_FORMAT_MANIFEST_ENABLED) table property enabled).

## <span id="run"> Executing Post-Commit Hook

```scala
run(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  committedActions: Seq[Action]): Unit
```

`run` is part of the [PostCommitHook](PostCommitHook.md#run) abstraction.

`run` [generates an incremental manifest](#generateIncrementalManifest) for the committed [action](../Action.md)s (the [deltaLog](../OptimisticTransaction.md#deltaLog) and [snapshot](../OptimisticTransaction.md#snapshot) are from the `OptimisticTransactionImpl`).

## <span id="generateIncrementalManifest"> generateIncrementalManifest

```scala
generateIncrementalManifest(
  spark: SparkSession,
  deltaLog: DeltaLog,
  txnReadSnapshot: Snapshot,
  actions: Seq[Action]): Unit
```

`generateIncrementalManifest`...FIXME

## <span id="generateFullManifest"> generateFullManifest

```scala
generateFullManifest(
  spark: SparkSession,
  deltaLog: DeltaLog): Unit
```

`generateFullManifest`...FIXME

---

`generateFullManifest` is used when:

* `GenerateSymlinkManifestImpl` is requested to [generateIncrementalManifest](#generateIncrementalManifest)
* [DeltaGenerateCommand](../commands/generate/DeltaGenerateCommand.md) is executed (with `symlink_format_manifest` mode)
