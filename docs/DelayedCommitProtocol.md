# DelayedCommitProtocol

`DelayedCommitProtocol` is a `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol)) to write out data to a [directory](#path) and return the [files added](#addedFiles).

`DelayedCommitProtocol` is used to model a distributed write that is orchestrated by the Spark driver with the write itself happening on executors.

!!! note
    `FileCommitProtocol` allows to track a write job (with a write task per partition) and inform the driver when all the write tasks finished successfully (and were [committed](#commitTask)) to consider the write job [completed](#commitJob).

    `TaskCommitMessage` (Spark Core) allows to "transfer" the file names added (written out) on the executors to the driver for the [optimistic transactional writer](TransactionalWrite.md#writeFiles).

## Creating Instance

`DelayedCommitProtocol` takes the following to be created:

* [Job ID](#jobId)
* [Data path](#path)
* [Length of the random prefix](#randomPrefixLength)

`DelayedCommitProtocol` is created when:

* `TransactionalWrite` is requested for a [committer](TransactionalWrite.md#getCommitter) (to [write data out](TransactionalWrite.md#writeFiles) to the [directory](#path))

### <span id="jobId"> Job ID

`DelayedCommitProtocol` is given a job ID that is always `delta`.

??? note "Unused"
    The Job ID does not seem to be used.

### <span id="path"> Data Path

`DelayedCommitProtocol` is given a `path` when [created](#creating-instance).

The path is the [data directory](DeltaLog.md#dataPath) of a [delta table](DeltaLog.md) (this `DelayedCommitProtocol` coordinates a write process to)

### <span id="randomPrefixLength"> Length of Random Prefix

`DelayedCommitProtocol` can be given a `randomPrefixLength` when [created](#creating-instance).

The `randomPrefixLength` is [always undefined](TransactionalWrite.md#getCommitter) (`None`).

## <span id="cdc"><span id="cdcPartitionFalse"><span id="cdcPartitionTrue"><span id="cdcPartitionTrueRegex"> Change Data Feed Partition Handling

`DelayedCommitProtocol` defines 3 values to support [Change Data Feed](change-data-feed/index.md):

* `__is_cdc=false`
* `__is_cdc=true`
* A `Regex` to match on `__is_cdc=true` text

`DelayedCommitProtocol` uses them for [newTaskTempFile](#newTaskTempFile) (to create temporary files in [_change_data](change-data-feed/CDCReader.md#CDC_LOCATION) directory instead based on the regular expression).

## Added Files (on Executors) { #addedFiles }

```scala
addedFiles: ArrayBuffer[(Map[String, String], String)]
```

`DelayedCommitProtocol` uses `addedFiles` internal registry to track the [partition values](#parsePartitions) (if writing happened to a partitioned table) and the relative paths of the files that were [added by a write task](#newTaskTempFile).

`addedFiles` is used on executors only.

`addedFiles` is initialized (as an empty collection) when [setting up a task](#setupTask).

---

`addedFiles` is used when:

* `DelayedCommitProtocol` is requested to [commit a task](#commitTask) (on an executor and create a `TaskCommitMessage` with the files added while a task was writing data out)

## Added Statuses (on Driver) { #addedStatuses }

```scala
addedStatuses: ArrayBuffer[AddFile]
```

`DelayedCommitProtocol` uses `addedStatuses` internal registry to track the [AddFile](AddFile.md) files added by [write tasks](#commitTask) (on executors) once all they finish successfully and the [write job is committed](#commitJob) (on a driver).

`addedStatuses` is used on the driver only.

`addedStatuses` is used when:

* `DelayedCommitProtocol` is requested to [commit a job](#commitJob) (on a driver)
* `TransactionalWrite` is requested to [write out a structured query](TransactionalWrite.md#writeFiles)

## <span id="changeFiles"> AddCDCFiles

```scala
changeFiles: ArrayBuffer[AddCDCFile]
```

`DelayedCommitProtocol` uses `changeFiles` internal registry to track the [AddCDCFile](AddCDCFile.md) files added by [write tasks](#commitTask) (on executors) once all they finish successfully and the [write job is committed](#commitJob) (on a driver).

`changeFiles` is used on the driver only.

`changeFiles` is used when:

* `DelayedCommitProtocol` is requested to [commit a job](#commitJob) (on a driver)
* `TransactionalWrite` is requested to [write out a structured query](TransactionalWrite.md#writeFiles)

## Committing Job { #commitJob }

??? note "Signature"

    ```scala
    commitJob(
      jobContext: JobContext,
      taskCommits: Seq[TaskCommitMessage]): Unit
    ```

    `commitJob` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#commitJob)) abstraction.

`commitJob` partitions the given `TaskCommitMessage`s into a collection of [AddFile](AddFile.md)s and [AddCDCFile](AddCDCFile.md)s.

In the end, `commitJob` adds the `AddFile`s to [addedStatuses](#addedStatuses) registry while the `AddCDCFile`s to the [changeFiles](#changeFiles).

## Setting Up Task { #setupTask }

??? note "FileCommitProtocol"

    ```scala
    setupTask(
      taskContext: TaskAttemptContext): Unit
    ```

    `setupTask` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#setupTask)) abstraction.

`setupTask` initializes the [addedFiles](#addedFiles) internal registry to be empty.

## New Task Temp File { #newTaskTempFile }

??? note "FileCommitProtocol"

    ```scala
    newTaskTempFile(
      taskContext: TaskAttemptContext,
      dir: Option[String],
      ext: String): String
    ```

    `newTaskTempFile` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#newTaskTempFile)) abstraction.

!!! note
    The given `dir` defines a partition directory if a query writes out to a partitioned table.

`newTaskTempFile` [parses the partition values](#parsePartitions) in the given `dir`, if available, or assumes no partition values (`partitionValues`).

`newTaskTempFile` [creates a file name](#getFileName) to write data out (for the given `TaskAttemptContext`, `ext`ension and the partition values).

!!! note "Change Data Feed"
    While [creating a file name](#getFileName), `DelayedCommitProtocol` uses the [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) virtual column name to split (_divide_) CDF data from the main table data.
    If the `__is_cdc` column contains `true`, the file name uses `cdc-` prefix (not `part-`).

`newTaskTempFile` builds a relative directory path (using the [randomPrefixLength](#randomPrefixLength) or the optional `dir` if either is defined).

!!! note "randomPrefixLength always undefined"
    [randomPrefixLength](#randomPrefixLength) is always undefined (`None`) so we can safely skip this branch.

* For the directory to be exactly [__is_cdc=false](#cdcPartitionFalse), `newTaskTempFile` returns the file name (with no further changes).

* For the directory with the [__is_cdc=true](#cdcPartitionTrue) path prefix, `newTaskTempFile` replaces the prefix with [_change_data](change-data-feed/CDCReader.md#CDC_LOCATION) and uses the changed directory as the parent of the file name.

    ```scala
    val subDir = "__is_cdc=true/a/b/c"

    val cdcPartitionTrue = "__is_cdc=true"
    val cdcPartitionTrueRegex = cdcPartitionTrue.r
    val path = cdcPartitionTrueRegex.replaceFirstIn(subDir, "_change_data")

    assert(path == "_change_data/a/b/c")
    ```

    !!! note "Change Data Feed"
        This is when `DelayedCommitProtocol` "redirects" writing out the [__is_cdc=true](#cdcPartitionTrue)-partitioned CDF data files to [_change_data](change-data-feed/CDCReader.md#CDC_LOCATION) directory.

* For the directory with the [__is_cdc=false](#cdcPartitionFalse) path prefix, `newTaskTempFile` removes the prefix and uses the changed directory as the parent of the file name.

* For other cases, `newTaskTempFile` uses the directory as the parent of the file name.

When neither the [randomPrefixLength](#randomPrefixLength) nor the partition directory (`dir`) is defined, `newTaskTempFile` uses the file name (with no further changes).

`newTaskTempFile` adds the partition values and the relative path to the [addedFiles](#addedFiles) internal registry.

In the end, `newTaskTempFile` returns the absolute path of the (relative) path in the [directory](#path).

### File Name { #getFileName }

```scala
getFileName(
  taskContext: TaskAttemptContext,
  ext: String,
  partitionValues: Map[String, String]): String
```

`getFileName` returns a file name of the format:

```text
[prefix]-[split]-[uuid][ext]
```

The file name is created as follows:

1. The `prefix` part is one of the following:
    * `cdc` for the given `partitionValues` with the [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) partition column with `true` value
    * `part` otherwise
1. The `split` part is the task ID from the given `TaskAttemptContext` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html))
1. The `uuid` part is a random UUID

## Committing Task { #commitTask }

??? note "FileCommitProtocol"

    ```scala
    commitTask(
      taskContext: TaskAttemptContext): TaskCommitMessage
    ```

    `commitTask` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#commitTask)) abstraction.

`commitTask` creates a `TaskCommitMessage` with a [FileAction](#buildActionFromAddedFile) (a [AddCDCFile](AddCDCFile.md) or a [AddFile](AddFile.md) based on [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) virtual partition column) for every [file added](#addedFiles) (if [there were any added successfully](#newTaskTempFile)). Otherwise, `commitTask` creates an empty `TaskCommitMessage`.

!!! note
    A file is added (to the [addedFiles](#addedFiles) internal registry) when `DelayedCommitProtocol` is requested for a [new file (path)](#newTaskTempFile).

### buildActionFromAddedFile { #buildActionFromAddedFile }

```scala
buildActionFromAddedFile(
  f: (Map[String, String], String),
  stat: FileStatus,
  taskContext: TaskAttemptContext): FileAction
```

!!! note
    `f` argument is a pair of the partition values and one of the [file added](#addedFiles).

`buildActionFromAddedFile` removes the [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) virtual partition column and creates a [FileAction](FileAction.md):

* [AddCDCFile](AddCDCFile.md)s for [__is_cdc=true](change-data-feed/CDCReader.md#CDC_PARTITION_COL) partition files
* [AddFile](AddFile.md)s otherwise

## Aborting Job { #abortJob }

??? note "FileCommitProtocol"

    ```scala
    abortJob(
      jobContext: JobContext): Unit
    ```

    `abortJob` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#abortJob)) abstraction.

`abortJob` does nothing (is a noop).

## Aborting Task { #abortTask }

??? note "FileCommitProtocol"

    ```scala
    abortTask(
      taskContext: TaskAttemptContext): Unit
    ```

    `abortTask` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#abortTask)) abstraction.

`abortTask` does nothing (is a noop).

## Setting Up Job { #setupJob }

??? note "FileCommitProtocol"

    ```scala
    setupJob(
      jobContext: JobContext): Unit
    ```

    `setupJob` is part of the `FileCommitProtocol` ([Apache Spark]({{ book.spark_core }}/FileCommitProtocol#setupJob)) abstraction.

`setupJob` does nothing (is a noop).

## <span id="newTaskTempFileAbsPath"> New Temp File (Absolute Path)

??? note "FileCommitProtocol"

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

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.files.DelayedCommitProtocol` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.files.DelayedCommitProtocol=ALL
```

Refer to [Logging](logging.md).
