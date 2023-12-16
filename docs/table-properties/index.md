# Table Properties

Delta Lake uses [DeltaConfigs](../DeltaConfigs.md) with the table properties of delta tables.

Table properties start with `delta.` prefix.

Table Properties can be set on delta tables using [ALTER TABLE SET TBLPROPERTIES](../commands/alter/AlterTableSetPropertiesDeltaCommand.md) or [CREATE TABLE](../commands/CreateDeltaTableCommand.md) SQL commands.

```sql
ALTER TABLE delta_demo
SET TBLPROPERTIES (delta.enableChangeDataFeed = true)
```

```sql
CREATE TABLE delta_demo (id INT, name STRING, age INT)
USING delta
TBLPROPERTIES (delta.enableChangeDataFeed = true)
```

Use `SHOW TBLPROPERTIES` SQL command to review the table properties of a delta table.

```sql
SHOW TBLPROPERTIES delta_demo;
```

## SHOW TBLPROPERTIES

Table properties can be displayed using `SHOW TBLPROPERTIES` SQL command:

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
