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

```scala
val tableName = "demo01"
sql(s"DROP TABLE IF EXISTS $tableName")
```

??? note "CREATE DATASOURCE TABLE"
    Learn more in [CREATE DATASOURCE TABLE]({{ spark.docs }}/sql-ref-syntax-ddl-create-table-datasource.html).

=== "Scala"

    ``` scala
    spark.range(1).writeTo(tableName).using("delta").create
    ```

=== "SQL"

    ``` sql
    CREATE TABLE $tableName
    USING delta
    COMMENT 'Demo delta table'
    AS VALUES 0 t(id)
    ```

```scala
spark.table(tableName).show
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
    sql(s"desc history $tableName")
      .select('version, 'timestamp, 'operation)
      .show(truncate = false)
    ```

=== "SQL"

    ``` sql
    SELECT version, timestamp, operation
    FROM (DESC HISTORY $tableName)
    ```

```text
+-------+-----------------------+----------------------+
|version|timestamp              |operation             |
+-------+-----------------------+----------------------+
|0      |2022-06-07 11:37:28.707|CREATE TABLE AS SELECT|
+-------+-----------------------+----------------------+
```

## Create Multiple Table Versions

Let's create multiple versions of the delta table by inserting some new rows.

### INSERT INTO

??? note "INSERT INTO"
    Learn more in [INSERT INTO]({{ spark.docs }}/sql-ref-syntax-dml-insert-into.html#insert-into).

```scala
sql(s"INSERT INTO $tableName VALUES 1")
```

That gives us another version.

### MERGE INTO

Let's use Delta Lake's own [MERGE INTO](../commands/merge/index.md) command.

```scala
sql(s"MERGE INTO $tableName USING (VALUES 2 t(id)) ON demo01.id = t.id WHEN NOT MATCHED THEN INSERT *")
```

### DESC HISTORY

=== "Scala"

    ``` scala
    sql(s"desc history $tableName")
      .select('version, 'timestamp, 'operation)
      .show(truncate = false)
    ```

=== "SQL"

    ``` sql
    SELECT version, timestamp, operation
    FROM (DESC HISTORY $tableName)
    ```

```text
+-------+-----------------------+----------------------+
|version|timestamp              |operation             |
+-------+-----------------------+----------------------+
|2      |2022-06-07 11:38:52.448|MERGE                 |
|1      |2022-06-07 11:38:42.148|WRITE                 |
|0      |2022-06-07 11:37:28.707|CREATE TABLE AS SELECT|
+-------+-----------------------+----------------------+
```

## Roll Back with RESTORE

The most recent version is `2` with the following rows:

```scala
spark.table(tableName).show
```

```text
+---+
| id|
+---+
|  2|
|  0|
|  1|
+---+
```

Let's revert some changes to the delta table using [RESTORE TABLE](../commands/restore/index.md) command.

Let's restore the initial (`0`th) version and review the history of this delta table.

```scala
sql(s"RESTORE TABLE $tableName TO VERSION AS OF 0").show
```

You should see the following INFO messages in the logs:

```text
RestoreTableCommand: DELTA: RestoreTableCommand: compute missing files validation  (table path file:/Users/jacek/dev/oss/spark/spark-warehouse/demo01)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: DELTA: RestoreTableCommand: compute metrics  (table path file:/Users/jacek/dev/oss/spark/spark-warehouse/demo01)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: DELTA: RestoreTableCommand: compute add actions  (table path file:/Users/jacek/dev/oss/spark/spark-warehouse/demo01)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: DELTA: RestoreTableCommand: compute remove actions  (table path file:/Users/jacek/dev/oss/spark/spark-warehouse/demo01)
RestoreTableCommand: DELTA: Done
RestoreTableCommand: Committed delta #3 to file:/Users/jacek/dev/oss/spark/spark-warehouse/demo01/_delta_log. Wrote 4 actions.
```

`RestoreTableCommand` should also give you command statistics.

```text
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
|table_size_after_restore|num_of_files_after_restore|num_removed_files|num_restored_files|removed_files_size|restored_files_size|
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
|                     774|                         2|                2|                 0|               956|                  0|
+------------------------+--------------------------+-----------------+------------------+------------------+-------------------+
```

Let's query the rows.

```scala
spark.table(tableName).show
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
    spark.read.format("delta").option("versionAsOf", 0).table(tableName).show
    ```

=== "Delta-specific"

    ```scala
    import org.apache.spark.sql.catalyst.TableIdentifier
    val tid = TableIdentifier(tableName)

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

```scala
sql(s"desc history $tableName").select('version, 'timestamp, 'operation).show(truncate = false)
```

```text
+-------+-----------------------+----------------------+
|version|timestamp              |operation             |
+-------+-----------------------+----------------------+
|3      |2022-06-07 11:40:09.496|RESTORE               |
|2      |2022-06-07 11:38:52.448|MERGE                 |
|1      |2022-06-07 11:38:42.148|WRITE                 |
|0      |2022-06-07 11:37:28.707|CREATE TABLE AS SELECT|
+-------+-----------------------+----------------------+
```

## web UI

Open the [web UI](http://localhost:4040) to review all the Spark jobs submitted.
