= PostCommitHook

*PostCommitHook* is an <<contract, abstraction>> of <<implementations, post-commit hooks>> that have a <<name, user-friendly name>> and can be <<run, executed>> (when `OptimisticTransactionImpl` is <<OptimisticTransactionImpl.adoc#commit, committed>>).

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

Used when `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.adoc#runPostCommitHooks, run post-commit hooks>> (when <<OptimisticTransactionImpl.adoc#commit, committed>>)

| name
a| [[name]]

[source, scala]
----
name: String
----

User-friendly name of the hook for error reporting

Used when:

* `DeltaErrors` utility is used to <<DeltaErrors.adoc#postCommitHookFailedException, report an post-commit hook failure>>

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.adoc#runPostCommitHooks, run post-commit hooks>> (when <<OptimisticTransactionImpl.adoc#commit, committed>>)

* `GenerateSymlinkManifestImpl` is requested to <<GenerateSymlinkManifest.adoc#handleError, handle an error>>

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

Used when `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.adoc#runPostCommitHooks, run post-commit hooks>> (when <<OptimisticTransactionImpl.adoc#commit, committed>>)

|===

[[implementations]]
NOTE: <<GenerateSymlinkManifest.adoc#GenerateSymlinkManifestImpl, GenerateSymlinkManifestImpl>> is the default and only known PostCommitHook in Delta Lake.
