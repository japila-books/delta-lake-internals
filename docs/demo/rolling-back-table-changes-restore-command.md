---
hide:
  - navigation
---

# Demo: Rolling Back Table Changes (Restore Command)

This demo shows [RESTORE command](../commands/restore/index.md) in action (using the [SQL variant](../sql/index.md#RESTORE)).

## Logging

Enable logging for [RestoreTableCommand](../commands/restore/RestoreTableCommand.md#logging).

## Start Spark Shell

Start [Spark Shell with Delta Lake](../installation.md#spark-shell).

## Create Delta Table

Let's create a delta table using a mixture of Scala and SQL.

=== "Scala"

    ```scala
    sql("""
    DROP TABLE IF EXISTS delta_demo
    """)
    ```

??? note "CREATE DATASOURCE TABLE"
    Learn more in [CREATE DATASOURCE TABLE]({{ spark.docs }}/sql-ref-syntax-ddl-create-table-datasource.html).

=== "Scala"

    ``` scala
    spark.range(1).writeTo("delta_demo").using("delta").create
    ```

=== "SQL"

    ``` sql
    CREATE TABLE delta_demo
    USING delta
    COMMENT 'Demo delta table'
    AS VALUES 0 t(id)
    ```

```scala
spark.table("delta_demo").show
```

```text
+---+
| id|
+---+
|  0|
+---+
```

This is the first `0`th version of the delta table with just a single row.

=== "Scala"

    ``` scala
    sql("""
    DESC HISTORY delta_demo;
    """)
      .select('version, 'operation, 'operationParameters)
      .show(truncate = false)
    ```

```text
+-------+----------------------+-----------------------------------------------------------------------------+
|version|operation             |operationParameters                                                          |
+-------+----------------------+-----------------------------------------------------------------------------+
|0      |CREATE TABLE AS SELECT|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|
+-------+----------------------+-----------------------------------------------------------------------------+
```

## Create Multiple Table Versions

Let's create multiple versions of the delta table by inserting some new rows.

### INSERT INTO

??? note "INSERT INTO"
    Learn more in [INSERT INTO]({{ spark.docs }}/sql-ref-syntax-dml-insert-into.html#insert-into).

```scala
sql("""
INSERT INTO delta_demo VALUES 1
""")
```

That gives us another version.

### MERGE INTO

Let's use Delta Lake's own [MERGE INTO](../commands/merge/index.md) command.

```scala
sql("""
MERGE INTO delta_demo target
USING (VALUES 2 source(id))
ON target.id = source.id
WHEN NOT MATCHED THEN INSERT *
""")
```

### DESC HISTORY

=== "Scala"

    ``` scala
    sql("""
    DESC HISTORY delta_demo;
    """)
      .select('version, 'operation, 'operationParameters)
      .show(truncate = false)
    ```

```text
+-------+----------------------+----------------------------------------------------------------------------------------------------------------------------------+
|version|operation             |operationParameters                                                                                                               |
+-------+----------------------+----------------------------------------------------------------------------------------------------------------------------------+
|2      |MERGE                 |{predicate -> (target.id = CAST(source.id AS BIGINT)), matchedPredicates -> [], notMatchedPredicates -> [{"actionType":"insert"}]}|
|1      |WRITE                 |{mode -> Append, partitionBy -> []}                                                                                               |
|0      |CREATE TABLE AS SELECT|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}                                                     |
+-------+----------------------+----------------------------------------------------------------------------------------------------------------------------------+
```

## Roll Back with RESTORE

The most recent version is `2` with the following rows:

=== "Scala"

    ```scala
    spark.table("delta_demo").orderBy('id).show
    ```

```text
+---+
| id|
+---+
|  0|
|  1|
|  2|
+---+
```

Let's revert some changes to the delta table using [RESTORE TABLE](../commands/restore/index.md) command.

Let's restore the initial (`0`th) version and review the history of this delta table.

=== "Scala"

    ```scala
    sql("""
    RESTORE delta_demo TO VERSION AS OF 0
    """).show
    ```

You should see the following INFO messages in the logs:

```text
RestoreTableCommand: DELTA: RestoreTableCommand: compute missing files validation  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: DELTA: RestoreTableCommand: compute metrics  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: DELTA: RestoreTableCommand: compute add actions  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: DELTA: RestoreTableCommand: compute remove actions  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: Committed delta #3 to file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo/_delta_log. Wrote 4 actions.
```

`RestoreTableCommand` should also give you some statistics.

```text
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
|table_size_after_restore|num_of_files_after_restore|num_removed_files|num_restored_files|removed_files_size|restored_files_size|
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
|                     774|                         2|                2|                 0|               956|                  0|
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
```

Let's query the rows.

=== "Scala"

    ```scala
    spark.table("delta_demo").show
    ```

```text
+---+
| id|
+---+
|  0|
+---+
```

That looks OK. That's the row of the `0`th version. Use the following query to prove it.

=== "Scala"

    ```scala
    spark.read.format("delta").option("versionAsOf", 0).table("delta_demo").show
    ```

=== "Delta API"

    ```scala
    import org.apache.spark.sql.catalyst.TableIdentifier
    val tid = TableIdentifier("delta_demo")

    import org.apache.spark.sql.delta.DeltaTableIdentifier
    val did = DeltaTableIdentifier(table = Some(tid))

    val log = did.getDeltaLog(spark)
    val snapshotAt = log.getSnapshotAt(0)

    val relation = log.createRelation(snapshotToUseOpt = Some(snapshotAt))
    val df = spark.baseRelationToDataFrame(relation)
    df.show
    ```

```text
+---+
| id|
+---+
|  0|
+---+
```

Let's review the history.

=== "Scala"

    ``` scala
    sql("""
    DESC HISTORY delta_demo;
    """)
      .select('version, 'operation, 'operationParameters)
      .show(truncate = false)
    ```

```text
+-------+----------------------+----------------------------------------------------------------------------------------------------------------------------------+
|version|operation             |operationParameters                                                                                                               |
+-------+----------------------+----------------------------------------------------------------------------------------------------------------------------------+
|3      |RESTORE               |{version -> 0, timestamp -> null}                                                                                                 |
|2      |MERGE                 |{predicate -> (target.id = CAST(source.id AS BIGINT)), matchedPredicates -> [], notMatchedPredicates -> [{"actionType":"insert"}]}|
|1      |WRITE                 |{mode -> Append, partitionBy -> []}                                                                                               |
|0      |CREATE TABLE AS SELECT|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}                                                     |
+-------+----------------------+----------------------------------------------------------------------------------------------------------------------------------+
```

## web UI

Open the [web UI](http://localhost:4040) to review all the Spark jobs submitted.

## RESTORE and ALTER TABLE SET TBLPROPERTIES

What happens when we enable [Change Data Feed](../change-data-feed/index.md) on a delta table and restore the table to the version before the change?

### Enable Change Data Feed

```scala
sql("""
ALTER TABLE delta_demo
SET TBLPROPERTIES (delta.enableChangeDataFeed = true);
""")
```

```scala
sql("""
SHOW TBLPROPERTIES delta_demo;
""").show(truncate = false)
```

```text
+--------------------------+-------+
|key                       |value  |
+--------------------------+-------+
|Type                      |MANAGED|
|delta.enableChangeDataFeed|true   |
|delta.minReaderVersion    |1      |
|delta.minWriterVersion    |4      |
+--------------------------+-------+
```

### History

Let's review the history.

=== "Scala"

    ``` scala
    sql("""
    DESC HISTORY delta_demo;
    """)
      .select('version, 'operation)
      .show(truncate = false)
    ```

```text
+-------+----------------------+
|version|operation             |
+-------+----------------------+
|4      |SET TBLPROPERTIES     |
|3      |RESTORE               |
|2      |MERGE                 |
|1      |WRITE                 |
|0      |CREATE TABLE AS SELECT|
+-------+----------------------+
```

### Start Streaming Query

```scala
spark
  .readStream
  .format("delta")
  .option("readChangeFeed", true)
  .table("delta_demo")
  .writeStream
  .format("console")
  .start
```

You should see the following output.

```text
-------------------------------------------
Batch: 0
-------------------------------------------
+---+------------+---------------+--------------------+
| id|_change_type|_commit_version|   _commit_timestamp|
+---+------------+---------------+--------------------+
|  0|      insert|              4|2022-08-05 12:47:...|
+---+------------+---------------+--------------------+
```

!!! question "FIXME Why is the output printed out?"
    CDF was just enabled so no write was CDF-aware. How is this led to the output?

### Restore to pre-CDF Version

Let's restore to the previous version and see what happens with the streaming query.

=== "Scala"

    ```scala
    sql("""
    RESTORE delta_demo TO VERSION AS OF 3
    """).show
    ```

```text
INFO RestoreTableCommand: DELTA: RestoreTableCommand: compute missing files validation  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
INFO RestoreTableCommand: DELTA: Done
INFO RestoreTableCommand: DELTA: RestoreTableCommand: compute metrics  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
INFO RestoreTableCommand: DELTA: Done
INFO RestoreTableCommand: DELTA: RestoreTableCommand: compute add actions  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
INFO RestoreTableCommand: DELTA: Done
INFO RestoreTableCommand: DELTA: RestoreTableCommand: compute remove actions  (table path file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo)
INFO RestoreTableCommand: DELTA: Done
INFO RestoreTableCommand: Committed delta #5 to file:/Users/jacek/dev/apps/spark-3.2.2-bin-hadoop3.2/spark-warehouse/delta_demo/_delta_log. Wrote 2 actions.
```

```text
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
|table_size_after_restore|num_of_files_after_restore|num_removed_files|num_restored_files|removed_files_size|restored_files_size|
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
|                     774|                         2|                0|                 0|                 0|                  0|
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
```

What's interesting is that the streaming query has produced no data (as if nothing has really happened).

Let's review the history.

=== "Scala"

    ``` scala
    sql("""
    DESC HISTORY delta_demo;
    """)
      .select('version, 'operation)
      .show(truncate = false)
    ```

```text
+-------+----------------------+
|version|operation             |
+-------+----------------------+
|5      |RESTORE               |
|4      |SET TBLPROPERTIES     |
|3      |RESTORE               |
|2      |MERGE                 |
|1      |WRITE                 |
|0      |CREATE TABLE AS SELECT|
+-------+----------------------+
```

Let's review the table properties (and `delta.enableChangeDataFeed` in particular).

```scala
sql("""
SHOW TBLPROPERTIES delta_demo;
""").show(truncate = false)
```

```text
+----------------------+-------+
|key                   |value  |
+----------------------+-------+
|Type                  |MANAGED|
|delta.minReaderVersion|1      |
|delta.minWriterVersion|4      |
+----------------------+-------+
```
