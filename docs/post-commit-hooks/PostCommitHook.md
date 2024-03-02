# PostCommitHook

`PostCommitHook` is an [abstraction](#contract) of [post-commit hooks](#implementations) to be [executed](#run) at the end of a successful [transaction commit](../OptimisticTransactionImpl.md#commit).

## Contract

### Name

```scala
name: String
```

User-friendly name of the hook (for error reporting)

See:

* [AutoCompactBase](../auto-compaction/AutoCompactBase.md#name)
* [CheckpointHook](../checkpoints/CheckpointHook.md#name)

Used when:

* `DeltaErrorsBase` is requested to [postCommitHookFailedException](../DeltaErrors.md#postCommitHookFailedException)
* `OptimisticTransactionImpl` is requested to [runPostCommitHook](../OptimisticTransactionImpl.md#runPostCommitHook) (that failed)

### Executing Post-Commit Hook { #run }

```scala
run(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  committedVersion: Long,
  postCommitSnapshot: Snapshot,
  committedActions: Seq[Action]): Unit
```

??? warning "Procedure"
    `run` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

See:

* [AutoCompactBase](../auto-compaction/AutoCompactBase.md#run)
* [CheckpointHook](../checkpoints/CheckpointHook.md#run)

Used when:

* `OptimisticTransactionImpl` is requested to [runPostCommitHook](../OptimisticTransactionImpl.md#runPostCommitHook) (at [transaction commit](../OptimisticTransactionImpl.md#commit-runPostCommitHooks)).

## Implementations

* [AutoCompactBase](../auto-compaction/AutoCompactBase.md)
* [CheckpointHook](../checkpoints/CheckpointHook.md)
* [GenerateSymlinkManifestImpl](GenerateSymlinkManifest.md)
* `IcebergConverterHook`
* `UpdateCatalogBase`
