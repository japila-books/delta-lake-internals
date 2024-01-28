---
hide:
  - navigation
---

# Demo: Vacuum

This demo shows [VACUUM](../commands/vacuum/index.md) command in action.

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
|0      |WRITE    |{numFiles -> 4, numOutputRows -> 4, numOutputBytes -> 1912}|
+-------+---------+-----------------------------------------------------------+
```

Alternatively, you could use [DESCRIBE HISTORY](../commands/describe-history/index.md) SQL command.

```scala
sql(s"DESC HISTORY delta.`$path`")
  .select('version, 'operation, 'operationMetrics)
  .show(truncate = false)
```

```text
+-------+---------+-----------------------------------------------------------+
|version|operation|operationMetrics                                           |
+-------+---------+-----------------------------------------------------------+
|0      |WRITE    |{numFiles -> 4, numOutputRows -> 4, numOutputBytes -> 1912}|
+-------+---------+-----------------------------------------------------------+
```

## Delete All

Delete all data in the delta table, effectively creating the second version.

=== "SQL"

    ```scala
    sql(s"""
    DELETE FROM delta.`$path`
    """).show(truncate = false)
    ```

=== "Scala"

    ```scala
    import io.delta.tables.DeltaTable
    DeltaTable.forPath(path).delete
    ```

```text
+-----------------+
|num_affected_rows|
+-----------------+
|4                |
+-----------------+
```

Display the available versions of the delta table.

=== "SQL"

    ```scala
    sql(s"""
    DESC HISTORY delta.`$path`
    """)
      .select('version, 'operation, 'operationMetrics)
      .show(truncate = false)
    ```

=== "Scala"

    ```scala
    val history = dt.history.select('version, 'operation, 'operationMetrics)
    history.show(truncate = false)
    ```

```text
+-------+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|version|operation|operationMetrics                                                                                                                                                                                                           |
+-------+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|1      |DELETE   |{numRemovedFiles -> 4, numRemovedBytes -> 1912, numCopiedRows -> 0, numAddedChangeFiles -> 0, executionTimeMs -> 1866, numDeletedRows -> 4, scanTimeMs -> 1860, numAddedFiles -> 0, numAddedBytes -> 0, rewriteTimeMs -> 0}|
|0      |WRITE    |{numFiles -> 4, numOutputRows -> 4, numOutputBytes -> 1912}                                                                                                                                                                |
+-------+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

## Vacuum DRY RUN (IllegalArgumentException)

Let's vacuum the delta table (in `DRY RUN` mode).

=== "SQL"

    ```scala
    sql(s"""
    VACUUM delta.`$path` RETAIN 0 HOURS DRY RUN
    """)
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
* [deletedFileRetentionDuration](../table-properties/DeltaConfigs.md#TOMBSTONE_RETENTION) table property

## Vacuum DRY RUN

### retentionDurationCheck.enabled Configuration Property

Turn the [spark.databricks.delta.retentionDurationCheck.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_VACUUM_RETENTION_CHECK_ENABLED) configuration property off and give the `VACUUM` command a go again.

=== "SQL"

    ```scala
    sql("""
    SET spark.databricks.delta.retentionDurationCheck.enabled=false
    """)
      .show(truncate = false)
    ```

```text
+-----------------------------------------------------+-----+
|key                                                  |value|
+-----------------------------------------------------+-----+
|spark.databricks.delta.retentionDurationCheck.enabled|false|
+-----------------------------------------------------+-----+
```

=== "SQL"

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

Let's [DESCRIBE DETAIL](../commands/describe-detail/index.md) to review the current table properties (incl. [deletedFileRetentionDuration](../table-properties/DeltaConfigs.md#TOMBSTONE_RETENTION)).

```scala
val tid = s"delta.`$path`"
```

=== "SQL"

    ```scala
    sql(s"""
    DESCRIBE DETAIL $tid
    """)
      .select('format, 'location, 'properties)
      .show(truncate = false)
    ```

```text
+------+------------------+----------+
|format|location          |properties|
+------+------------------+----------+
|delta |file:/tmp/delta/t1|{}        |
+------+------------------+----------+
```

Prefix the `deletedFileRetentionDuration` table property with `delta.` for [ALTER TABLE](../commands/alter/AlterDeltaTableCommand.md) to accept it as a Delta property.

=== "SQL"

    ```scala
    sql(s"""
    ALTER TABLE $tid
    SET TBLPROPERTIES (
      delta.deletedFileRetentionDuration = '0 hours'
    )
    """)
    ```

Use [DESCRIBE DETAIL](../commands/describe-detail/index.md) SQL command.

=== "SQL"

    ```scala
    sql(s"""
    DESCRIBE DETAIL $tid
    """)
      .select('format, 'location, 'properties)
      .show(truncate = false)
    ```

```text
+------+------------------+-----------------------------------------------+
|format|location          |properties                                     |
+------+------------------+-----------------------------------------------+
|delta |file:/tmp/delta/t1|{delta.deletedFileRetentionDuration -> 0 hours}|
+------+------------------+-----------------------------------------------+
```

Display the available versions of the delta table and note that `ALTER TABLE` gave a new version. This time you include `operationParameters` column (not `operationMetrics` as less important).

=== "Scala"

    ```scala
    dt.history
      .select('version, 'operation, 'operationParameters)
      .history.show(truncate = false)
    ```

```text
+-------+-----------------+----------------------------------------------------------------+
|version|operation        |operationParameters                                             |
+-------+-----------------+----------------------------------------------------------------+
|2      |SET TBLPROPERTIES|{properties -> {"delta.deletedFileRetentionDuration":"0 hours"}}|
|1      |DELETE           |{predicate -> ["true"]}                                         |
|0      |WRITE            |{mode -> ErrorIfExists, partitionBy -> ["p"]}                   |
+-------+-----------------+----------------------------------------------------------------+
```

You can access the table properties (_table configuration_) using [DeltaLog](../DeltaLog.md) Scala API.

```scala
import org.apache.spark.sql.delta.DeltaLog
val log = DeltaLog.forTable(spark, path)
log.snapshot.metadata.configuration
```

Revert the latest change to `spark.databricks.delta.retentionDurationCheck.enabled` and turn it on back.

```scala
spark.conf.set("spark.databricks.delta.retentionDurationCheck.enabled", true)
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
│   ├── part-00002-81e59926-8644-4bd4-8984-5a9e889911e1.c000.snappy.parquet
│   └── part-00008-27bfe3eb-1812-4861-908a-3a727f2ad9cb.c000.snappy.parquet
└── p=1
    ├── part-00005-ef9a916a-12b9-4f91-a004-c45e1f21ed81.c000.snappy.parquet
    └── part-00011-c7403108-0438-401b-b13f-41d70d786024.c000.snappy.parquet

4 directories, 7 files
```

## Vacuum Retain 0 Hours

Let's clean up (_vacuum_) the delta table entirely, effectively deleting all the data files physically from disk.

Back in `spark-shell`, run `VACUUM` SQL command again, but this time with no `DRY RUN`.

=== "SQL"

    ```scala
    sql(s"""
    VACUUM delta.`$path`
    RETAIN 0 HOURS
    """)
      .show(truncate = false)
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
│   ├── 00000000000000000002.json
│   ├── 00000000000000000003.json
│   └── 00000000000000000004.json
├── p=0
└── p=1

4 directories, 5 files
```

Switch to `spark-shell` and display the available versions of the delta table. There should really be no change compared to the last time you executed it.

=== "Scala"

    ```scala
    dt.history
      .select('version, 'operation, 'operationParameters)
      .show(truncate = false)
    ```

As of Delta Lake 2.3.0, [VACUUM](../commands/vacuum/index.md) operations are recorded in the transaction log.

```text
+-------+-----------------+-------------------------------------------------------------------------------------------+
|version|operation        |operationParameters                                                                        |
+-------+-----------------+-------------------------------------------------------------------------------------------+
|4      |VACUUM END       |{status -> COMPLETED}                                                                      |
|3      |VACUUM START     |{retentionCheckEnabled -> true, defaultRetentionMillis -> 0, specifiedRetentionMillis -> 0}|
|2      |SET TBLPROPERTIES|{properties -> {"delta.deletedFileRetentionDuration":"0 hours"}}                           |
|1      |DELETE           |{predicate -> ["true"]}                                                                    |
|0      |WRITE            |{mode -> ErrorIfExists, partitionBy -> ["p"]}                                              |
+-------+-----------------+-------------------------------------------------------------------------------------------+
```
