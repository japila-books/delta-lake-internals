= DeltaCommand

*DeltaCommand* is the <<contract, abstraction>> of <<implementations, Delta commands>> that can <<FIXME, FIXME>>.

[[implementations]]
.DeltaCommands (Direct Implementations and Extensions Only)
[cols="30,70",options="header",width="100%"]
|===
| DeltaCommand
| Description

| <<WriteIntoDelta.adoc#, WriteIntoDelta>>
| [[WriteIntoDelta]]

| <<VacuumCommandImpl.adoc#, VacuumCommandImpl>>
| [[VacuumCommandImpl]]

| <<UpdateCommand.adoc#, UpdateCommand>>
| [[UpdateCommand]]

| <<MergeIntoCommand.adoc#, MergeIntoCommand>>
| [[MergeIntoCommand]]

| <<ConvertToDeltaCommandBase.adoc#, ConvertToDeltaCommandBase>>
| [[ConvertToDeltaCommandBase]]

| <<DeleteCommand.adoc#, DeleteCommand>>
| [[DeleteCommand]]

|===

== [[parsePartitionPredicates]] `parsePartitionPredicates` Method

[source, scala]
----
parsePartitionPredicates(
  spark: SparkSession,
  predicate: String): Seq[Expression]
----

`parsePartitionPredicates`...FIXME

NOTE: `parsePartitionPredicates` is used when...FIXME

== [[verifyPartitionPredicates]] `verifyPartitionPredicates` Method

[source, scala]
----
verifyPartitionPredicates(
  spark: SparkSession,
  partitionColumns: Seq[String],
  predicates: Seq[Expression]): Unit
----

`verifyPartitionPredicates`...FIXME

NOTE: `verifyPartitionPredicates` is used when...FIXME

== [[generateCandidateFileMap]] `generateCandidateFileMap` Method

[source, scala]
----
generateCandidateFileMap(
  basePath: Path,
  candidateFiles: Seq[AddFile]): Map[String, AddFile]
----

`generateCandidateFileMap`...FIXME

NOTE: `generateCandidateFileMap` is used when...FIXME

== [[removeFilesFromPaths]] `removeFilesFromPaths` Method

[source, scala]
----
removeFilesFromPaths(
  deltaLog: DeltaLog,
  nameToAddFileMap: Map[String, AddFile],
  filesToRewrite: Seq[String],
  operationTimestamp: Long): Seq[RemoveFile]
----

`removeFilesFromPaths`...FIXME

NOTE: `removeFilesFromPaths` is used when <<DeleteCommand.adoc#, DeleteCommand>> and <<UpdateCommand.adoc#, UpdateCommand>> are executed.

== [[buildBaseRelation]] Creating HadoopFsRelation (With TahoeBatchFileIndex) -- `buildBaseRelation` Method

[source, scala]
----
buildBaseRelation(
  spark: SparkSession,
  txn: OptimisticTransaction,
  actionType: String,
  rootPath: Path,
  inputLeafFiles: Seq[String],
  nameToAddFileMap: Map[String, AddFile]): HadoopFsRelation
----

[[buildBaseRelation-scannedFiles]]
`buildBaseRelation` converts the given `inputLeafFiles` to <<getTouchedFile, AddFiles>> (with the given `rootPath` and `nameToAddFileMap`).

`buildBaseRelation` creates a <<TahoeBatchFileIndex.adoc#, TahoeBatchFileIndex>> for the `actionType`, the <<buildBaseRelation-scannedFiles, AddFiles>> and the `rootPath`.

In the end, `buildBaseRelation` creates a `HadoopFsRelation` with the `TahoeBatchFileIndex` (and the other properties based on the <<OptimisticTransactionImpl.adoc#metadata, metadata>> of the given <<OptimisticTransaction.adoc#, OptimisticTransaction>>).

NOTE: `buildBaseRelation` is used when <<DeleteCommand.adoc#, DeleteCommand>> and <<UpdateCommand.adoc#, UpdateCommand>> are executed (with `delete` and `update` action types, respectively).

== [[getTouchedFile]] `getTouchedFile` Method

[source, scala]
----
getTouchedFile(
  basePath: Path,
  filePath: String,
  nameToAddFileMap: Map[String, AddFile]): AddFile
----

`getTouchedFile`...FIXME

[NOTE]
====
`getTouchedFile` is used when:

* DeltaCommand is requested to <<removeFilesFromPaths, removeFilesFromPaths>> and <<buildBaseRelation, create a HadoopFsRelation>> (for <<DeleteCommand.adoc#, DeleteCommand>> and <<UpdateCommand.adoc#, UpdateCommand>>)

* <<MergeIntoCommand.adoc#, MergeIntoCommand>> is executed
====
