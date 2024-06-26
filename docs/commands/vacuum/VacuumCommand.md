---
title: VacuumCommand
---

# VacuumCommand Utility

`VacuumCommand` is a concrete [VacuumCommandImpl](VacuumCommandImpl.md) for [garbage collection of a delta table](#gc) for the following:

* [DeltaTable.vacuum](../../DeltaTable.md#vacuum) operator (as `DeltaTableOperations` is requested to [execute vacuum command](../../DeltaTableOperations.md#executeVacuum))

* [VACUUM](../../sql/index.md#VACUUM) SQL command (as [VacuumTableCommand](VacuumTableCommand.md) is executed)

## Garbage Collection of Delta Table { #gc }

```scala
gc(
  spark: SparkSession,
  deltaLog: DeltaLog,
  dryRun: Boolean = true,
  retentionHours: Option[Double] = None,
  clock: Clock = new SystemClock): DataFrame
```

`gc` requests the given `DeltaLog` to [update](../../DeltaLog.md#update) (and hence give the latest [Snapshot](../../Snapshot.md) of the delta table).

### retentionMillis { #gc-retentionMillis }

`gc` converts the [retention hours](#retentionHours) to milliseconds and [checkRetentionPeriodSafety](#checkRetentionPeriodSafety) (with [deletedFileRetentionDuration](../../DeltaLog.md#tombstoneRetentionMillis) table configuration).

### <span id="gc-deleteBeforeTimestamp"> Timestamp to Delete Files Before { #deleteBeforeTimestamp }

`gc` determines the timestamp to delete files before based on the [retentionMillis](#retentionMillis) (if defined) or defaults to [minFileRetentionTimestamp](../../DeltaLog.md#minFileRetentionTimestamp) table configuration.

`gc` prints out the following INFO message to the logs (with the [path](../../DeltaLog.md#dataPath) of the given [DeltaLog](../../DeltaLog.md)):

```text
Starting garbage collection (dryRun = [dryRun]) of untracked files older than [deleteBeforeTimestamp] in [path]
```

### Valid Files { #gc-validFiles }

`gc` requests the `Snapshot` for the [state dataset](../../Snapshot.md#state) and maps over partitions (`Dataset.mapPartitions`) with a map function that does the following (for every [Action](../../Action.md) in a partition of [SingleAction](../../SingleAction.md)s):

1. Skips [RemoveFile](../../RemoveFile.md)s with the [deletion timestamp](../../RemoveFile.md#delTimestamp) after the [timestamp to delete files before](#deleteBeforeTimestamp)
1. Adds the [path](../../FileAction.md#path) of [FileAction](../../FileAction.md)s (that live inside the directory of the table) with all subdirectories
1. Skips other actions

`gc` converts the mapped state dataset into a `DataFrame` with a single `path` column.

!!! note
    There is no DataFrame action executed so no processing yet (using Spark).

### All Files and Directories Dataset { #gc-allFilesAndDirs }

`gc` [finds all the files and directories](../../DeltaFileOperations.md#recursiveListDirs) (recursively) in the [data path](../../DeltaLog.md#dataPath) (with `spark.sql.sources.parallelPartitionDiscovery.parallelism` number of file listing tasks).

### Caching All Files and Directories Dataset { #gc-allFilesAndDirs-cache }

`gc` caches the [allFilesAndDirs](#gc-allFilesAndDirs) dataset.

### <span id="gc-dirCounts"> Number of Directories { #dirCounts }

`gc` counts the number of directories (as the count of the rows with `isDir` column being `true` in the [allFilesAndDirs](#allFilesAndDirs) dataset).

!!! note
    This step submits a Spark job for `Dataset.count`.

### <span id="gc-diff"> Paths Dataset { #diff }

`gc` creates a Spark SQL query to count `path`s of the [allFilesAndDirs](#allFilesAndDirs) with files with the `modificationTime` ealier than the [deleteBeforeTimestamp](#deleteBeforeTimestamp) and the directories (`isDir`s). That creates a `DataFrame` of `path` and `count` columns.

`gc` uses left-anti join of the counted path `DataFrame` with the [validFiles](#validFiles) on `path`.

`gc` filters out paths with `count` more than `1` and selects `path`.

### Dry Run { #gc-dryRun }

`gc` counts the rows in the [paths Dataset](#diff) for the number of files and directories that are safe to delete (_numFiles_).

!!! note
    This step submits a Spark job for `Dataset.count`.

`gc` prints out the following message to the console (with the [dirCounts](#dirCounts)):

```text
Found [numFiles] files and directories in a total of [dirCounts] directories that are safe to delete.
```

In the end, `gc` converts the paths to Hadoop DFS format and creates a `DataFrame` with a single `path` column.

### Deleting Files and Directories { #gc-delete }

`gc` prints out the following INFO message to the logs:

```text
Deleting untracked files and empty directories in [path]
```

`gc` [deletes](VacuumCommandImpl.md#delete) the untracked files and empty directories (with parallel delete enabled flag based on [spark.databricks.delta.vacuum.parallelDelete.enabled](../../configuration-properties/DeltaSQLConf.md#vacuum.parallelDelete.enabled) configuration property).

`gc` prints out the following message to standard output (with the [dirCounts](#dirCounts)):

```text
Deleted [filesDeleted] files and directories in a total of [dirCounts] directories.
```

In the end, `gc` creates a `DataFrame` with a single `path` column with just the [data path](../../DeltaLog.md#dataPath) of the delta table to vacuum.

### Unpersist All Files and Directories Dataset { #gc-allFilesAndDirs-unpersist }

`gc` unpersists the [allFilesAndDirs](#gc-allFilesAndDirs) dataset.

### checkRetentionPeriodSafety { #checkRetentionPeriodSafety }

```scala
checkRetentionPeriodSafety(
  spark: SparkSession,
  retentionMs: Option[Long],
  configuredRetention: Long): Unit
```

`checkRetentionPeriodSafety`...FIXME

### getValidFilesFromSnapshot { #getValidFilesFromSnapshot }

```scala
getValidFilesFromSnapshot(
  spark: SparkSession,
  basePath: String,
  snapshot: Snapshot,
  retentionMillis: Option[Long],
  hadoopConf: Broadcast[SerializableConfiguration],
  clock: Clock,
  checkAbsolutePathOnly: Boolean): DataFrame
```

`getValidFilesFromSnapshot`...FIXME

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.VacuumCommand` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.commands.VacuumCommand=ALL
```

Refer to [Logging](../../logging.md).
