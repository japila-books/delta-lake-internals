---
hide:
  - navigation
---

# Demo: Vacuum

This demo shows [vacuum](../commands/vacuum/index.md) command in action.

## Start Spark Shell

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```

## Create Delta Table

```scala
val path = "/tmp/delta/t1"
```

Make sure that there is no delta table at the location. Remove it if exists and start over.

```text
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, path)
assert(deltaLog.tableExists == false)
```

Create a demo delta table (using Scala API). Write some data to the delta table, effectively creating the first version.

```scala
spark.range(4)
  .withColumn("p", 'id % 2)
  .write
  .format("delta")
  .partitionBy("p")
  .save(path)
```

Display the available versions of the delta table.

```scala
import io.delta.tables.DeltaTable
val dt = DeltaTable.forPath(path)
```

```scala
val history = dt.history.select('version, 'operation, 'operationMetrics)
history.show(truncate = false)
```

```text
+-------+---------+-----------------------------------------------------------+
|version|operation|operationMetrics                                           |
+-------+---------+-----------------------------------------------------------+
|0      |WRITE    |[numFiles -> 4, numOutputBytes -> 1852, numOutputRows -> 4]|
+-------+---------+-----------------------------------------------------------+
```

## Delete All

Delete all data in the delta table, effectively creating the second version.

```scala
import io.delta.tables.DeltaTable
DeltaTable.forPath(path).delete
```

Display the available versions of the delta table.

```scala
val history = dt.history.select('version, 'operation, 'operationMetrics)
history.show(truncate = false)
```

```text
+-------+---------+-----------------------------------------------------------+
|version|operation|operationMetrics                                           |
+-------+---------+-----------------------------------------------------------+
|1      |DELETE   |[numRemovedFiles -> 4]                                     |
|0      |WRITE    |[numFiles -> 4, numOutputBytes -> 1852, numOutputRows -> 4]|
+-------+---------+-----------------------------------------------------------+
```

## Vacuum DRY RUN (IllegalArgumentException)

Let's vacuum the delta table (in `DRY RUN` mode).

```scala
sql(s"VACUUM delta.`$path` RETAIN 0 HOURS DRY RUN")
```

```text
java.lang.IllegalArgumentException: requirement failed: Are you sure you would like to vacuum files with such a low retention period? If you have
writers that are currently writing to this table, there is a risk that you may corrupt the
state of your Delta table.

If you are certain that there are no operations being performed on this table, such as
insert/upsert/delete/optimize, then you may turn off this check by setting:
spark.databricks.delta.retentionDurationCheck.enabled = false

If you are not sure, please use a value not less than "168 hours".
```

Attempting to vacuum the delta table (even with `DRY RUN`) gives an `IllegalArgumentException` because of the default values of the following:

* [spark.databricks.delta.retentionDurationCheck.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_VACUUM_RETENTION_CHECK_ENABLED) configuration property
* [deletedFileRetentionDuration](../DeltaConfigs.md#TOMBSTONE_RETENTION) table property

## Vacuum DRY RUN

### retentionDurationCheck.enabled Configuration Property

Turn the [spark.databricks.delta.retentionDurationCheck.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_VACUUM_RETENTION_CHECK_ENABLED) configuration property off and give the `VACUUM` command a go again.

```scala
spark.conf.set("spark.databricks.delta.retentionDurationCheck.enabled", false)
```

```scala
val q = sql(s"VACUUM delta.`$path` RETAIN 0 HOURS DRY RUN")
```

You should see the following message in the console:

```text
Found 4 files and directories in a total of 3 directories that are safe to delete.
```

The result `DataFrame` is the paths that are safe to delete which are all of the data files in the delta table.

```scala
q.show(truncate = false)
```

```text
+------------------------------------------------------------------------------------------+
|path                                                                                      |
+------------------------------------------------------------------------------------------+
|file:/tmp/delta/t1/p=0/part-00011-40983cc5-18bf-4d91-8b7b-eb805b8c862d.c000.snappy.parquet|
|file:/tmp/delta/t1/p=1/part-00015-9576ff56-28f7-410e-8ea3-e43352a5083c.c000.snappy.parquet|
|file:/tmp/delta/t1/p=0/part-00003-8e300857-ad6a-4889-b944-d31624a8024f.c000.snappy.parquet|
|file:/tmp/delta/t1/p=1/part-00007-4fba265a-0884-44c3-84ed-4e9aee524e3a.c000.snappy.parquet|
+------------------------------------------------------------------------------------------+
```

### deletedFileRetentionDuration Table Property

Let's `DESCRIBE DETAIL` to review the current table properties (incl. [deletedFileRetentionDuration](../DeltaConfigs.md#TOMBSTONE_RETENTION)).

```scala
val tid = s"delta.`$path`"
```

```scala
val detail = sql(s"DESCRIBE DETAIL $tid").select('format, 'location, 'properties)
detail.show(truncate = false)
```

```text
+------+------------------+----------+
|format|location          |properties|
+------+------------------+----------+
|delta |file:/tmp/delta/t1|[]        |
+------+------------------+----------+
```

Prefix the `deletedFileRetentionDuration` table property with `delta.` for `ALTER TABLE` to accept it as a Delta property.

```scala
sql(s"ALTER TABLE $tid SET TBLPROPERTIES (delta.deletedFileRetentionDuration = '0 hours')")
```

```scala
val detail = sql(s"DESCRIBE DETAIL $tid").select('format, 'location, 'properties)
detail.show(truncate = false)
```

```text
+------+------------------+-----------------------------------------------+
|format|location          |properties                                     |
+------+------------------+-----------------------------------------------+
|delta |file:/tmp/delta/t1|[delta.deletedFileRetentionDuration -> 0 hours]|
+------+------------------+-----------------------------------------------+
```

Display the available versions of the delta table and note that `ALTER TABLE` gives a new version. This time you include `operationParameters` column (not `operationMetrics` as less important).

```scala
val history = dt.history.select('version, 'operation, 'operationParameters)
history.show(truncate = false)
```

```text
+-------+-----------------+----------------------------------------------------------------+
|version|operation        |operationParameters                                             |
+-------+-----------------+----------------------------------------------------------------+
|2      |SET TBLPROPERTIES|[properties -> {"delta.deletedFileRetentionDuration":"0 hours"}]|
|1      |DELETE           |[predicate -> []]                                               |
|0      |WRITE            |[mode -> ErrorIfExists, partitionBy -> ["p"]]                   |
+-------+-----------------+----------------------------------------------------------------+
```

You can access the table properties (_table configuration_) using [DeltaLog](../DeltaLog.md) Scala API.

```scala
import org.apache.spark.sql.delta.DeltaLog
val log = DeltaLog.forTable(spark, path)
log.snapshot.metadata.configuration
```

Let's revert the latest change to `spark.databricks.delta.retentionDurationCheck.enabled` and turn it on back.

```scala
spark.conf.set("spark.databricks.delta.retentionDurationCheck.enabled", true)
```

```scala
val q = sql(s"VACUUM delta.`$path` RETAIN 0 HOURS DRY RUN")
```

You should see the following message in the console:

```text
Found 4 files and directories in a total of 3 directories that are safe to delete.
```

The result `DataFrame` is the paths that are safe to delete which are all of the data files in the delta table.

```scala
q.show(truncate = false)
```

```text
+------------------------------------------------------------------------------------------+
|path                                                                                      |
+------------------------------------------------------------------------------------------+
|file:/tmp/delta/t1/p=0/part-00011-40983cc5-18bf-4d91-8b7b-eb805b8c862d.c000.snappy.parquet|
|file:/tmp/delta/t1/p=1/part-00015-9576ff56-28f7-410e-8ea3-e43352a5083c.c000.snappy.parquet|
|file:/tmp/delta/t1/p=0/part-00003-8e300857-ad6a-4889-b944-d31624a8024f.c000.snappy.parquet|
|file:/tmp/delta/t1/p=1/part-00007-4fba265a-0884-44c3-84ed-4e9aee524e3a.c000.snappy.parquet|
+------------------------------------------------------------------------------------------+
```

## Tree Delta Table Directory

In a terminal (outside `spark-shell`) run `tree` or a similar command to review what the directory of the delta table looks like.

```text
tree /tmp/delta/t1
```

```text
/tmp/delta/t1
├── _delta_log
│   ├── 00000000000000000000.json
│   ├── 00000000000000000001.json
│   └── 00000000000000000002.json
├── p=0
│   ├── part-00003-8e300857-ad6a-4889-b944-d31624a8024f.c000.snappy.parquet
│   └── part-00011-40983cc5-18bf-4d91-8b7b-eb805b8c862d.c000.snappy.parquet
└── p=1
    ├── part-00007-4fba265a-0884-44c3-84ed-4e9aee524e3a.c000.snappy.parquet
    └── part-00015-9576ff56-28f7-410e-8ea3-e43352a5083c.c000.snappy.parquet

3 directories, 7 files
```

## Retain 0 Hours

Let's clean up (_vacuum_) the delta table entirely, effectively deleting all the data files physically from disk.

Back in `spark-shell`, run `VACUUM` SQL command. Note that you're going to use it with no `DRY RUN`.

```scala
sql(s"VACUUM delta.`$path` RETAIN 0 HOURS").show(truncate = false)
```

```text
Deleted 4 files and directories in a total of 3 directories.
+------------------+
|path              |
+------------------+
|file:/tmp/delta/t1|
+------------------+
```

In a terminal (outside `spark-shell`), run `tree` or a similar command to review what the directory of the delta table looks like.

```text
tree /tmp/delta/t1
```

```text
/tmp/delta/t1
├── _delta_log
│   ├── 00000000000000000000.json
│   ├── 00000000000000000001.json
│   └── 00000000000000000002.json
├── p=0
└── p=1

3 directories, 3 files
```

Switch to `spark-shell` and display the available versions of the delta table. There should really be no change compared to the last time you executed it.

```scala
val history = dt.history.select('version, 'operation, 'operationParameters)
history.show(truncate = false)
```

```text
+-------+-----------------+----------------------------------------------------------------+
|version|operation        |operationParameters                                             |
+-------+-----------------+----------------------------------------------------------------+
|2      |SET TBLPROPERTIES|[properties -> {"delta.deletedFileRetentionDuration":"0 hours"}]|
|1      |DELETE           |[predicate -> []]                                               |
|0      |WRITE            |[mode -> ErrorIfExists, partitionBy -> ["p"]]                   |
+-------+-----------------+----------------------------------------------------------------+
```
