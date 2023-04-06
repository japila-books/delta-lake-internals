# CheckpointHook

`CheckpointHook` is a [post-commit hook](../post-commit-hooks/PostCommitHook.md) to run a [checkpoint](Checkpoints.md#checkpoint).

## Name

??? note "PostCommitHook"

    ```scala
    name: String
    ```

    `name` is part of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md#name) abstraction.

`name` is the following:

```text
Post commit checkpoint trigger
```

## Executing Post-Commit Hook { #run }

??? note "PostCommitHook"

    ```scala
    run(
      spark: SparkSession,
      txn: OptimisticTransactionImpl,
      committedVersion: Long,
      postCommitSnapshot: Snapshot,
      committedActions: Seq[Action]): Unit
    ```

    `run` is part of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md#run) abstraction.

??? note "Noop when `needsCheckpoint` flag disabled"
    `run` does nothing when [needsCheckpoint](../OptimisticTransactionImpl.md#needsCheckpoint) flag of the given [OptimisticTransactionImpl](../OptimisticTransactionImpl.md) is disabled.

`run` [ensureLogDirectoryExist](../DeltaLog.md#ensureLogDirectoryExist).

`run` requests the [DeltaLog](../OptimisticTransactionImpl.md#deltaLog) for the [state snapshot](../SnapshotManagement.md#getSnapshotAt) (for the given `committedVersion`) to [checkpoint](Checkpoints.md#checkpoint).
