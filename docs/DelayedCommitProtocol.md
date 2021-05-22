# DelayedCommitProtocol

`DelayedCommitProtocol` is a `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol)) to write out data to a [directory](#path) and return the [files added](#addedStatuses).

`DelayedCommitProtocol` is used to model a distributed write that is orchestrated by the Spark driver with the write itself happening on executors.

!!! note
    `FileCommitProtocol` allows to track a write job (with a write task per partition) and inform the driver when all the write tasks finished successfully (and were [committed](#commitTask)) to consider the write job [completed](#commitJob). `TaskCommitMessage` (Spark Core) allows to "transfer" the files added (written out) on the executors to the driver for the [optimistic transactional writer](TransactionalWrite.md#writeFiles).

`DelayedCommitProtocol` is a `Serializable`.

## Creating Instance

`DelayedCommitProtocol` takes the following to be created:

* <span id="jobId"> Job ID
* <span id="path"> Path (to write files to)
* <span id="randomPrefixLength"> (optional) Length of Random Prefix

`DelayedCommitProtocol` is created when:

* `TransactionalWrite` is requested for a [committer](TransactionalWrite.md#getCommitter) (to [write a structured query](TransactionalWrite.md#writeFiles) to the [directory](#path))

## <span id="addedFiles"> addedFiles

```scala
addedFiles: ArrayBuffer[(Map[String, String], String)]
```

`DelayedCommitProtocol` uses `addedFiles` internal registry to track the files [added by a Spark write task](#newTaskTempFile).

`addedFiles` is used on the executors only.

`addedFiles` is initialized (as an empty collection) when [setting up a task](#setupTask).

`addedFiles` is used when:

* `DelayedCommitProtocol` is requested to [commit a task](#commitTask) (on an executor and create a `TaskCommitMessage` with the files added while a task was writing out a partition of a streaming query)

## <span id="addedStatuses"> addedStatuses

```scala
addedStatuses: ArrayBuffer[AddFile]
```

`DelayedCommitProtocol` uses `addedStatuses` internal registry to track the files that were added by [write tasks](#commitTask) (on executors) once all they finish successfully and the [write job is committed](#commitJob) (on a driver).

`addedStatuses` is used on the driver only.

`addedStatuses` is used when:

* `DelayedCommitProtocol` is requested to [commit a job](#commitJob) (on a driver)
* `TransactionalWrite` is requested to [write out a structured query](TransactionalWrite.md#writeFiles)

## <span id="setupJob"> Setting Up Job

```scala
setupJob(
  jobContext: JobContext): Unit
```

`setupJob` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#setupJob)) abstraction.

`setupJob` is a noop.

## <span id="commitJob"> Committing Job

```scala
commitJob(
  jobContext: JobContext,
  taskCommits: Seq[TaskCommitMessage]): Unit
```

`commitJob` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#commitJob)) abstraction.

`commitJob` adds the [AddFile](AddFile.md)s (from the given `taskCommits` from every [commitTask](#commitTask)) to the [addedStatuses](#addedStatuses) internal registry.

## <span id="abortJob"> Aborting Job

```scala
abortJob(
  jobContext: JobContext): Unit
```

`abortJob` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#abortJob)) abstraction.

`abortJob` is a noop.

## <span id="setupTask"> Setting Up Task

```scala
setupTask(
  taskContext: TaskAttemptContext): Unit
```

`setupTask` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#setupTask)) abstraction.

`setupTask` initializes the [addedFiles](#addedFiles) internal registry to be empty.

## <span id="newTaskTempFile"> New Temp File (Relative Path)

```scala
newTaskTempFile(
  taskContext: TaskAttemptContext,
  dir: Option[String],
  ext: String): String
```

`newTaskTempFile` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#newTaskTempFile)) abstraction.

`newTaskTempFile` [creates a file name](#getFileName) for the given `TaskAttemptContext` and `ext`.

`newTaskTempFile` tries to [parsePartitions](#parsePartitions) with the given `dir` or falls back to an empty `partitionValues`.

!!! note
    The given `dir` defines a partition directory if the streaming query (and hence the write) is partitioned.

`newTaskTempFile` builds a path (based on the given `randomPrefixLength` and the `dir`, or uses the file name directly).

!!! FIXME
    When are the optional `dir` and the [randomPrefixLength](#randomPrefixLength) defined?

`newTaskTempFile` adds the partition values and the relative path to the [addedFiles](#addedFiles) internal registry.

In the end, `newTaskTempFile` returns the absolute path of the (relative) path in the [directory](#path).

### <span id="getFileName"> File Name

```scala
getFileName(
  taskContext: TaskAttemptContext,
  ext: String,
  partitionValues: Map[String, String]): String
```

`getFileName` takes the task ID from the given `TaskAttemptContext` ([Apache Spark]({{ book.spark_core }}/TaskAttemptContext)) (for the `split` part below).

`getFileName` generates a random UUID (for the `uuid` part below).

In the end, `getFileName` returns a file name of the format:

```text
part-[split]-[uuid][ext]
```

## <span id="newTaskTempFileAbsPath"> New Temp File (Absolute Path)

```scala
newTaskTempFileAbsPath(
  taskContext: TaskAttemptContext,
  absoluteDir: String,
  ext: String): String
```

`newTaskTempFileAbsPath` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#newTaskTempFileAbsPath)) abstraction.

`newTaskTempFileAbsPath` throws an `UnsupportedOperationException`:

```text
[this] does not support adding files with an absolute path
```

## <span id="commitTask"> Committing Task

```scala
commitTask(
  taskContext: TaskAttemptContext): TaskCommitMessage
```

`commitTask` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#commitTask)) abstraction.

`commitTask` creates a `TaskCommitMessage` with an [AddFile](AddFile.md) for every [file added](#addedFiles) if there are any. Otherwise, `commitTask` creates an empty `TaskCommitMessage`.

!!! note
    A file is added (to the [addedFiles](#addedFiles) internal registry) when `DelayedCommitProtocol` is requested for a [new file (path)](#newTaskTempFile).

## <span id="abortTask"> Aborting Task

```scala
abortTask(
  taskContext: TaskAttemptContext): Unit
```

`abortTask` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#abortTask)) abstraction.

`abortTask` is a noop.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.files.DelayedCommitProtocol` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.files.DelayedCommitProtocol=ALL
```

Refer to [Logging](spark-logging.md).
