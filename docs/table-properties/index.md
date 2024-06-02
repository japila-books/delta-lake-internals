# Table Properties

**Table Properties** are configuration properties that are used on table basis to customize behaviour of delta tables.

[DeltaConfigs](../table-properties/DeltaConfigs.md) holds the supported table properties.

Table Properties use `delta.` prefix.

Table Properties can be set using the following SQL commands:

* [CREATE TABLE](../commands/create-table/index.md) (with `TBLPROPERTIES` clause) for new delta tables

    ```sql
    CREATE TABLE new_delta_table (
        id INT,
        name STRING,
        age INT)
    USING delta
    TBLPROPERTIES (
        delta.enableChangeDataFeed = true)
    ```

* [ALTER TABLE SET TBLPROPERTIES](../commands/alter/AlterTableSetPropertiesDeltaCommand.md) on existing tables

    ```sql
    ALTER TABLE existing_delta_table
    SET TBLPROPERTIES (delta.enableChangeDataFeed = true)
    ```

## SHOW TBLPROPERTIES

Table properties of a delta table can be displayed using `SHOW TBLPROPERTIES` SQL command:

```sql
SHOW TBLPROPERTIES <table_name>
[(comma-separated properties)]
```

---

```scala
sql("SHOW TBLPROPERTIES delta.`/tmp/delta/t1`").show(truncate = false)
```

```text
+----------------------+-----+
|key                   |value|
+----------------------+-----+
|delta.minReaderVersion|1    |
|delta.minWriterVersion|2    |
+----------------------+-----+
```

```scala
sql("SHOW TBLPROPERTIES delta.`/tmp/delta/t1` (delta.minReaderVersion)").show(truncate = false)
```

```text
+----------------------+-----+
|key                   |value|
+----------------------+-----+
|delta.minReaderVersion|1    |
+----------------------+-----+
```

## ALTER TABLE SET TBLPROPERTIES

Table properties can be set a value or unset using `ALTER TABLE` SQL command:

```sql
ALTER TABLE <table_name> SET TBLPROPERTIES (<key>=<value>)
```

```sql
ALTER TABLE table1 UNSET TBLPROPERTIES [IF EXISTS] ('key1', 'key2', ...);
```

---

```text
sql("ALTER TABLE delta.`/tmp/delta/t1` SET TBLPROPERTIES (delta.enableExpiredLogCleanup=true)")
```

```scala
sql("SHOW TBLPROPERTIES delta.`/tmp/delta/t1` (delta.enableExpiredLogCleanup)").show(truncate = false)
```

```text
+-----------------------------+-----+
|key                          |value|
+-----------------------------+-----+
|delta.enableExpiredLogCleanup|true |
+-----------------------------+-----+
```
