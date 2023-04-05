# PostCommitHook

`PostCommitHook` is an [abstraction](#contract) of [post-commit hooks](#implementations) that can be [executed](#run) (at the end of [transaction commit](OptimisticTransactionImpl.md#commit)).

## Contract

### Name { #name }

```scala
name: String
```

User-friendly name of the hook (for error reporting)

See:

* [CheckpointHook](checkpoints/CheckpointHook.md#name)

Used when:

* `DeltaErrorsBase` is requested to [postCommitHookFailedException](DeltaErrors.md#postCommitHookFailedException)
* `OptimisticTransactionImpl` is requested to [runPostCommitHook](OptimisticTransactionImpl.md#runPostCommitHook) (that failed)

### Executing Post-Commit Hook { #run }

```scala
run(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  committedVersion: Long,
  postCommitSnapshot: Snapshot,
  committedActions: Seq[Action]): Unit
```

See:

* [CheckpointHook](checkpoints/CheckpointHook.md#run)

Used when:

* `OptimisticTransactionImpl` is requested to [runPostCommitHook](OptimisticTransactionImpl.md#runPostCommitHook) (at [transaction commit](OptimisticTransactionImpl.md#commit-runPostCommitHooks)).

## Implementations

* [CheckpointHook](checkpoints/CheckpointHook.md)
* [GenerateSymlinkManifestImpl](GenerateSymlinkManifest.md)
