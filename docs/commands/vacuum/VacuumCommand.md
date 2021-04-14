# VacuumCommand Utility

`VacuumCommand` is a concrete [VacuumCommandImpl](VacuumCommandImpl.md) for [garbage collection of a delta table](#gc).

## <span id="gc"> Garbage Collection of Delta Table

```scala
gc(
  spark: SparkSession,
  deltaLog: DeltaLog,
  dryRun: Boolean = true,
  retentionHours: Option[Double] = None,
  clock: Clock = new SystemClock): DataFrame
```

`gc` requests the given `DeltaLog` to [update](../../DeltaLog.md#update) (and give the latest [Snapshot](../../Snapshot.md) of the delta table).

### <span id="gc-deleteBeforeTimestamp"> deleteBeforeTimestamp

`gc`...FIXME

`gc` prints out the following INFO message to the logs:

```text
Starting garbage collection (dryRun = [dryRun]) of untracked files older than [deleteBeforeTimestamp] in [path]
```

### <span id="gc-validFiles"> validFiles

`gc` requests the `Snapshot` for the [state dataset](../../Snapshot.md#state) and defines a function for every action (in a partition) that does the following:

1. FIXME

`gc` converts the mapped state dataset (of actions) into a `DataFrame` with a single `path` column.

## <span id="gc-allFilesAndDirs"> allFilesAndDirs

`gc`...FIXME

`gc` caches the [allFilesAndDirs](#gc-allFilesAndDirs) dataset.

`gc` prints out the following INFO message to the logs:

```text
Deleting untracked files and empty directories in [path]
```

`gc`...FIXME

`gc` prints out the following message to standard output:

```text
Deleted [filesDeleted] files and directories in a total of [dirCounts] directories.
```

`gc`...FIXME

In the end, `gc` unpersists the [allFilesAndDirs](#gc-allFilesAndDirs) dataset.

`gc` is used when:

* `DeltaTableOperations` is requested to [execute vacuum command](../../DeltaTableOperations.md#executeVacuum) (for [DeltaTable.vacuum](../../DeltaTable.md#vacuum) operator)

* [VacuumTableCommand](VacuumTableCommand.md) is executed (for [VACUUM](../../sql/index.md#VACUUM) SQL command)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.VacuumCommand` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.commands.VacuumCommand=ALL
```

Refer to [Logging](../../spark-logging.md).
