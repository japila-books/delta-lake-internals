# OptimisticTransactionImpl

**OptimisticTransactionImpl** is an <<contract, extension>> of the TransactionalWrite.md[] abstraction for <<implementations, optimistic transactions>> that can modify a <<deltaLog, Delta table>> (at a given <<snapshot, version>>) and can be <<commit, committed>> eventually.

In other words, OptimisticTransactionImpl is a set of Action.md[actions] as part of an Operation.md[].

== [[contract]] Contract

=== [[clock]] clock

[source,scala]
----
clock: Clock
----

=== [[deltaLog]] deltaLog

[source,scala]
----
deltaLog: DeltaLog
----

DeltaLog.md[] (of the delta table) that this transaction is changing

deltaLog is part of the TransactionalWrite.md#deltaLog[TransactionalWrite] contract and seems to change it to `val` (from `def`).

=== [[snapshot]] snapshot

[source,scala]
----
snapshot: Snapshot
----

Snapshot.md[] (of the <<deltaLog, delta table>>) that this transaction is changing

snapshot is part of the TransactionalWrite.md#deltaLog[TransactionalWrite] contract and seems to change it to `val` (from `def`).

== [[implementations]] Implementations

OptimisticTransaction.md[] is the default and only known OptimisticTransactionImpl in Delta Lake.

== [[metadata]] metadata Method

[source, scala]
----
metadata: Metadata
----

metadata is either the <<newMetadata, newMetadata>> (if defined) or the <<snapshotMetadata, snapshotMetadata>>.

metadata is part of the TransactionalWrite.md#metadata[TransactionalWrite] abstraction.

== [[readVersion]] readVersion Method

[source, scala]
----
readVersion: Long
----

readVersion simply requests the <<snapshot, Snapshot>> for the <<Snapshot.md#version, version>>.

readVersion is used when:

* OptimisticTransactionImpl is requested for <<snapshotMetadata, snapshotMetadata>>, to <<updateMetadata, updateMetadata>> and <<commit, commit>>

* `ConvertToDeltaCommand` is requested to <<ConvertToDeltaCommand.md#run, run>>

* `WriteIntoDelta` is requested to <<WriteIntoDelta.md#write, write>>

* `ImplicitMetadataOperation` is requested to <<ImplicitMetadataOperation.md#updateMetadata, updateMetadata>>

== [[updateMetadata]] Updating Metadata

[source, scala]
----
updateMetadata(
  metadata: Metadata): Unit
----

updateMetadata updates the <<newMetadata, newMetadata>> internal property based on the <<readVersion, readVersion>>:

* For `-1`, updateMetadata updates the <<Metadata.md#configuration, configuration>> of the given metadata with a <<DeltaConfigs.md#mergeGlobalConfigs, new metadata>> based on the `SQLConf` (of the active `SparkSession`), the <<Metadata.md#configuration, configuration>> of the given metadata and a new <<Protocol.md#, Protocol>>

* For other versions, updateMetadata leaves the given <<Action.md#Metadata, Metadata>> unchanged

[[updateMetadata-AssertionError-hasWritten]]
updateMetadata throws an `AssertionError` when the <<TransactionalWrite.md#hasWritten, hasWritten>> flag is enabled (`true`):

```
Cannot update the metadata in a transaction that has already written data.
```

updateMetadata throws an `AssertionError` when the <<newMetadata, newMetadata>> is not empty:

```
Cannot change the metadata more than once in a transaction.
```

updateMetadata is used when:

* <<ConvertToDeltaCommand.md#, ConvertToDeltaCommand>> is executed (and requested to <<ConvertToDeltaCommand.md#performConvert, performConvert>>)

* `ImplicitMetadataOperation` is requested to <<ImplicitMetadataOperation.md#updateMetadata, updateMetadata>>

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

== [[readWholeTable]] readWholeTable Method

[source, scala]
----
readWholeTable(): Unit
----

readWholeTable simply adds `True` literal to the <<readPredicates, readPredicates>> internal registry.

readWholeTable is used when DeltaSink is requested to DeltaSink.md#addBatch[add a streaming micro-batch] (and the batch reads the same Delta table as this sink is going to write to).

## <span id="commit"> Committing Transaction

```scala
commit(
  actions: Seq[Action],
  op: DeltaOperations.Operation): Long
```

`commit` commits the transaction (with the [Action](Action.md)s and a given [Operation](Operation.md))

[[commit-prepareCommit]]
commit firstly <<prepareCommit, prepares a commit>> (that gives the final actions to commit that may be different from the given <<Action.md#, actions>>).

[[commit-isolationLevelToUse]]
commit determines the isolation level for this commit by checking whether any <<FileAction.md#, FileAction>> (in the given <<Action.md#, actions>>) has the <<FileAction.md#dataChange, dataChange>> flag on (`true`). With no data changed, commit uses `SnapshotIsolation` else `Serializable`.

[[commit-isBlindAppend]]
commit...FIXME

[[commit-commitInfo]]
commit...FIXME

[[commit-registerPostCommitHook]]
commit <<registerPostCommitHook, registers>> the <<GenerateSymlinkManifest.md#, GenerateSymlinkManifest>> post-commit hook when there is a <<FileAction.md#, FileAction>> among the actions and the <<DeltaConfigs.md#SYMLINK_FORMAT_MANIFEST_ENABLED, compatibility.symlinkFormatManifest.enabled>> table property (<<DeltaConfigs.md#fromMetaData, from>> the <<metadata, Metadata>>) is enabled (`true`).

NOTE: <<DeltaConfigs.md#SYMLINK_FORMAT_MANIFEST_ENABLED, compatibility.symlinkFormatManifest.enabled>> table property defaults to `false`.

[[commit-commitVersion]]
commit <<doCommit, doCommit>> with the next version, the actions, attempt number `0`, and the select isolation level.

commit prints out the following INFO message to the logs:

```text
Committed delta #[commitVersion] to [logPath]
```

[[commit-postCommit]]
commit <<postCommit, postCommit>> (with the version committed and the actions).

[[commit-runPostCommitHooks]]
In the end, commit <<runPostCommitHooks, runs post-commit hooks>> and returns the version of the successful commit.

== [[prepareCommit]] Preparing Commit

[source, scala]
----
prepareCommit(
  actions: Seq[Action],
  op: DeltaOperations.Operation): Seq[Action]
----

prepareCommit adds the <<newMetadata, newMetadata>> action (if available) to the given <<Action.md#, actions>>.

prepareCommit <<verifyNewMetadata, verifyNewMetadata>> if there was one.

prepareCommit...FIXME

prepareCommit requests the <<deltaLog, DeltaLog>> to <<DeltaLog.md#protocolWrite, protocolWrite>>.

prepareCommit...FIXME

prepareCommit throws an `AssertionError` when the number of metadata changes in the transaction (by means of <<Action.md#Metadata, Metadata>> actions) is above `1`:

```
Cannot change the metadata more than once in a transaction.
```

prepareCommit throws an `AssertionError` when the <<committed, committed>> internal flag is turned on (`true`):

```
Transaction already committed.
```

prepareCommit is used when OptimisticTransactionImpl is requested to <<commit, commit>> (at the beginning).

== [[postCommit]] Performing Post-Commit Operations

[source, scala]
----
postCommit(
  commitVersion: Long,
  commitActions: Seq[Action]): Unit
----

postCommit...FIXME

postCommit is used when OptimisticTransactionImpl is requested to <<commit, commit>> (at the end).

== [[commitInfo]] CommitInfo

OptimisticTransactionImpl creates a CommitInfo.md[] when requested to <<commit, commit>> with DeltaSQLConf.md#commitInfo.enabled[spark.databricks.delta.commitInfo.enabled] configuration enabled.

OptimisticTransactionImpl uses the CommitInfo to recordDeltaEvent (as a CommitStats).

== [[registerPostCommitHook]] Registering Post-Commit Hook

[source, scala]
----
registerPostCommitHook(
  hook: PostCommitHook): Unit
----

registerPostCommitHook registers (_adds_) the given <<PostCommitHook.md#, PostCommitHook>> to the <<postCommitHooks, postCommitHooks>> internal registry.

NOTE: registerPostCommitHook adds the hook only once.

registerPostCommitHook is used when OptimisticTransactionImpl is requested to <<commit, commit>> (to register the <<GenerateSymlinkManifest.md#, GenerateSymlinkManifest>> post-commit hook).

== [[runPostCommitHooks]] Running Post-Commit Hooks

[source, scala]
----
runPostCommitHooks(
  version: Long,
  committedActions: Seq[Action]): Unit
----

runPostCommitHooks simply <<PostCommitHook.md#run, runs>> every <<PostCommitHook.md#, post-commit hook>> registered (in the <<postCommitHooks, postCommitHooks>> internal registry).

runPostCommitHooks <<OptimisticTransaction.md#clearActive, clears the active transaction>> (making all follow-up operations non-transactional).

NOTE: Hooks may create new transactions.

For any non-fatal exception, runPostCommitHooks prints out the following ERROR message to the logs, records the delta event, and requests the post-commit hook to <<PostCommitHook.md#handleError, handle the error>>.

```
Error when executing post-commit hook [name] for commit [version]
```

runPostCommitHooks throws an `AssertionError` when <<committed, committed>> flag is turned off (`false`):

```
Can't call post commit hooks before committing
```

runPostCommitHooks is used when OptimisticTransactionImpl is requested to <<commit, commit>>.

== [[doCommit]] Attempting Commit

[source, scala]
----
doCommit(
  attemptVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int): Long
----

doCommit returns the given `attemptVersion` as the commit version if successful or <<checkAndRetry, checkAndRetry>>.

Internally, doCommit prints out the following DEBUG message to the logs:

```
Attempting to commit version [attemptVersion] with [size] actions with [isolationLevel] isolation level
```

[[doCommit-write]]
doCommit requests the <<DeltaLog.md#store, LogStore>> (of the <<deltaLog, DeltaLog>>) to <<LogStore.md#write, write out>> the given <<Action.md#, actions>> (serialized to <<Action.md#json, JSON format>>) to a <<FileNames.md#deltaFile, delta file>> (e.g. `00000000000000000001.json`) in the <<DeltaLog.md#logPath, log directory>> (of the <<deltaLog, DeltaLog>>) with the `attemptVersion` version.

NOTE: <<LogStore.md#, LogStores>> must throw a `java.nio.file.FileAlreadyExistsException` exception if the delta file already exists. Any `FileAlreadyExistsExceptions` are caught by <<doCommit-FileAlreadyExistsException, doCommit>> itself to <<checkAndRetry, checkAndRetry>>.

[[doCommit-postCommitSnapshot]]
doCommit requests the <<deltaLog, DeltaLog>> to <<DeltaLog.md#update, update>>.

[[doCommit-IllegalStateException]]
doCommit throws an `IllegalStateException` if the version of the snapshot after update is smaller than the given `attemptVersion` version.

```
The committed version is [attemptVersion] but the current version is [version].
```

[[doCommit-stats]]
doCommit records a new `CommitStats` and returns the given `attemptVersion` as the commit version.

[[doCommit-FileAlreadyExistsException]]
doCommit catches `FileAlreadyExistsExceptions` and <<checkAndRetry, checkAndRetry>>.

doCommit is used when OptimisticTransactionImpl is requested to <<commit, commit>> (and <<checkAndRetry, checkAndRetry>>).

## <span id="checkAndRetry"> Retrying Commit

```scala
checkAndRetry(
  checkVersion: Long,
  actions: Seq[Action],
  attemptNumber: Int): Long
```

`checkAndRetry`...FIXME

`checkAndRetry` is used when OptimisticTransactionImpl is requested to [commit](#commit) (and [attempts a commit](#doCommit) that failed with an `FileAlreadyExistsException`).

== [[verifyNewMetadata]] verifyNewMetadata Method

[source, scala]
----
verifyNewMetadata(
  metadata: Metadata): Unit
----

verifyNewMetadata...FIXME

verifyNewMetadata is used when OptimisticTransactionImpl is requested to <<prepareCommit, prepareCommit>> and <<updateMetadata, updateMetadata>>.

== [[txnVersion]] Looking Up Transaction Version For Given (Streaming Query) ID

[source, scala]
----
txnVersion(
  id: String): Long
----

txnVersion simply registers (_adds_) the given ID in the <<readTxn, readTxn>> internal registry.

In the end, txnVersion requests the <<snapshot, Snapshot>> for the <<Snapshot.md#transactions, transaction version for the given ID>> or assumes `-1`.

txnVersion is used when `DeltaSink` is requested to <<DeltaSink.md#addBatch, add a streaming micro-batch>>.

## <span id="getOperationMetrics"> getOperationMetrics Method

```scala
getOperationMetrics(
  op: Operation): Option[Map[String, String]]
```

`getOperationMetrics`...FIXME

`getOperationMetrics` is used when `OptimisticTransactionImpl` is requested to [commit](#commit).

== [[getUserMetadata]] User-Defined Metadata

[source,scala]
----
getUserMetadata(
  op: Operation): Option[String]
----

getUserMetadata returns the Operation.md#userMetadata[userMetadata] of the given Operation.md[] (if defined) or the value of DeltaSQLConf.md#DELTA_USER_METADATA[spark.databricks.delta.commitInfo.userMetadata] configuration property.

getUserMetadata is used when OptimisticTransactionImpl is requested to <<commit, commit>> (and DeltaSQLConf.md#DELTA_COMMIT_INFO_ENABLED[spark.databricks.delta.commitInfo.enabled] configuration property is enabled).

== [[getPrettyPartitionMessage]] getPrettyPartitionMessage Method

[source,scala]
----
getPrettyPartitionMessage(
  partitionValues: Map[String, String]): String
----

getPrettyPartitionMessage...FIXME

getPrettyPartitionMessage is used when...FIXME

== [[getNextAttemptVersion]] getNextAttemptVersion Internal Method

[source,scala]
----
getNextAttemptVersion(
  previousAttemptVersion: Long): Long
----

getNextAttemptVersion...FIXME

getNextAttemptVersion is used when OptimisticTransactionImpl is requested to <<checkAndRetry, checkAndRetry>>.

== [[internal-registries]] Internal Registries

=== [[postCommitHooks]] Post-Commit Hooks

[source, scala]
----
postCommitHooks: ArrayBuffer[PostCommitHook]
----

OptimisticTransactionImpl manages PostCommitHook.md[]s that will be <<runPostCommitHooks, executed>> right after a <<commit, commit>> is successful.

Post-commit hooks can be <<registerPostCommitHook, registered>>, but only the <<GenerateSymlinkManifest.md#, GenerateSymlinkManifest>> post-commit hook is supported (when...FIXME).

=== [[newMetadata]] newMetadata

[source, scala]
----
newMetadata: Option[Metadata]
----

OptimisticTransactionImpl uses the newMetadata internal registry for a new <<Metadata.md#, Metadata>> that should be committed with this transaction.

newMetadata is initially undefined (`None`). It can be <<updateMetadata, updated>> only once and before the transaction <<TransactionalWrite.md#hasWritten, writes out any files>>.

newMetadata is used when <<prepareCommit, prepareCommit>> (and <<doCommit, doCommit>> for statistics).

newMetadata is available using <<metadata, metadata>> method.

=== [[readPredicates]] readPredicates

[source,scala]
----
readPredicates: ArrayBuffer[Expression]
----

readPredicates holds predicate expressions for partitions the transaction is modifying.

readPredicates is added a new predicate expression when <<filterFiles, filterFiles>> and <<readWholeTable, readWholeTable>>.

readPredicates is used when <<checkAndRetry, checkAndRetry>>.

== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| committed
a| [[committed]] Flag that controls whether the transaction is <<commit, committed>> or not (and prevents <<prepareCommit, prepareCommit>> from being executed again)

Default: `false`

Enabled (set to `true`) exclusively in <<postCommit, postCommit>>

| dependsOnFiles
a| [[dependsOnFiles]] Flag that...FIXME

Default: `false`

Enabled (set to `true`) in <<filterFiles, filterFiles>>, <<readWholeTable, readWholeTable>>

Used in <<commit, commit>> and <<checkAndRetry, checkAndRetry>>

| readFiles
a| [[readFiles]]

| readTxn
a| [[readTxn]] Streaming query IDs that have been seen by this transaction

A new queryId is added when OptimisticTransactionImpl is requested for <<txnVersion, txnVersion>>

Used when OptimisticTransactionImpl is requested to <<checkAndRetry, checkAndRetry>> (to fail with a `ConcurrentTransactionException` for idempotent transactions that have conflicted)

| snapshotMetadata
a| [[snapshotMetadata]] <<Metadata.md#, Metadata>> of the <<snapshot, Snapshot>>

|===
