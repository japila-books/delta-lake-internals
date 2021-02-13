# OptimisticTransactionImpl

`OptimisticTransactionImpl` is an [extension](#contract) of the [TransactionalWrite](TransactionalWrite.md) abstraction for [optimistic transactions](#implementations) that can modify a [delta table](#deltaLog) (at a given [version](#snapshot)) and can be [committed](#commit) eventually.

In other words, `OptimisticTransactionImpl` is a set of [actions](Action.md) as part of an [Operation](Operation.md) that changes the state of a [delta table](#deltaLog) transactionally.

## Contract

### <span id="clock"> Clock

```scala
clock: Clock
```

### <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md) (of a delta table) that this transaction is changing

`deltaLog` is part of the [TransactionalWrite](TransactionalWrite.md#deltaLog) abstraction and seems to change it to `val` (from `def`).

### <span id="snapshot"> Snapshot

```scala
snapshot: Snapshot
```

[Snapshot](Snapshot.md) (of the [delta table](#deltaLog)) that this transaction is changing

`snapshot` is part of the [TransactionalWrite](TransactionalWrite.md#deltaLog) contract and seems to change it to `val` (from `def`).

## Implementations

* [OptimisticTransaction](OptimisticTransaction.md)

## <span id="readVersion"> Table Version at Reading Time

```scala
readVersion: Long
```

`readVersion` requests the [Snapshot](#snapshot) for the [version](Snapshot.md#version).

`readVersion` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](#updateMetadata) and [commit](#commit)
* [AlterDeltaTableCommand](commands/AlterDeltaTableCommand.md), [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md), [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md) commands are executed
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge)
* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write)
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)

## <span id="commit"> Transactional Commit

```scala
commit(
  actions: Seq[Action],
  op: DeltaOperations.Operation): Long
```

`commit` commits the transaction (with the [Action](Action.md)s and a given [Operation](Operation.md))

### <span id="commit-usage"> Usage

`commit` is used when:

* `DeltaLog` is requested to [upgrade the protocol](DeltaLog.md#upgradeProtocol)
* ALTER delta table commands ([AlterTableSetPropertiesDeltaCommand](commands/AlterTableSetPropertiesDeltaCommand.md), [AlterTableUnsetPropertiesDeltaCommand](commands/AlterTableUnsetPropertiesDeltaCommand.md), [AlterTableAddColumnsDeltaCommand](commands/AlterTableAddColumnsDeltaCommand.md), [AlterTableChangeColumnDeltaCommand](commands/AlterTableChangeColumnDeltaCommand.md), [AlterTableReplaceColumnsDeltaCommand](commands/AlterTableReplaceColumnsDeltaCommand.md), [AlterTableAddConstraintDeltaCommand](commands/AlterTableAddConstraintDeltaCommand.md), [AlterTableDropConstraintDeltaCommand](commands/AlterTableDropConstraintDeltaCommand.md)) are executed
* [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) command is executed
* [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md) command is executed
* [DeleteCommand](commands/DeleteCommand.md) command is executed
* [MergeIntoCommand](commands/MergeIntoCommand.md) command is executed
* [UpdateCommand](commands/UpdateCommand.md) command is executed
* [WriteIntoDelta](commands/WriteIntoDelta.md) command is executed
* `DeltaSink` is requested to [addBatch](DeltaSink.md#addBatch)

### <span id="commit-prepareCommit"> Preparing Commit

`commit` firstly [prepares a commit](#prepareCommit) (that gives the final actions to commit that may be different from the given [action](Action.md)s).

### <span id="commit-isolationLevelToUse"> Isolation Level

`commit` determines the isolation level for this commit by checking whether any [FileAction](FileAction.md) (in the given [action](Action.md)s) has the [dataChange](FileAction.md#dataChange) flag enabled. With no data changes, commit uses `SnapshotIsolation` else `Serializable`.

### <span id="commit-isBlindAppend"> isBlindAppend

`commit`...FIXME

### <span id="commit-commitInfo"> CommitInfo

`commit`...FIXME

### <span id="commit-registerPostCommitHook"> Registering Post-Commit Hook

`commit` [registers](#registerPostCommitHook) the [GenerateSymlinkManifest](GenerateSymlinkManifest.md) post-commit hook when there is a [FileAction](FileAction.md) among the actions and the [compatibility.symlinkFormatManifest.enabled](DeltaConfigs.md#SYMLINK_FORMAT_MANIFEST_ENABLED) table property is enabled.

### <span id="commit-commitVersion"> Commit Version

`commit` [doCommit](#doCommit) with the next version, the actions, attempt number `0`, and the select isolation level.

`commit` prints out the following INFO message to the logs:

```text
Committed delta #[commitVersion] to [logPath]
```

### <span id="commit-postCommit"> Performing Post-Commit Operations

`commit` [postCommit](#postCommit) (with the version committed and the actions).

### <span id="commit-runPostCommitHooks"> Executing Post-Commit Hooks

In the end, commit [runs post-commit hooks](#runPostCommitHooks) and returns the version of the successful commit.

### <span id="doCommitRetryIteratively"> doCommitRetryIteratively

```scala
doCommitRetryIteratively(
  attemptVersion: Long,
  actions: Seq[Action],
  isolationLevel: IsolationLevel): Long
```

`doCommitRetryIteratively`...FIXME

### <span id="checkForConflicts"> checkForConflicts

```scala
checkForConflicts(
  checkVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int,
  commitIsolationLevel: IsolationLevel): Long
```

`checkForConflicts`...FIXME

### <span id="getNextAttemptVersion"> getNextAttemptVersion

```scala
getNextAttemptVersion(
  previousAttemptVersion: Long): Long
```

`getNextAttemptVersion`...FIXME

### <span id="getPrettyPartitionMessage"> getPrettyPartitionMessage

```scala
getPrettyPartitionMessage(
  partitionValues: Map[String, String]): String
```

`getPrettyPartitionMessage`...FIXME

### <span id="getOperationMetrics"> getOperationMetrics

```scala
getOperationMetrics(
  op: Operation): Option[Map[String, String]]
```

`getOperationMetrics`...FIXME

### <span id="postCommit"> postCommit

```scala
postCommit(
  commitVersion: Long,
  commitActions: Seq[Action]): Unit
```

`postCommit`...FIXME

### <span id="prepareCommit"> prepareCommit

```scala
prepareCommit(
  actions: Seq[Action],
  op: DeltaOperations.Operation): Seq[Action]
```

`prepareCommit` adds the [newMetadata](#newMetadata) action (if available) to the given [action](Action.md)s.

`prepareCommit` [verifyNewMetadata](#verifyNewMetadata) if there was one.

`prepareCommit`...FIXME

`prepareCommit` requests the [DeltaLog](#deltaLog) to [protocolWrite](DeltaLog.md#protocolWrite).

`prepareCommit`...FIXME

#### <span id="prepareCommit-AssertionError"> Multiple Metadata Changes Not Allowed

`prepareCommit` throws an `AssertionError` when there are multiple metadata changes in the transaction (by means of [Metadata](Action.md#Metadata) actions):

```text
Cannot change the metadata more than once in a transaction.
```

#### <span id="prepareCommit-AssertionError"> Committing Transaction Allowed Once Only

prepareCommit throws an `AssertionError` when the [committed](#committed) internal flag is enabled:

```text
Transaction already committed.
```

### <span id="registerPostCommitHook"> Registering Post-Commit Hook

```scala
registerPostCommitHook(
  hook: PostCommitHook): Unit
```

`registerPostCommitHook` registers (_adds_) the given [PostCommitHook](PostCommitHook.md) to the [postCommitHooks](#postCommitHooks) internal registry.

### <span id="runPostCommitHooks"> runPostCommitHooks

```scala
runPostCommitHooks(
  version: Long,
  committedActions: Seq[Action]): Unit
```

`runPostCommitHooks` simply [runs](PostCommitHook.md#run) every [post-commit hook](PostCommitHook.md) registered (in the [postCommitHooks](#postCommitHooks) internal registry).

`runPostCommitHooks` [clears the active transaction](OptimisticTransaction.md#clearActive) (making all follow-up operations non-transactional).

!!! NOTE
    Hooks may create new transactions.

#### <span id="runPostCommitHooks-non-fatal-exceptions"> Handling Non-Fatal Exceptions

For non-fatal exceptions, `runPostCommitHooks` prints out the following ERROR message to the logs, records the delta event, and requests the post-commit hook to [handle the error](PostCommitHook.md#handleError).

```text
Error when executing post-commit hook [name] for commit [version]
```

#### <span id="runPostCommitHooks-AssertionError"> AssertionError

`runPostCommitHooks` throws an `AssertionError` when [committed](#committed) flag is disabled:

```text
Can't call post commit hooks before committing
```

## <span id="commitInfo"> CommitInfo

`OptimisticTransactionImpl` creates a [CommitInfo](CommitInfo.md) when requested to [commit](#commit) with [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#commitInfo.enabled) configuration enabled.

`OptimisticTransactionImpl` uses the `CommitInfo` to `recordDeltaEvent` (as a `CommitStats`).

## <span id="doCommit"> Attempting Commit

```scala
doCommit(
  attemptVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int,
  isolationLevel: IsolationLevel): Long
```

`doCommit` returns the given `attemptVersion` as the commit version if successful or [checkAndRetry](#checkAndRetry).

`doCommit` is used when:

* OptimisticTransactionImpl is requested to [commit](#commit) (and [checkAndRetry](#checkAndRetry)).

---

Internally, `doCommit` prints out the following DEBUG message to the logs:

```text
Attempting to commit version [attemptVersion] with [n] actions with [isolationLevel] isolation level
```

### <span id="doCommit-write"> Writing Out

`doCommit` requests the [DeltaLog](#deltaLog) for the [LogStore](DeltaLog.md#store) to [write out](LogStore.md#write) the given [action](Action.md)s to a [delta file](FileNames.md#deltaFile) in the [log directory](DeltaLog.md#logPath) with the `attemptVersion` version, e.g.

```text
00000000000000000001.json
```

`doCommit` writes the [action](Action.md)s out in [JSON format](Action.md#json).

!!! NOTE
    [LogStores](LogStore.md) must throw a `java.nio.file.FileAlreadyExistsException` exception if the delta file already exists. Any `FileAlreadyExistsExceptions` are caught by [doCommit](#doCommit-FileAlreadyExistsException) itself to [checkAndRetry](#checkAndRetry).

### <span id="doCommit-postCommitSnapshot"> Post-Commit Snapshot

`doCommit` requests the [DeltaLog](#deltaLog) to [update](DeltaLog.md#update).

### <span id="doCommit-IllegalStateException"> IllegalStateException

`doCommit` throws an `IllegalStateException` when the version of the snapshot after update is smaller than the given `attemptVersion` version.

```text
The committed version is [attemptVersion] but the current version is [version].
```

### <span id="doCommit-stats"> CommitStats

`doCommit` records a new `CommitStats` and returns the given `attemptVersion` as the commit version.

### <span id="doCommit-FileAlreadyExistsException"> FileAlreadyExistsExceptions

`doCommit` catches `FileAlreadyExistsExceptions` and [checkAndRetry](#checkAndRetry).

## <span id="checkAndRetry"> Retrying Commit

```scala
checkAndRetry(
  checkVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int): Long
```

`checkAndRetry`...FIXME

`checkAndRetry` is used when OptimisticTransactionImpl is requested to [commit](#commit) (and [attempts a commit](#doCommit) that failed with an `FileAlreadyExistsException`).

## <span id="verifyNewMetadata"> verifyNewMetadata

```scala
verifyNewMetadata(
  metadata: Metadata): Unit
```

`verifyNewMetadata`...FIXME

`verifyNewMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [prepareCommit](#prepareCommit) and [updateMetadata](#updateMetadata)

## <span id="withGlobalConfigDefaults"> withGlobalConfigDefaults

```scala
withGlobalConfigDefaults(
  metadata: Metadata): Metadata
```

`withGlobalConfigDefaults`...FIXME

`withGlobalConfigDefaults` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](#updateMetadata) and [updateMetadataForNewTable](#updateMetadataForNewTable)

## <span id="txnVersion"> Looking Up Transaction Version For Given (Streaming Query) ID

```scala
txnVersion(
  id: String): Long
```

`txnVersion` simply registers (_adds_) the given ID in the [readTxn](#readTxn) internal registry.

In the end, `txnVersion` requests the [Snapshot](#snapshot) for the [transaction version for the given ID](Snapshot.md#transactions) or `-1`.

`txnVersion` is used when:

* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)

## <span id="getUserMetadata"> User-Defined Metadata

```scala
getUserMetadata(
  op: Operation): Option[String]
```

`getUserMetadata` returns the Operation.md#userMetadata[userMetadata] of the given Operation.md[] (if defined) or the value of DeltaSQLConf.md#DELTA_USER_METADATA[spark.databricks.delta.commitInfo.userMetadata] configuration property.

`getUserMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [commit](#commit) (and [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#DELTA_COMMIT_INFO_ENABLED) configuration property is enabled)
* [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) is executed (and in turn requests `DeltaCommand` to [commitLarge](commands/DeltaCommand.md#commitLarge))

## Internal Registries

### <span id="postCommitHooks"> Post-Commit Hooks

```scala
postCommitHooks: ArrayBuffer[PostCommitHook]
```

`OptimisticTransactionImpl` manages [PostCommitHook](PostCommitHook.md)s that will be [executed](#runPostCommitHooks) right after a [commit](#commit) is successful.

Post-commit hooks can be [registered](#registerPostCommitHook), but only the [GenerateSymlinkManifest](GenerateSymlinkManifest.md) post-commit hook is supported.

### <span id="newMetadata"> newMetadata

```scala
newMetadata: Option[Metadata]
```

`OptimisticTransactionImpl` uses the `newMetadata` internal registry for a new [Metadata](Metadata.md) that should be committed with this transaction.

`newMetadata` is initially undefined (`None`). It can be [updated](#updateMetadata) only once and before the transaction [writes out any files](TransactionalWrite.md#hasWritten).

`newMetadata` is used when [prepareCommit](#prepareCommit) and [doCommit](#doCommit) (for statistics).

`newMetadata` is available using [metadata](#metadata) method.

### <span id="readPredicates"> readPredicates

```scala
readPredicates: ArrayBuffer[Expression]
```

`readPredicates` holds predicate expressions for partitions the transaction is modifying.

`readPredicates` is added a new predicate expression when [filterFiles](#filterFiles) and [readWholeTable](#readWholeTable).

`readPredicates` is used when [checkAndRetry](#checkAndRetry).

## Internal Properties

### <span id="committed"> committed

Controls whether the transaction has been [committed](#commit) or not (and prevents [prepareCommit](#prepareCommit) from being executed again)

Default: `false`

Enabled in [postCommit](#postCommit)

### <span id="dependsOnFiles"> dependsOnFiles

Flag that...FIXME

Default: `false`

Enabled (set to `true`) in [filterFiles](#filterFiles) and [readWholeTable](#readWholeTable)

Used in [commit](#commit) and [checkAndRetry](#checkAndRetry)

### <span id="readFiles"> readFiles

### <span id="readTxn"> readTxn

Streaming query IDs that have been seen by this transaction

A new queryId is added when `OptimisticTransactionImpl` is requested for [txnVersion](#txnVersion)

Used when `OptimisticTransactionImpl` is requested to [checkAndRetry](#checkAndRetry) (to fail with a `ConcurrentTransactionException` for idempotent transactions that have conflicted)

### <span id="snapshotMetadata"> snapshotMetadata

[Metadata](Metadata.md) of the [Snapshot](#snapshot)

## <span id="readWholeTable"> readWholeTable

```scala
readWholeTable(): Unit
```

`readWholeTable` simply adds `True` literal to the [readPredicates](#readPredicates) internal registry.

`readWholeTable` is used when:

* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch) (and the batch reads the same Delta table as this sink is going to write to)

## <span id="updateMetadataForNewTable"> updateMetadataForNewTable

```scala
updateMetadataForNewTable(
  metadata: Metadata): Unit
```

`updateMetadataForNewTable`...FIXME

`updateMetadataForNewTable` is used when:

* [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) and [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md) are executed

## <span id="metadata"> Metadata

```scala
metadata: Metadata
```

`metadata` is part of the [TransactionalWrite](TransactionalWrite.md#metadata) abstraction.

`metadata` is either the [newMetadata](#newMetadata) (if defined) or the [snapshotMetadata](#snapshotMetadata).

## <span id="updateMetadata"> Updating Metadata

```scala
updateMetadata(
  metadata: Metadata): Unit
```

`updateMetadata` updates the [newMetadata](#newMetadata) internal property based on the [readVersion](#readVersion):

* For `-1`, `updateMetadata` updates the [configuration](Metadata.md#configuration) of the given metadata with a [new metadata](DeltaConfigs.md#mergeGlobalConfigs) based on the `SQLConf` (of the active `SparkSession`), the [configuration](Metadata.md#configuration) of the given metadata and a new [Protocol](Protocol.md)

* For other versions, `updateMetadata` leaves the given [Metadata](Action.md#Metadata) unchanged

`updateMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataForNewTable](#updateMetadataForNewTable)
* [AlterTableSetPropertiesDeltaCommand](commands/AlterTableSetPropertiesDeltaCommand.md), [AlterTableUnsetPropertiesDeltaCommand](commands/AlterTableUnsetPropertiesDeltaCommand.md), [AlterTableAddColumnsDeltaCommand](commands/AlterTableAddColumnsDeltaCommand.md), [AlterTableChangeColumnDeltaCommand](commands/AlterTableChangeColumnDeltaCommand.md), [AlterTableReplaceColumnsDeltaCommand](commands/AlterTableReplaceColumnsDeltaCommand.md) are executed
* [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) is executed

* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)

### <span id="updateMetadata-AssertionError-hasWritten"> AssertionError

`updateMetadata` throws an `AssertionError` when the [hasWritten](TransactionalWrite.md#hasWritten) flag is enabled:

```text
Cannot update the metadata in a transaction that has already written data.
```

### <span id="updateMetadata-AssertionError-newMetadata"> AssertionError

`updateMetadata` throws an `AssertionError` when the [newMetadata](#newMetadata) is not empty:

```text
Cannot change the metadata more than once in a transaction.
```

## <span id="filterFiles"> Files To Scan Matching Given Predicates

```scala
filterFiles(): Seq[AddFile] // Uses `true` literal to mean that all files match
filterFiles(
  filters: Seq[Expression]): Seq[AddFile]
```

`filterFiles` gives the [files](AddFile.md) to scan based on the given predicates (filter expressions).

Internally, `filterFiles` requests the [Snapshot](#snapshot) for the [filesForScan](PartitionFiltering.md#filesForScan) (for no projection attributes and the given filters).

`filterFiles` finds the [partition predicates](DeltaTableUtils.md#isPredicatePartitionColumnsOnly) among the given filters (and the [partition columns](Metadata.md#partitionColumns) of the [Metadata](#metadata)).

`filterFiles` registers (_adds_) the partition predicates (in the [readPredicates](#readPredicates) internal registry) and the files to scan (in the [readFiles](#readFiles) internal registry).

`filterFiles` is used when:

* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write)
* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch) (with `Complete` output mode)
* [DeleteCommand](commands/DeleteCommand.md), [MergeIntoCommand](commands/MergeIntoCommand.md) and [UpdateCommand](commands/UpdateCommand.md) are executed
* [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md) is executed
