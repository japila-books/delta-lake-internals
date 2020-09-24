= CommitInfo

CommitInfo is an Action.md[] with the following:

* [[version]] Version
* [[timestamp]] Timestamp
* [[userId]] User ID
* [[userName]] User Name
* [[operation]] Operation.md#name[Name of the operation]
* [[operationParameters]] Operation.md#parameters[Parameters of the operation]
* [[job]] JobInfo
* [[notebook]] NotebookInfo
* [[clusterId]] Cluster ID
* [[readVersion]] Read Version
* [[isolationLevel]] Isolation Level
* [[isBlindAppend]] isBlindAppend flag (to indicate whether a commit has blindly appended without caring about existing files)
* [[operationMetrics]] Metrics of the operation
* [[userMetadata]] User metadata

CommitInfo is created (using <<apply, apply>> utility) when:

* OptimisticTransactionImpl is requested to OptimisticTransactionImpl.md#commit[commit]

* ConvertToDeltaCommand command is requested to ConvertToDeltaCommand.md#streamWrite[streamWrite] (when executed)

CommitInfo is used in OptimisticTransactionImpl.md#commitInfo[OptimisticTransactionImpl] and CommitStats.

CommitInfo is added (_logged_) to a Delta log only for DeltaSQLConf.md#commitInfo.enabled[spark.databricks.delta.commitInfo.enabled] configuration enabled.

== [[apply]] apply Utility

[source,scala]
----
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
----

apply creates a CommitInfo (for the given arguments and based on the given `commandContext` for the user ID, user name, job, notebook, cluster).

NOTE: commandContext is always empty, but could be customized using ConvertToDeltaCommand.md#ConvertToDeltaCommandBase[ConvertToDeltaCommandBase].

apply is used when:

* OptimisticTransactionImpl is requested to OptimisticTransactionImpl.md#commit[commit]

* ConvertToDeltaCommand command is requested to ConvertToDeltaCommand.md#streamWrite[streamWrite] (when executed)
