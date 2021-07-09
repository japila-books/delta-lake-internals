---
hide:
  - navigation
---

# Demo: DeltaTable, DeltaLog And Snapshots

## Create Delta Table

```scala
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])
```

```scala
val tableName = "users"
```

```scala
sql(s"DROP TABLE IF EXISTS $tableName")
sql(s"""
    | CREATE TABLE $tableName (id bigint, name string, city string, country string)
    | USING delta
    """.stripMargin)
```

```text
scala> spark.catalog.listTables.show
+-----+--------+-----------+---------+-----------+
| name|database|description|tableType|isTemporary|
+-----+--------+-----------+---------+-----------+
|users| default|       null|  MANAGED|      false|
+-----+--------+-----------+---------+-----------+
```

## Access Transaction Log (DeltaLog)

```text
import org.apache.spark.sql.catalyst.TableIdentifier
val tid = TableIdentifier(tableName)

import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, tid)
```

Update the state of the delta table to the most recent version.

```scala
val snapshot = deltaLog.update()
assert(snapshot.version == 0)
```

```scala
val state = snapshot.state
```

```text
scala> :type state
org.apache.spark.sql.Dataset[org.apache.spark.sql.delta.actions.SingleAction]
```

Review the cached RDD for the state snapshot in the Storage tab of the web UI (e.g. http://localhost:4040/storage/).

![Snapshot (Cached RDD) in web UI](../images/demo-snapshot-webui-storage.png)

The "version" part of **Delta Table State** name of the cached RDD should match the version of the snapshot.

Show the changes (actions).

```text
scala> state.show
+----+----+------+--------------------+--------+----+----------+
| txn| add|remove|            metaData|protocol| cdc|commitInfo|
+----+----+------+--------------------+--------+----+----------+
|null|null|  null|                null|  {1, 2}|null|      null|
|null|null|  null|{90316970-5bf1-45...|    null|null|      null|
+----+----+------+--------------------+--------+----+----------+
```

## DeltaTable as DataFrame

### DeltaTable

```scala
import io.delta.tables.DeltaTable
val dt = DeltaTable.forName(tableName)
```

```scala
val h = dt.history.select('version, 'operation, 'operationParameters, 'operationMetrics)
```

```text
scala> h.show(truncate = false)
+-------+------------+-----------------------------------------------------------------------------+----------------+
|version|operation   |operationParameters                                                          |operationMetrics|
+-------+------------+-----------------------------------------------------------------------------+----------------+
|0      |CREATE TABLE|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|{}              |
+-------+------------+-----------------------------------------------------------------------------+----------------+
```

### Converting DeltaTable into DataFrame

```text
val users = dt.toDF
```

```text
scala> users.show
+---+----+----+-------+
| id|name|city|country|
+---+----+----+-------+
+---+----+----+-------+
```

## Add new users

```text
val newUsers = Seq(
  (0L, "Agata", "Warsaw", "Poland"),
  (1L, "Bartosz", "Paris", "France")
).toDF("id", "name", "city", "country")
```

```text
scala> newUsers.show
+---+-------+------+-------+
| id|   name|  city|country|
+---+-------+------+-------+
|  0|  Agata|Warsaw| Poland|
|  1|Bartosz| Paris| France|
+---+-------+------+-------+
```

```text
// newUsers.write.format("delta").mode("append").saveAsTable(name)
newUsers.writeTo(tableName).append
assert(deltaLog.snapshot.version == 1)
```

Review the cached RDD for the state snapshot in the Storage tab of the web UI (e.g. http://localhost:4040/storage/).

Note that the `DataFrame` variant of the delta table has automatically been refreshed (making `REFRESH TABLE` unnecessary).

```text
scala> users.show
+---+-------+------+-------+
| id|   name|  city|country|
+---+-------+------+-------+
|  1|Bartosz| Paris| France|
|  0|  Agata|Warsaw| Poland|
+---+-------+------+-------+
```

```scala
val h = dt.history.select('version, 'operation, 'operationParameters, 'operationMetrics)
```

```text
scala> h.show(truncate = false)
+-------+------------+-----------------------------------------------------------------------------+-----------------------------------------------------------+
|version|operation   |operationParameters                                                          |operationMetrics                                           |
+-------+------------+-----------------------------------------------------------------------------+-----------------------------------------------------------+
|1      |WRITE       |{mode -> Append, partitionBy -> []}                                          |{numFiles -> 2, numOutputBytes -> 2299, numOutputRows -> 2}|
|0      |CREATE TABLE|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|{}                                                         |
+-------+------------+-----------------------------------------------------------------------------+-----------------------------------------------------------+
```
