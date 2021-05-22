= PostCommitHook

*PostCommitHook* is an <<contract, abstraction>> of <<implementations, post-commit hooks>> that have a <<name, user-friendly name>> and can be <<run, executed>> (when `OptimisticTransactionImpl` is <<OptimisticTransactionImpl.md#commit, committed>>).

[[contract]]
.PostCommitHook Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| handleError
a| [[handleError]]

[source, scala]
----
handleError(
  error: Throwable,
  version: Long): Unit = {}
----

Handles an error while <<run, running the post-commit hook>>

Used when `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#runPostCommitHooks, run post-commit hooks>> (when <<OptimisticTransactionImpl.md#commit, committed>>)

| name
a| [[name]]

[source, scala]
----
name: String
----

User-friendly name of the hook for error reporting

Used when:

* `DeltaErrors` utility is used to <<DeltaErrors.md#postCommitHookFailedException, report an post-commit hook failure>>

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#runPostCommitHooks, run post-commit hooks>> (when <<OptimisticTransactionImpl.md#commit, committed>>)

* `GenerateSymlinkManifestImpl` is requested to [handle an error](commands/generate/GenerateSymlinkManifest.md#handleError)

| run
a| [[run]]

[source, scala]
----
run(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  committedActions: Seq[Action]): Unit
----

Executes the post-commit hook

Used when `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#runPostCommitHooks, run post-commit hooks>> (when <<OptimisticTransactionImpl.md#commit, committed>>)

|===
