# CommitInfo

`CommitInfo` is an [Action](Action.md) defined by the following properties:

* <span id="version"> Version (optional)
* <span id="timestamp"> Timestamp
* <span id="userId"> User ID (optional)
* <span id="userName"> User Name (optional)
* <span id="operation"> [Operation](Operation.md#name)
* <span id="operationParameters"> [Operation Parameters](Operation.md#parameters)
* <span id="job"> JobInfo (optional)
* <span id="notebook"> NotebookInfo (optional)
* <span id="clusterId"> Cluster ID (optional)
* <span id="readVersion"> Read Version (optional)
* <span id="isolationLevel"> [Isolation Level](IsolationLevel.md) (optional)
* [isBlindAppend](#isBlindAppend) flag (optional)
* <span id="operationMetrics"> Operation Metrics (optional)
* <span id="userMetadata"> User metadata (optional)

`CommitInfo` is created (using [apply](#apply) and [empty](#empty) utilities) when:

* `DeltaHistoryManager` is requested for [version and commit history](DeltaHistoryManager.md#getHistory) (for [DeltaTable.history](DeltaTable.md#history) operator and [DESCRIBE HISTORY](sql/index.md#DESCRIBE-HISTORY) SQL command)
* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit) (with [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#commitInfo.enabled) configuration property enabled)
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge) (for [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) command and `FileAlreadyExistsException` was thrown)

`CommitInfo` is used as a part of [OptimisticTransactionImpl](OptimisticTransactionImpl.md#commitInfo) and `CommitStats`.

## <span id="isBlindAppend"> Blind Append

`CommitInfo` is given `isBlindAppend` flag (when created) to indicate whether a commit has [blindly appended](OptimisticTransactionImpl.md#commit-isBlindAppend) data without caring about existing files.

`isBlindAppend` flag is used while [checking for logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts) (at [commit](OptimisticTransactionImpl.md#commit)).

`isBlindAppend` flag is always `false` when `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge).

## DeltaHistoryManager

`CommitInfo` can be looked up using [DeltaHistoryManager](DeltaHistoryManager.md#getCommitInfo) for the following:

* [DESCRIBE HISTORY](sql/index.md#DESCRIBE-HISTORY) SQL command
* [DeltaTable.history](DeltaTable.md#history) operation

## <span id="spark.databricks.delta.commitInfo.enabled"> spark.databricks.delta.commitInfo.enabled

`CommitInfo` is added (_logged_) to a delta log only with [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#commitInfo.enabled) configuration property enabled.

## <span id="empty"> Creating Empty CommitInfo

```scala
empty(
  version: Option[Long] = None): CommitInfo
```

`empty`...FIXME

`empty` is used when:

* `DeltaHistoryManager` is requested to [getCommitInfo](DeltaHistoryManager.md#getCommitInfo)

## <span id="apply"> Creating CommitInfo

```scala
apply(
  time: Long,
  operation: String,
  operationParameters: Map[String, String],
  commandContext: Map[String, String],
  readVersion: Option[Long],
  isolationLevel: Option[String],
  isBlindAppend: Option[Boolean],
  operationMetrics: Option[Map[String, String]],
  userMetadata: Option[String]): CommitInfo
```

`apply` creates a `CommitInfo` (for the given arguments and based on the given `commandContext` for the user ID, user name, job, notebook, cluster).

`commandContext` argument is always empty, but could be customized using [ConvertToDeltaCommandBase](commands/ConvertToDeltaCommand.md#ConvertToDeltaCommandBase).

`apply` is used when:

* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit) (with [spark.databricks.delta.commitInfo.enabled](DeltaSQLConf.md#commitInfo.enabled) configuration property enabled)
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge)
