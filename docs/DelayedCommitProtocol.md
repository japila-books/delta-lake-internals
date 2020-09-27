# DelayedCommitProtocol

`DelayedCommitProtocol` is used to model a distributed write that is orchestrated by the Spark driver with the write itself happening on executors.

`DelayedCommitProtocol` is a concrete `FileCommitProtocol` (Spark Core) to write out a result of a structured query to a <<path, directory>> and return a <<addedStatuses, list of files added>>.

`FileCommitProtocol` (Spark Core) allows to track a write job (with a write task per partition) and inform the driver when all the write tasks finished successfully (and were <<commitTask, committed>>) to consider the write job <<commitJob, completed>>. `TaskCommitMessage` (Spark Core) allows to "transfer" the files added (written out) on the executors to the driver for the <<TransactionalWrite.md#writeFiles, optimistic transactional writer>>.

TIP: Read up on https://books.japila.pl/apache-spark-internals/apache-spark-internals/2.4.4/spark-internal-io-FileCommitProtocol.html[FileCommitProtocol] in https://books.japila.pl/apache-spark-internals[The Internals Of Apache Spark] online book.

`DelayedCommitProtocol` is <<creating-instance, created>> exclusively when `TransactionalWrite` is requested for a <<TransactionalWrite.md#getCommitter, committer>> to <<TransactionalWrite.md#writeFiles, write a structured query>> to the <<path, directory>>.

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.delta.files.DelayedCommitProtocol` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.delta.files.DelayedCommitProtocol=ALL
```

Refer to [Logging](spark-logging.md).
====

== [[creating-instance]] Creating DelayedCommitProtocol Instance

`DelayedCommitProtocol` takes the following to be created:

* [[jobId]] Job ID (seems always <<TransactionalWrite.md#getCommitter, delta>>)
* [[path]] Directory (to write files to)
* [[randomPrefixLength]] Optional length of a random prefix (seems always <<TransactionalWrite.md#getCommitter, empty>>)

`DelayedCommitProtocol` initializes the <<internal-properties, internal properties>>.

== [[setupTask]] `setupTask` Method

[source, scala]
----
setupTask(
  taskContext: TaskAttemptContext): Unit
----

NOTE: `setupTask` is part of the `FileCommitProtocol` contract to set up a task for a writing job.

`setupTask` simply initializes the <<addedFiles, addedFiles>> internal registry to be empty.

== [[newTaskTempFile]] `newTaskTempFile` Method

[source, scala]
----
newTaskTempFile(
  taskContext: TaskAttemptContext,
  dir: Option[String],
  ext: String): String
----

NOTE: `newTaskTempFile` is part of the `FileCommitProtocol` contract to inform the committer to add a new file.

`newTaskTempFile` <<getFileName, creates a file name>> for the given `TaskAttemptContext` and `ext`.

`newTaskTempFile` tries to <<parsePartitions, parsePartitions>> with the given `dir` or falls back to an empty `partitionValues`.

NOTE: The given `dir` defines a partition directory if the streaming query (and hence the write) is partitioned.

`newTaskTempFile` builds a path (based on the given `randomPrefixLength` and the `dir`, or uses the file name directly).

NOTE: FIXME When would the optional `dir` and the <<randomPrefixLength, randomPrefixLength>> be defined?

`newTaskTempFile` adds the partition values and the relative path to the <<addedFiles, addedFiles>> internal registry.

In the end, `newTaskTempFile` returns the absolute path of the (relative) path in the <<path, directory>>.

== [[commitTask]] Committing Task (After Successful Write) -- `commitTask` Method

[source, scala]
----
commitTask(
  taskContext: TaskAttemptContext): TaskCommitMessage
----

NOTE: `commitTask` is part of the `FileCommitProtocol` contract to commit a task after the writes succeed.

`commitTask` simply creates a `TaskCommitMessage` with an <<AddFile.md#, AddFile>> for every <<addedFiles, file added>> if there were any. Otherwise, the `TaskCommitMessage` is empty.

NOTE: A file is added (to <<addedFiles, addedFiles>> internal registry) when `DelayedCommitProtocol` is requested for a <<newTaskTempFile, new file (path)>>.

== [[commitJob]] Committing Spark Job (After Successful Write) -- `commitJob` Method

[source, scala]
----
commitJob(
  jobContext: JobContext,
  taskCommits: Seq[TaskCommitMessage]): Unit
----

NOTE: `commitJob` is part of the `FileCommitProtocol` contract to commit a job after the writes succeed.

`commitJob` simply adds the <<AddFile.md#, AddFiles>> (from the given `taskCommits` from every <<commitTask, commitTask>>) to the <<addedStatuses, addedStatuses>> internal registry.

== [[parsePartitions]] `parsePartitions` Method

[source, scala]
----
parsePartitions(
  dir: String): Map[String, String]
----

`parsePartitions`...FIXME

NOTE: `parsePartitions` is used exclusively when `DelayedCommitProtocol` is requested to <<newTaskTempFile, newTaskTempFile>>.

== [[setupJob]] `setupJob` Method

[source, scala]
----
setupJob(
  jobContext: JobContext): Unit
----

NOTE: `setupJob` is part of the `FileCommitProtocol` contract to set up a Spark job.

`setupJob` does nothing.

== [[abortJob]] `abortJob` Method

[source, scala]
----
abortJob(
  jobContext: JobContext): Unit
----

NOTE: `abortJob` is part of the `FileCommitProtocol` contract to abort a Spark job.

`abortJob` does nothing.

== [[getFileName]] `getFileName` Method

[source, scala]
----
getFileName(
  taskContext: TaskAttemptContext,
  ext: String): String
----

`getFileName` takes the task ID from the given `TaskAttemptContext` (for the `split` part below).

`getFileName` generates a random UUID (for the `uuid` part below).

In the end, `getFileName` returns a file name of the format:

```
part-[split]%05d-[uuid][ext]
```

NOTE: `getFileName` is used exclusively when `DelayedCommitProtocol` is requested to <<newTaskTempFile, newTaskTempFile>>.

== [[addedFiles]] `addedFiles` Internal Registry

[source, scala]
----
addedFiles: ArrayBuffer[(Map[String, String], String)]
----

`addedFiles` tracks the files <<newTaskTempFile, added by a Spark write task>> (that runs on an executor).

`addedFiles` is initialized (as an empty collection) in <<setupTask, setupTask>>.

NOTE: `addedFiles` is used when `DelayedCommitProtocol` is requested to <<commitTask, commit a task>> (on an executor and create a `TaskCommitMessage` with the files added while a task was writing out a partition of a streaming query).

== [[addedStatuses]] `addedStatuses` Internal Registry

[source, scala]
----
addedStatuses = new ArrayBuffer[AddFile]
----

`addedStatuses` is the files that were added by <<commitTask, write tasks>> (on executors) once all they finish successfully and the <<commitJob, write job is committed>> (on a driver).

[NOTE]
====
`addedStatuses` is used when:

* `DelayedCommitProtocol` is requested to <<commitJob, commit a job>> (on a driver)

* `TransactionalWrite` is requested to <<TransactionalWrite.md#writeFiles, write out a structured query>>
====
