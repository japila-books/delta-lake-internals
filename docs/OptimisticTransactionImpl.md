# OptimisticTransactionImpl

`OptimisticTransactionImpl` is an [extension](#contract) of the [TransactionalWrite](TransactionalWrite.md) abstraction for [optimistic transactions](#implementations) that can modify a [delta table](#deltaLog) (at a given [version](#snapshot)) and can be [committed](#commit) eventually.

In other words, `OptimisticTransactionImpl` is a set of [actions](Action.md) as part of an [Operation](Operation.md) that changes the state of a [delta table](#deltaLog) transactionally.

## Contract

### Clock { #clock }

```scala
clock: Clock
```

### DeltaLog { #deltaLog }

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md) (of a delta table) this transaction commits changes to

`deltaLog` is part of the [TransactionalWrite](TransactionalWrite.md#deltaLog) abstraction and seems to change it to `val` (from `def`).

### Snapshot { #snapshot }

```scala
snapshot: Snapshot
```

[Snapshot](Snapshot.md) (of the [delta table](#deltaLog)) this transaction commits changes to

`snapshot` is part of the [TransactionalWrite](TransactionalWrite.md#deltaLog) contract and seems to change it to `val` (from `def`).

## Implementations

* [OptimisticTransaction](OptimisticTransaction.md)

## Table Version at Reading Time { #readVersion }

```scala
readVersion: Long
```

`readVersion` requests the [Snapshot](#snapshot) for the [version](Snapshot.md#version).

`readVersion` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](#updateMetadata) and [commit](#commit)
* [AlterDeltaTableCommand](commands/alter/AlterDeltaTableCommand.md), [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md), [CreateDeltaTableCommand](commands/create-table/CreateDeltaTableCommand.md) commands are executed
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge)
* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write)
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)

## Transactional Commit { #commit }

```scala
commit(
  actions: Seq[Action],
  op: DeltaOperations.Operation): Long
```

`commit` attempts to commit the given [Action](Action.md)s (as part of the [Operation](Operation.md)) and gives the commit version.

### Usage { #commit-usage }

`commit` is used when:

* [ALTER TABLE](commands/alter/index.md) commands are executed
    * [AlterTableAddColumnsDeltaCommand](commands/alter/AlterTableAddColumnsDeltaCommand.md)
    * [AlterTableAddConstraintDeltaCommand](commands/alter/AlterTableAddConstraintDeltaCommand.md)
    * [AlterTableChangeColumnDeltaCommand](commands/alter/AlterTableChangeColumnDeltaCommand.md)
    * [AlterTableDropColumnsDeltaCommand](commands/alter/AlterTableDropColumnsDeltaCommand.md)
    * [AlterTableDropConstraintDeltaCommand](commands/alter/AlterTableDropConstraintDeltaCommand.md)
    * [AlterTableReplaceColumnsDeltaCommand](commands/alter/AlterTableReplaceColumnsDeltaCommand.md)
    * [AlterTableSetPropertiesDeltaCommand](commands/alter/AlterTableSetPropertiesDeltaCommand.md)
    * [AlterTableUnsetPropertiesDeltaCommand](commands/alter/AlterTableUnsetPropertiesDeltaCommand.md)
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed
* [CreateDeltaTableCommand](commands/create-table/CreateDeltaTableCommand.md) is executed
* [DeleteCommand](commands/delete/DeleteCommand.md) is executed
* `DeltaLog` is requested to [upgrade the protocol](DeltaLog.md#upgradeProtocol)
* `DeltaSink` is requested to [add a streaming micro-batch](spark-connector/DeltaSink.md#addBatch)
* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed
* [OptimizeTableCommand](commands/optimize/OptimizeTableCommand.md) is executed (and requests `OptimizeExecutor` to [commitAndRetry](commands/optimize/OptimizeExecutor.md#commitAndRetry))
* `StatisticsCollection` is requested to [recompute](StatisticsCollection.md#recompute)
* [UpdateCommand](commands/update/UpdateCommand.md) is executed
* [WriteIntoDelta](commands/WriteIntoDelta.md) is executed

### <span id="commit-prepareCommit"><span id="commit-finalActions"> Preparing Commit

`commit` then [prepares a commit](#prepareCommit) (that gives the final actions to commit that may be different from the given [action](Action.md)s).

### <span id="commit-isolationLevelToUse"> Isolation Level

`commit` determines the [isolation level](IsolationLevel.md) based on [FileAction](FileAction.md)s (in the given [action](Action.md)s) and their [dataChange](FileAction.md#dataChange) flag.

With all [action](FileAction.md)s with [dataChange](FileAction.md#dataChange) flag disabled (`false`), `commit` assumes no data changed and chooses [SnapshotIsolation](IsolationLevel.md#SnapshotIsolation) else [Serializable](IsolationLevel.md#Serializable).

### <span id="commit-isBlindAppend"> Blind Append

`commit` is considered **blind append** when the following all hold:

1. There are only [AddFile](AddFile.md)s among [FileAction](FileAction.md)s in the [actions](#commit-finalActions) (_onlyAddFiles_)
1. It does not depend on files, i.e. the [readPredicates](#readPredicates) and [readFiles](#readFiles) are empty (_dependsOnFiles_)

### <span id="commit-commitInfo"> CommitInfo

`commit`...FIXME

### <span id="commit-registerPostCommitHook"> Registering Post-Commit Hook

`commit` [registers](#registerPostCommitHook) the [GenerateSymlinkManifest](post-commit-hooks/GenerateSymlinkManifest.md) post-commit hook when there is a [FileAction](FileAction.md) among the actions and the [compatibility.symlinkFormatManifest.enabled](table-properties/DeltaConfigs.md#SYMLINK_FORMAT_MANIFEST_ENABLED) table property is enabled.

### <span id="commit-doCommitRetryIteratively"><span id="commit-commitVersion"><span id="commit-needsCheckpoint"> doCommitRetryIteratively

`commit` [doCommitRetryIteratively](#doCommitRetryIteratively).

`commit` prints out the following INFO message to the logs:

```text
Committed delta #[commitVersion] to [logPath]
```

### <span id="commit-postCommit"> Performing Post-Commit Operations

`commit` [postCommit](#postCommit) (with the version committed and the `needsCheckpoint` flag).

### <span id="commit-runPostCommitHooks"> Executing Post-Commit Hooks

In the end, commit [runs post-commit hooks](#runPostCommitHooks) and returns the version of the successful commit.

### <span id="doCommitRetryIteratively"> doCommitRetryIteratively

```scala
doCommitRetryIteratively(
  attemptVersion: Long,
  currentTransactionInfo: CurrentTransactionInfo,
  isolationLevel: IsolationLevel): (Long, CurrentTransactionInfo, Boolean)
```

`doCommitRetryIteratively` [acquires a lock on the delta table if enabled](#lockCommitIfEnabled) for the commit.

`doCommitRetryIteratively` uses `attemptNumber` internal counter to track the number of attempts. In case of a `FileAlreadyExistsException`, `doCommitRetryIteratively` increments the `attemptNumber` and tries over.

In the end, `doCommitRetryIteratively` returns a tuple with the following:

1. Commit version (from the given `attemptVersion` inclusive up to [spark.databricks.delta.maxCommitAttempts](configuration-properties/DeltaSQLConf.md#DELTA_MAX_RETRY_COMMIT_ATTEMPTS))
1. `CurrentTransactionInfo`
1. Whether the commit needs checkpoint or not (`needsCheckpoint`)

---

Firstly, `doCommitRetryIteratively` does the first attempt at [commit](#doCommit). If successful, the commit is done.

If there is a retry, `doCommitRetryIteratively` [checkForConflicts](#checkForConflicts) followed by another attempt at [commit](#doCommit).

If the number of commit attempts (`attemptNumber`) is above the [spark.databricks.delta.maxCommitAttempts](configuration-properties/DeltaSQLConf.md#DELTA_MAX_RETRY_COMMIT_ATTEMPTS) configuration property, `doCommitRetryIteratively` throws a [DeltaIllegalStateException](DeltaErrors.md#maxCommitRetriesExceededException):

```text
This commit has failed as it has been tried <numAttempts> times but did not succeed.
This can be caused by the Delta table being committed continuously by many concurrent commits.

Commit started at version: [attemptNumber]
Commit failed at version: [attemptVersion]
Number of actions attempted to commit: [numActions]
Total time spent attempting this commit: [timeSpent] ms
```

### <span id="checkForConflicts"> Checking Logical Conflicts with Concurrent Updates

```scala
checkForConflicts(
  checkVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int,
  commitIsolationLevel: IsolationLevel): Long
```

`checkForConflicts` checks for logical conflicts (of the given `actions`) with concurrent updates (actions of the commits since the transaction has started).

`checkForConflicts` gives the [next possible commit version](#getNextAttemptVersion) unless the following happened between the time of read (`checkVersion`) and the time of this commit attempt:

1. Client is up to date with the [table protocol](Protocol.md) for reading and writing (and hence allowed to access the table)
1. [Protocol](Protocol.md) version has changed
1. [Metadata](Metadata.md) has changed
1. [AddFile](AddFile.md)s have been added that the txn should have read based on the given [IsolationLevel](IsolationLevel.md) (_Concurrent Append_)
1. [AddFile](AddFile.md)s that the txn read have been deleted (_Concurrent Delete_)
1. Files have been deleted by the txn and since the time of read (_Concurrent Delete_)
1. Idempotent [transactions](SetTransaction.md) have conflicted (_Multiple Streaming Queries_ with the same checkpoint location)

`checkForConflicts` takes the [next possible commit version](#getNextAttemptVersion).

For every commit since the time of read (`checkVersion`) and this commit attempt, `checkForConflicts` does the following:

* FIXME

* Prints out the following INFO message to the logs:

    ```text
    Completed checking for conflicts Version: [version] Attempt: [attemptNumber] Time: [totalCheckAndRetryTime] ms
    ```

In the end, `checkForConflicts` prints out the following INFO message to the logs:

```text
No logical conflicts with deltas [[checkVersion], [nextAttemptVersion]), retrying.
```

### <span id="getPrettyPartitionMessage"> getPrettyPartitionMessage

```scala
getPrettyPartitionMessage(
  partitionValues: Map[String, String]): String
```

`getPrettyPartitionMessage`...FIXME

### <span id="postCommit"> postCommit

```scala
postCommit(
  commitVersion: Long,
  needsCheckpoint: Boolean): Unit
```

`postCommit` turns the [committed](#committed) flag on.

With the given `needsCheckpoint` enabled (that comes indirectly from [doCommit](#doCommit)), `postCommit` requests the [DeltaLog](#deltaLog) for the [Snapshot](SnapshotManagement.md#getSnapshotAt) at the given `commitVersion` followed by [checkpointing](checkpoints/Checkpoints.md#checkpoint).

## <span id="prepareCommit"> prepareCommit

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

### <span id="performCdcColumnMappingCheck"> performCdcColumnMappingCheck

```scala
performCdcColumnMappingCheck(
  actions: Seq[Action],
  op: DeltaOperations.Operation): Unit
```

`performCdcColumnMappingCheck`...FIXME

### runPostCommitHooks { #runPostCommitHooks }

```scala
runPostCommitHooks(
  version: Long,
  committedActions: Seq[Action]): Unit
```

`runPostCommitHooks` simply [runs](post-commit-hooks/PostCommitHook.md#run) every [post-commit hook](post-commit-hooks/PostCommitHook.md) registered (in the [postCommitHooks](#postCommitHooks) internal registry).

`runPostCommitHooks` [clears the active transaction](OptimisticTransaction.md#clearActive) (making all follow-up operations non-transactional).

!!! NOTE
    Hooks may create new transactions.

#### <span id="runPostCommitHooks-non-fatal-exceptions"> Handling Non-Fatal Exceptions

For non-fatal exceptions, `runPostCommitHooks` prints out the following ERROR message to the logs, records the delta event, and requests the post-commit hook to [handle the error](post-commit-hooks/PostCommitHook.md#handleError).

```text
Error when executing post-commit hook [name] for commit [version]
```

#### <span id="runPostCommitHooks-AssertionError"> AssertionError

`runPostCommitHooks` throws an `AssertionError` when [committed](#committed) flag is disabled:

```text
Can't call post commit hooks before committing
```

### <span id="getNextAttemptVersion"> Next Possible Commit Version

```scala
getNextAttemptVersion(
  previousAttemptVersion: Long): Long
```

`getNextAttemptVersion` requests the [DeltaLog](#deltaLog) to [update](DeltaLog.md#update) (and give the latest [state snapshot](Snapshot.md) of the delta table).

In the end, `getNextAttemptVersion` requests the `Snapshot` for the [version](Snapshot.md#version) and increments it.

!!! note
    The input `previousAttemptVersion` argument is not used.

### <span id="getOperationMetrics"> Operation Metrics

```scala
getOperationMetrics(
  op: Operation): Option[Map[String, String]]
```

`getOperationMetrics` gives the [metrics](SQLMetricsReporting.md#getMetricsForOperation) of the given [Operation](Operation.md) when the [spark.databricks.delta.history.metricsEnabled](configuration-properties/DeltaSQLConf.md#DELTA_HISTORY_METRICS_ENABLED) configuration property is enabled. Otherwise, `getOperationMetrics` gives `None`.

## <span id="commitInfo"> CommitInfo

`OptimisticTransactionImpl` creates a [CommitInfo](CommitInfo.md) when requested to [commit](#commit) with [spark.databricks.delta.commitInfo.enabled](configuration-properties/DeltaSQLConf.md#commitInfo.enabled) configuration enabled.

`OptimisticTransactionImpl` uses the `CommitInfo` to `recordDeltaEvent` (as a `CommitStats`).

## Attempting Commit { #doCommit }

```scala
doCommit(
  attemptVersion: Long,
  currentTransactionInfo: CurrentTransactionInfo,
  attemptNumber: Int,
  isolationLevel: IsolationLevel): Boolean
```

`doCommit` returns whether or not this commit (attempt) [should trigger checkpointing](#doCommit-needsCheckpoint).

`doCommit` is used when:

* `OptimisticTransactionImpl` is requested to [doCommitRetryIteratively](#doCommitRetryIteratively)

---

`doCommit` requests the given `CurrentTransactionInfo` for the final actions to commit ([Action](Action.md)s).

`doCommit` prints out the following DEBUG message to the logs:

```text
Attempting to commit version [attemptVersion] with [n] actions with [isolationLevel] isolation level
```

### <span id="doCommit-write"> Writing Out

`doCommit` requests the [DeltaLog](#deltaLog) for the [LogStore](DeltaLog.md#store) to [write out](storage/LogStore.md#write) the actions to a [delta file](FileNames.md#deltaFile) in the [log directory](DeltaLog.md#logPath) with the `attemptVersion` version, e.g.

```text
00000000000000000001.json
```

`doCommit` writes the actions out in [JSON format](Action.md#json).

!!! NOTE
    [LogStores](storage/LogStore.md) must throw a `java.nio.file.FileAlreadyExistsException` exception if the delta file already exists. Any `FileAlreadyExistsExceptions` are caught by [doCommit](#doCommit-FileAlreadyExistsException) itself to [checkAndRetry](#checkAndRetry).

### <span id="doCommit-lastCommitVersionInSession"> lastCommitVersionInSession

`doCommit` sets the [spark.databricks.delta.lastCommitVersionInSession](configuration-properties/DeltaSQLConf.md#DELTA_LAST_COMMIT_VERSION_IN_SESSION) configuration property to the given `attemptVersion`.

### <span id="doCommit-postCommitSnapshot"> Post-Commit Snapshot

`doCommit` requests the [DeltaLog](#deltaLog) to [update](DeltaLog.md#update).

### <span id="doCommit-needsCheckpoint"> Needs Checkpointing

`doCommit` determines whether or not this commit should trigger checkpointing based on the committed version (`attemptVersion`).

A commit triggers checkpointing when the following all hold:

1. The committed version is any version greater than `0`
1. The committed version is a multiple of [delta.checkpointInterval](table-properties/DeltaConfigs.md#CHECKPOINT_INTERVAL) table property

### <span id="doCommit-stats"> CommitStats

`doCommit` records a new `CommitStats` event.

### writeCommitFile { #writeCommitFile }

```scala
writeCommitFile(
  attemptVersion: Long,
  jsonActions: Iterator[String],
  currentTransactionInfo: CurrentTransactionInfo): Option[VersionChecksum]
```

`writeCommitFile`...FIXME

## <span id="checkAndRetry"> Retrying Commit

```scala
checkAndRetry(
  checkVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int): Long
```

`checkAndRetry`...FIXME

`checkAndRetry` is used when OptimisticTransactionImpl is requested to [commit](#commit) (and [attempts a commit](#doCommit) that failed with an `FileAlreadyExistsException`).

## <span id="verifyNewMetadata"> Verifying New Metadata

```scala
verifyNewMetadata(
  metadata: Metadata): Unit
```

`verifyNewMetadata` validates the given [Metadata](Metadata.md) (and throws an exception if incorrect).

`verifyNewMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [prepareCommit](#prepareCommit) and [updateMetadata](#updateMetadata)

---

`verifyNewMetadata` [asserts that there are no column duplicates](SchemaMergingUtils.md#checkColumnNameDuplication) in the [schema](Metadata.md#schema) (of the given [Metadata](Metadata.md)).
`verifyNewMetadata` throws a `DeltaAnalysisException` if there are duplicates.

`verifyNewMetadata` branches off based on the [DeltaColumnMappingMode](Metadata.md#columnMappingMode) (of the given [Metadata](Metadata.md)):

* In [NoMapping](column-mapping/DeltaColumnMappingMode.md#NoMapping) mode, `verifyNewMetadata` [checks](SchemaUtils.md#checkSchemaFieldNames) the [data schema](Metadata.md#dataSchema) and [checks](SchemaUtils.md#checkFieldNames) the [partition columns](Metadata.md#partitionColumns) (of the given [Metadata](Metadata.md)).

    In case of `AnalysisException` and [spark.databricks.delta.partitionColumnValidity.enabled](configuration-properties/DeltaSQLConf.md#DELTA_PARTITION_COLUMN_CHECK_ENABLED) configuration property enabled, `verifyNewMetadata` throws a `DeltaAnalysisException`.

* For the other [DeltaColumnMappingMode](column-mapping/DeltaColumnMappingMode.md#implementations)s, `verifyNewMetadata` [checkColumnIdAndPhysicalNameAssignments](column-mapping/DeltaColumnMappingBase.md#checkColumnIdAndPhysicalNameAssignments) of the [schema](Metadata.md#schema).

`verifyNewMetadata` [validates generated columns](generated-columns/GeneratedColumn.md#validateGeneratedColumns) if [there are any](generated-columns/GeneratedColumn.md#hasGeneratedColumns) (in the [schema](Metadata.md#schema)).

With [spark.databricks.delta.schema.typeCheck.enabled](configuration-properties/DeltaSQLConf.md#DELTA_SCHEMA_TYPE_CHECK) configuration property enabled, `verifyNewMetadata`...FIXME

In the end, `verifyNewMetadata` [checks the protocol requirements](Protocol.md#checkProtocolRequirements) and, in case the protocol has been updated, records it in the [newProtocol](#newProtocol) registry.

## <span id="newProtocol"> newProtocol

```scala
newProtocol: Option[Protocol]
```

`OptimisticTransactionImpl` defines `newProtocol` registry for a new [Protocol](Protocol.md).

`newProtocol` is undefined (`None`) by default.

`newProtocol` is defined when:

* [updateMetadataInternal](#updateMetadataInternal)
* [verifyNewMetadata](#verifyNewMetadata)

`newProtocol` is used for the [protocol](#protocol) and to [prepareCommit](#prepareCommit).

## <span id="withGlobalConfigDefaults"> withGlobalConfigDefaults

```scala
withGlobalConfigDefaults(
  metadata: Metadata): Metadata
```

`withGlobalConfigDefaults`...FIXME

`withGlobalConfigDefaults` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](#updateMetadata) and [updateMetadataForNewTable](#updateMetadataForNewTable)

## <span id="txnVersion"> Looking Up Transaction Version (by Streaming Query ID)

```scala
txnVersion(
  id: String): Long
```

`txnVersion` simply registers (_adds_) the given ID in the [readTxn](#readTxn) internal registry.

In the end, `txnVersion` requests the [Snapshot](#snapshot) for the [transaction version for the given ID](Snapshot.md#transactions) or `-1`.

`txnVersion` is used when:

* `DeltaSink` is requested to [add a streaming micro-batch](spark-connector/DeltaSink.md#addBatch)

## <span id="getUserMetadata"> User-Defined Metadata

```scala
getUserMetadata(
  op: Operation): Option[String]
```

`getUserMetadata` returns the Operation.md#userMetadata[userMetadata] of the given Operation.md[] (if defined) or the value of DeltaSQLConf.md#DELTA_USER_METADATA[spark.databricks.delta.commitInfo.userMetadata] configuration property.

`getUserMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [commit](#commit) (and [spark.databricks.delta.commitInfo.enabled](configuration-properties/DeltaSQLConf.md#DELTA_COMMIT_INFO_ENABLED) configuration property is enabled)
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed (and in turn requests `DeltaCommand` to [commitLarge](commands/DeltaCommand.md#commitLarge))

## Post-Commit Hooks { #postCommitHooks }

```scala
postCommitHooks: ArrayBuffer[PostCommitHook]
```

`OptimisticTransactionImpl` uses `postCommitHooks` internal registry to manage [PostCommitHook](post-commit-hooks/PostCommitHook.md)s to be [executed](#runPostCommitHooks) right after a successful [commit](#commit).

[PostCommitHook](post-commit-hooks/PostCommitHook.md)s can be registered using [registerPostCommitHook](#registerPostCommitHook).

## Blind-Append Transaction { #isBlindAppend }

```scala
var isBlindAppend: Boolean = false
```

`OptimisticTransactionImpl` defines `isBlindAppend` flag to mark this transaction as blind-append.

`isBlindAppend` is disabled (`false`) by default.

`isBlindAppend` can be enabled (`true`) only when this `OptimisticTransactionImpl` is requested to [commitImpl](#commitImpl) and the following all hold:

1. There are [AddFile](AddFile.md)s only in this [transaction](#prepareCommit)
1. This transaction does not depend on files (i.e., the [readPredicates](#readPredicates) and the [readFiles](#readFiles) are all empty)

## commitImpl { #commitImpl }

```scala
commitImpl(
  actions: Seq[Action],
  op: DeltaOperations.Operation,
  canSkipEmptyCommits: Boolean,
  tags: Map[String, String]): Option[Long]
```

`commitImpl`...FIXME

---

`commitImpl` is used when:

* `OptimisticTransactionImpl` is requested to [commit](#commit), [commitIfNeeded](#commitIfNeeded)

## commitIfNeeded { #commitIfNeeded }

```scala
commitIfNeeded(
  actions: Seq[Action],
  op: DeltaOperations.Operation,
  tags: Map[String, String] = Map.empty): Unit
```

??? warning "Procedure"
    `commitIfNeeded` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`commitIfNeeded` [commitImpl](#commitImpl) (with `canSkipEmptyCommits` flag enabled).

---

`commitIfNeeded` is used when:

* [Delete](commands/delete/index.md) command is executed
* [Merge](commands/merge/index.md) command is executed (and [commitAndRecordStats](commands/merge/MergeIntoCommand.md#commitAndRecordStats))
* [Update](commands/update/index.md) command is executed (and [performUpdate](commands/update/UpdateCommand.md#performUpdate))
* [WriteIntoDelta](commands/WriteIntoDelta.md) command is executed

## Internal Registries

### <span id="newMetadata"> newMetadata

```scala
newMetadata: Option[Metadata]
```

`OptimisticTransactionImpl` uses the `newMetadata` internal registry for a new [Metadata](Metadata.md) that should be committed with this transaction.

`newMetadata` is initially undefined (`None`). It can be [updated](#updateMetadata) only once and before the transaction [writes out any files](TransactionalWrite.md#hasWritten).

`newMetadata` is used when [prepareCommit](#prepareCommit) and [doCommit](#doCommit) (for statistics).

`newMetadata` is available using [metadata](#metadata) method.

### <span id="readFiles"> readFiles

```scala
readFiles: HashSet[AddFile]
```

`OptimisticTransactionImpl` uses `readFiles` registry to track [AddFile](AddFile.md)s that have been seen (_scanned_) by this transaction (when requested to [filterFiles](#filterFiles)).

Used to determine [isBlindAppend](#commit-isBlindAppend) and [checkForConflicts](#checkForConflicts) (and fail if the files have been deleted that the txn read).

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

* `DeltaSink` is requested to [add a streaming micro-batch](spark-connector/DeltaSink.md#addBatch) (and the batch reads the same Delta table as this sink is going to write to)

## <span id="updateMetadataForNewTable"> updateMetadataForNewTable

```scala
updateMetadataForNewTable(
  metadata: Metadata): Unit
```

`updateMetadataForNewTable`...FIXME

`updateMetadataForNewTable` is used when:

* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) and [CreateDeltaTableCommand](commands/create-table/CreateDeltaTableCommand.md) are executed

## <span id="metadata"> Metadata

```scala
metadata: Metadata
```

`metadata` is part of the [TransactionalWrite](TransactionalWrite.md#metadata) abstraction.

`metadata` is either the [newMetadata](#newMetadata) (if defined) or the [snapshotMetadata](#snapshotMetadata).

## <span id="updateMetadata"> Updating Metadata

```scala
updateMetadata(
  _metadata: Metadata): Unit
```

`updateMetadata` asserts the following:

* The current transaction has not written data out yet (and the [hasWritten](TransactionalWrite.md#hasWritten) flag is still disabled since it is not allowed to update the metadata in a transaction that has already written data)
* The metadata has not been changed already (and the [newMetadata](TransactionalWrite.md#newMetadata) has not been assigned yet since it is not allowed to change the metadata more than once in a transaction)

In the end, `updateMetadata` [updateMetadataInternal](#updateMetadataInternal).

---

`updateMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataForNewTable](#updateMetadataForNewTable)
* [AlterTableSetPropertiesDeltaCommand](commands/alter/AlterTableSetPropertiesDeltaCommand.md), [AlterTableUnsetPropertiesDeltaCommand](commands/alter/AlterTableUnsetPropertiesDeltaCommand.md), [AlterTableAddColumnsDeltaCommand](commands/alter/AlterTableAddColumnsDeltaCommand.md), [AlterTableChangeColumnDeltaCommand](commands/alter/AlterTableChangeColumnDeltaCommand.md), [AlterTableReplaceColumnsDeltaCommand](commands/alter/AlterTableReplaceColumnsDeltaCommand.md) are executed
* [RestoreTableCommand](commands/restore/RestoreTableCommand.md) is executed
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)

### <span id="updateMetadataInternal"> updateMetadataInternal

```scala
updateMetadataInternal(
  _metadata: Metadata): Unit
```

`updateMetadataInternal`...FIXME

## <span id="filterFiles"> Files To Scan Matching Given Predicates

``` { .scala .annotate }
filterFiles(): Seq[AddFile] // (1)
filterFiles(
  filters: Seq[Expression]): Seq[AddFile]
```

1. No filters = all files

`filterFiles` gives the [files](AddFile.md) to scan for the given predicates (_filter expressions_).

Internally, `filterFiles` requests the [Snapshot](#snapshot) for the [filesForScan](PartitionFiltering.md#filesForScan) (for no projection attributes and the given filters).

`filterFiles` finds the [partition predicates](DeltaTableUtils.md#isPredicatePartitionColumnsOnly) among the given filters (and the [partition columns](Metadata.md#partitionColumns) of the [Metadata](#metadata)).

`filterFiles` registers (_adds_) the partition predicates (in the [readPredicates](#readPredicates) internal registry) and the files to scan (in the [readFiles](#readFiles) internal registry).

`filterFiles` is used when:

* `DeltaSink` is requested to [add a streaming micro-batch](spark-connector/DeltaSink.md#addBatch) (with `Complete` output mode)
* [DeleteCommand](commands/delete/DeleteCommand.md), [MergeIntoCommand](commands/merge/MergeIntoCommand.md) and [UpdateCommand](commands/update/UpdateCommand.md), [WriteIntoDelta](commands/WriteIntoDelta.md) are executed
* [CreateDeltaTableCommand](commands/create-table/CreateDeltaTableCommand.md) is executed

## <span id="lockCommitIfEnabled"> lockCommitIfEnabled

```scala
lockCommitIfEnabled[T](
  body: => T): T
```

`lockCommitIfEnabled` executes the `body` with a [lock](DeltaLog.md#lockInterruptibly) on a delta table when [isCommitLockEnabled](#isCommitLockEnabled). Otherwise, `lockCommitIfEnabled` does not acquire a lock.

`lockCommitIfEnabled` is used when:

* `OptimisticTransactionImpl` is requested to [doCommitRetryIteratively](#doCommitRetryIteratively)

### <span id="isCommitLockEnabled"> isCommitLockEnabled

```scala
isCommitLockEnabled: Boolean
```

`isCommitLockEnabled` is the value of [spark.databricks.delta.commitLock.enabled](configuration-properties/DeltaSQLConf.md#DELTA_COMMIT_LOCK_ENABLED) configuration property (if defined) or [isPartialWriteVisible](storage/LogStore.md#isPartialWriteVisible) (requesting the [LogStore](DeltaLog.md#store) from the [DeltaLog](#deltaLog)).

!!! note
    `isCommitLockEnabled` is `true` by default given the following:

    1. [spark.databricks.delta.commitLock.enabled](configuration-properties/DeltaSQLConf.md#DELTA_COMMIT_LOCK_ENABLED) configuration property is undefined by default
    1. [isPartialWriteVisible](storage/LogStore.md#isPartialWriteVisible) is `true` by default

### Registering Post-Commit Hook { #registerPostCommitHook }

```scala
registerPostCommitHook(
  hook: PostCommitHook): Unit
```

??? warning "Procedure"
    `registerPostCommitHook` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`registerPostCommitHook` registers (_adds_) the given [PostCommitHook](post-commit-hooks/PostCommitHook.md) to the [postCommitHooks](#postCommitHooks) internal registry.

---

`registerPostCommitHook` is used when:

* `OptimisticTransactionImpl` is requested to [commitImpl](#commitImpl)
* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)

## setNewProtocolWithFeaturesEnabledByMetadata { #setNewProtocolWithFeaturesEnabledByMetadata }

```scala
setNewProtocolWithFeaturesEnabledByMetadata(
  metadata: Metadata): Unit
```

`setNewProtocolWithFeaturesEnabledByMetadata` [upgradeProtocolFromMetadataForExistingTable](Protocol.md#upgradeProtocolFromMetadataForExistingTable) (with the given [Metadata](Metadata.md) and the [Protocol](#protocol)) and makes it this transaction's [protocol](#newProtocol).

---

`setNewProtocolWithFeaturesEnabledByMetadata` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](#updateMetadataInternal) and [prepareCommit](#prepareCommit)

## Committing Large (Data Files) { #commitLarge }

```scala
commitLarge(
  spark: SparkSession,
  actions: Iterator[Action],
  op: DeltaOperations.Operation,
  context: Map[String, String],
  metrics: Map[String, String]): (Long, Snapshot)
```

`commitLarge`...FIXME

---

`commitLarge` is used for the following commands:

* [CONVERT](commands/convert/index.md) (and [performConvert](commands/convert/ConvertToDeltaCommand.md#performConvert))
* [CreateDeltaTableCommand](commands/create-table/CreateDeltaTableCommand.md) (and [handleClone](commands/clone/CloneTableBase.md#handleClone))
* [RESTORE](commands/restore/index.md)

## Metadata Can Be Updated { #canUpdateMetadata }

```scala
canUpdateMetadata: Boolean
```

`canUpdateMetadata` holds when neither this transaction has already written data nor the metadata has been already changed.

In other words, `canUpdateMetadata` holds `true` when both of the following hold:

1. [hasWritten](TransactionalWrite.md#hasWritten) is `false`
1. [newMetadata](#newMetadata) is undefined

---

`canUpdateMetadata` is used when:

* `WriteIntoDelta` is requested to [write data out](commands/WriteIntoDelta.md#write)

## Metadata Check for CDF Columns { #performCdcMetadataCheck }

```scala
performCdcMetadataCheck(): Unit
```

??? warning "Procedure"
    `performCdcMetadataCheck` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

??? note "Noop"
    `performCdcMetadataCheck` does nothing (_noop_) when executed with either the [newMetadata](#newMetadata) registry empty or [isCDCEnabledOnTable](change-data-feed/CDCReaderImpl.md#isCDCEnabledOnTable).

For the [new metadata](#newMetadata) and [Change Data Feed feature enabled on the table](change-data-feed/CDCReaderImpl.md#isCDCEnabledOnTable), `performCdcMetadataCheck` takes the column names of the newly-assigned metadata and compares them with the [reserved column names of CDF (CDF-aware read schema)](change-data-feed/CDCReaderImpl.md#cdcReadSchema).

If there are any reserved CDF column names found in the new metadata, `performCdcMetadataCheck` throws a `DeltaIllegalStateException` for the following:

* CDF was not enabled previously (in the initial metadata of the table snapshot) but reserved columns are present in the new schema
* CDF was enabled but reserved columns are present in the new metadata (i.e., in the data)

---

`performCdcMetadataCheck` is used when:

* `OptimisticTransactionImpl` is requested to [commitImpl](#commitImpl)

## Logging

`OptimisticTransactionImpl` is a Scala trait and logging is configured using the logger of the [implementations](#implementations).
