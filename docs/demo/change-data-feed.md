---
hide:
  - navigation
---

# Demo: Change Data Feed

This demo shows [Change Data Feed](../change-data-feed/index.md) in action.

## Create Delta Table with Change Data Feed Enabled

=== "SQL"

    ```sql
    CREATE TABLE cdf_demo (id INT, name STRING)
    USING delta
    TBLPROPERTIES (delta.enableChangeDataFeed = true);
    ```

## INSERT INTO

`INSERT INTO`s are not included in Change Data Feed.

```sql
insert into cdf_demo VALUES (0, 'insert into');
```

```sql
select * from cdf_demo;
```

```text
+---+-----------+
|id |name       |
+---+-----------+
|0  |insert into|
+---+-----------+
```

## UPDATE

`UPDATE` is among commands supported by Change Data Feed.

```sql
UPDATE cdf_demo SET name = 'update' WHERE id = 0;
```

```sql
SELECT * FROM cdf_demo;
```

```text
+---+------+
|id |name  |
+---+------+
|0  |update|
+---+------+
```

## _change_data

After executing the above `UPDATE` command, Delta Lake creates a `_change_data` directory (with `cdc` files).

```text
$ tree spark-warehouse/cdf_demo
spark-warehouse/cdf_demo
├── _change_data
│   └── cdc-00000-d5a2730f-de81-4bc7-8bb1-b6c0ff5fec37.c000.snappy.parquet
├── _delta_log
│   ├── 00000000000000000000.json
│   ├── 00000000000000000001.json
│   └── 00000000000000000002.json
├── part-00000-088e28d1-b95f-46e2-812a-5389ae58af28-c000.snappy.parquet
└── part-00000-0947d1e8-a398-4e2c-8afe-db734b84f6b4.c000.snappy.parquet

2 directories, 6 files
```

## CDC-Aware Batch Read

```scala
val changes = spark
  .read
  .format("delta")
  .option("readChangeFeed", "true")
  .option("startingVersion", "0")
  .table("cdf_demo")
```

```scala
changes.show(truncate = false)
```

```text
+---+-----------+----------------+---------------+-----------------------+
|id |name       |_change_type    |_commit_version|_commit_timestamp      |
+---+-----------+----------------+---------------+-----------------------+
|0  |insert into|update_preimage |2              |2022-07-24 18:23:42.102|
|0  |update     |update_postimage|2              |2022-07-24 18:23:42.102|
|0  |insert into|insert          |1              |2022-07-24 18:15:48.892|
+---+-----------+----------------+---------------+-----------------------+
```

## Review and Merge

The following are loose notes (_findings_) while investigating CDF.

### overwrite Save Mode

```scala
spark
  .range(5)
  .write
  .format("delta")
  .mode("overwrite")
  .save("/tmp/delta-xxx")
```

```scala
val startingVersion = 2
val v2 = spark
  .read
  .format("delta")
  .option("readChangeFeed", true)
  .option("startingVersion", startingVersion)
  .load("/tmp/delta-xxx")
```

```text
v2.show(truncate = false)
+---+------------+---------------+-----------------------+
|id |_change_type|_commit_version|_commit_timestamp      |
+---+------------+---------------+-----------------------+
|0  |insert      |2              |2022-07-31 17:51:25.777|
|1  |insert      |2              |2022-07-31 17:51:25.777|
|2  |insert      |2              |2022-07-31 17:51:25.777|
|3  |insert      |2              |2022-07-31 17:51:25.777|
|4  |insert      |2              |2022-07-31 17:51:25.777|
|1  |delete      |2              |2022-07-31 17:51:25.777|
|0  |delete      |2              |2022-07-31 17:51:25.777|
|2  |delete      |2              |2022-07-31 17:51:25.777|
|3  |delete      |2              |2022-07-31 17:51:25.777|
|4  |delete      |2              |2022-07-31 17:51:25.777|
+---+------------+---------------+-----------------------+
```

```text
scala> v2.orderBy('id).show(truncate = false)
+---+------------+---------------+-----------------------+
|id |_change_type|_commit_version|_commit_timestamp      |
+---+------------+---------------+-----------------------+
|0  |delete      |2              |2022-07-31 17:51:25.777|
|0  |insert      |2              |2022-07-31 17:51:25.777|
|1  |insert      |2              |2022-07-31 17:51:25.777|
|1  |delete      |2              |2022-07-31 17:51:25.777|
|2  |insert      |2              |2022-07-31 17:51:25.777|
|2  |delete      |2              |2022-07-31 17:51:25.777|
|3  |insert      |2              |2022-07-31 17:51:25.777|
|3  |delete      |2              |2022-07-31 17:51:25.777|
|4  |insert      |2              |2022-07-31 17:51:25.777|
|4  |delete      |2              |2022-07-31 17:51:25.777|
+---+------------+---------------+-----------------------+
```

### DELETE FROM

```text
sql("DELETE FROM delta.`/tmp/delta-xxx` WHERE id > 3").show
```

```scala
val descHistory = sql("desc history delta.`/tmp/delta-xxx`").select('version, 'operation, 'operationParameters)
```

```text
scala> descHistory.show(truncate = false)
+-------+-----------------+-----------------------------------------------------------------+
|version|operation        |operationParameters                                              |
+-------+-----------------+-----------------------------------------------------------------+
|3      |DELETE           |{predicate -> ["(spark_catalog.delta.`/tmp/delta-xxx`.id > 3L)"]}|
|2      |WRITE            |{mode -> Overwrite, partitionBy -> []}                           |
|1      |SET TBLPROPERTIES|{properties -> {"delta.enableChangeDataFeed":"true"}}            |
|0      |WRITE            |{mode -> ErrorIfExists, partitionBy -> []}                       |
+-------+-----------------+-----------------------------------------------------------------+
```

```scala
val startingVersion = 3
val v3 = spark
  .read
  .format("delta")
  .option("readChangeFeed", true)
  .option("startingVersion", startingVersion)
  .load("/tmp/delta-xxx")
v3.orderBy('id).show(truncate = false)
```

```text
+---+------------+---------------+-----------------------+
|id |_change_type|_commit_version|_commit_timestamp      |
+---+------------+---------------+-----------------------+
|4  |delete      |3              |2022-08-01 10:22:21.402|
+---+------------+---------------+-----------------------+
```

### endingVersion Option

```scala
val startingVersion = 3
val endingVersion = 3
val v3 = spark
  .read
  .format("delta")
  .option("readChangeFeed", true)
  .option("startingVersion", startingVersion)
  .option("endingVersion", endingVersion)
  .load("/tmp/delta-xxx")
v3.orderBy('id).show(truncate = false)
```

```text
+---+------------+---------------+-----------------------+
|id |_change_type|_commit_version|_commit_timestamp      |
+---+------------+---------------+-----------------------+
|4  |delete      |3              |2022-08-01 10:22:21.402|
+---+------------+---------------+-----------------------+
```
