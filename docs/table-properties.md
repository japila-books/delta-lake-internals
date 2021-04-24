# Table Properties

Delta Lake allows setting up [table properties](DeltaConfigs.md) for a custom behaviour of a delta table.

## SHOW TBLPROPERTIES

Table properties can be displayed using `SHOW TBLPROPERTIES` SQL command:

```sql
SHOW TBLPROPERTIES <table_name> [(comma-separated properties)]
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
