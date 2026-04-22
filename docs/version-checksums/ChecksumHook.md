---
title: ChecksumHook
---

# ChecksumHook Post-Commit Hook

`ChecksumHook` is a [PostCommitHook](../post-commit-hooks/PostCommitHook.md) registered under the name [Post commit checksum trigger](#name).

## Name

??? note "PostCommitHook"

    ```scala
    name: String
    ```

    `name` is part of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md#name) abstraction.

`name` is **Post commit checksum trigger**.

## Execute Post-Commit Hook { #run }

??? note "PostCommitHook"

    ```scala
    run(
      spark: SparkSession,
      txn: CommittedTransaction): Unit
    ```

    `run` is part of the [PostCommitHook](../post-commit-hooks/PostCommitHook.md#run) abstraction.

`run`...FIXME

### Write Checksum File { #writeChecksum }

```scala
writeChecksum(
  spark: SparkSession,
  txn: CommittedTransaction): Unit
```

`writeChecksum` creates a [WriteChecksum](WriteChecksum.md) (that in turn [writeChecksumFile](RecordChecksum.md#writeChecksumFile)).
