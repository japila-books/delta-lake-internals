= LogStore

`LogStore` is an <<contract, abstraction>> of <<implementations, log stores>> that can <<read, read>> and <<write, write>> actions to a directory (among other things).

[[contract]]
.LogStore Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| invalidateCache
a| [[invalidateCache]]

[source, scala]
----
invalidateCache(): Unit
----

Used when...FIXME

| isPartialWriteVisible
a| [[isPartialWriteVisible]]

[source, scala]
----
isPartialWriteVisible(path: Path): Boolean = true
----

Used when...FIXME

| listFrom
a| [[listFrom]]

[source, scala]
----
listFrom(
  path: Path): Iterator[FileStatus]
listFrom(
  path: String): Iterator[FileStatus]
----

Used when...FIXME

| read
a| [[read]]

[source, scala]
----
read(path: String): Seq[String]
read(path: Path): Seq[String]
----

Used when:

* `Checkpoints` is requested to <<Checkpoints.adoc#loadMetadataFromFile, loadMetadataFromFile>>

* `DeltaHistoryManager` utility is requested to <<DeltaHistoryManager.adoc#getCommitInfo, getCommitInfo>>

* `DeltaLog` is requested to <<DeltaLog.adoc#getChanges, getChanges>>

* `VerifyChecksum` is requested to <<VerifyChecksum.adoc#validateChecksum, validateChecksum>>

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.adoc#checkAndRetry, checkAndRetry>>

| write
a| [[write]]

[source, scala]
----
write(
  path: Path,
  actions: Iterator[String],
  overwrite: Boolean = false): Unit
write(
  path: String,
  actions: Iterator[String]): Unit
----

Writes the actions out to the given path (with or without overwrite as indicated).

Used when:

* `Checkpoints` is requested to <<Checkpoints.adoc#checkpoint, checkpoint>>

* `ConvertToDeltaCommand` is <<ConvertToDeltaCommand.adoc#run, executed>> (and does <<ConvertToDeltaCommand.adoc#streamWrite, streamWrite>>)

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.adoc#doCommit, doCommit>>

|===

[[implementations]]
.LogStores (Direct Implementations and Extensions Only)
[cols="30,70",options="header",width="100%"]
|===
| LogStore
| Description

| <<HDFSLogStore.adoc#, HDFSLogStore>>
| [[HDFSLogStore]]

| <<HadoopFileSystemLogStore.adoc#, HadoopFileSystemLogStore>>
| [[HadoopFileSystemLogStore]]

|===

== [[resolvePathOnPhysicalStorage]] `resolvePathOnPhysicalStorage` Method

[source, scala]
----
resolvePathOnPhysicalStorage(path: Path): Path
----

`resolvePathOnPhysicalStorage`...FIXME

NOTE: `resolvePathOnPhysicalStorage` is used when...FIXME

== [[apply]] Creating LogStore -- `apply` Utility

[source, scala]
----
apply(
  sc: SparkContext): LogStore
apply(
  sparkConf: SparkConf,
  hadoopConf: Configuration): LogStore
----

`apply`...FIXME

[NOTE]
====
`apply` is used when:

* `DeltaHistoryManager` is requested to <<DeltaHistoryManager.adoc#getHistory, getHistory>> and <<DeltaHistoryManager.adoc#parallelSearch0, parallelSearch0>>

* `DeltaFileOperations` utility is used to <<recursiveListDirs, recursiveListDirs>>
====
