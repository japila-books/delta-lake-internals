# GenerateSymlinkManifest (And GenerateSymlinkManifestImpl)

[[GenerateSymlinkManifest]]
`GenerateSymlinkManifest` is a concrete <<GenerateSymlinkManifestImpl, post-commit hook>> to generate <<generateIncrementalManifest, incremental>> and <<generateFullManifest, full>> Hive-style manifests for delta tables.

NOTE: You can generate a <<generateFullManifest, full>> Hive-style manifest for delta tables using <<DeltaSqlAstBuilder.md#visitGenerate, GENERATE>> SQL command or <<DeltaTable.md#generate, DeltaTable.generate>> operator.

[[GenerateSymlinkManifestImpl]]
`GenerateSymlinkManifestImpl` is a <<PostCommitHook.md#, post-commit hook>> that...FIXME

== [[generateFullManifest]] `generateFullManifest` Method

[source, scala]
----
generateFullManifest(
  spark: SparkSession,
  deltaLog: DeltaLog): Unit
----

`generateFullManifest`...FIXME

NOTE: `generateFullManifest` is used when...FIXME

== [[generateIncrementalManifest]] `generateIncrementalManifest` Method

[source, scala]
----
generateIncrementalManifest(
  spark: SparkSession,
  deltaLog: DeltaLog,
  txnReadSnapshot: Snapshot,
  actions: Seq[Action]): Unit
----

`generateIncrementalManifest`...FIXME

NOTE: `generateIncrementalManifest` is used when...FIXME

== [[run]] Running Post-Commit Hook -- `run` Method

[source, scala]
----
run(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  committedActions: Seq[Action]): Unit
----

NOTE: `run` is part of the <<PostCommitHook.md#run, PostCommitHook contract>> to execute a post-commit hook.

`run` simply <<generateIncrementalManifest, generates an incremental manifest>> for the <<OptimisticTransactionImpl.md#deltaLog, deltaLog>> and <<OptimisticTransactionImpl.md#snapshot, snapshot>> of the delta table (of the given <<OptimisticTransactionImpl.md#, OptimisticTransactionImpl>>) and the <<Action.md#, committed actions>>.

== [[handleError]] Handling Errors -- `handleError` Method

[source, scala]
----
handleError(
  error: Throwable,
  version: Long): Unit
----

NOTE: `handleError` is part of the <<PostCommitHook.md#handleError, PostCommitHook contract>> to handle errors while <<run, running the hook>>

`handleError`...FIXME
