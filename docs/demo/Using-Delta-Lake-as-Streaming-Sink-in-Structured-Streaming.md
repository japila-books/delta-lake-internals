---
hide:
  - navigation
---

# Demo: Using Delta Lake as Streaming Sink in Structured Streaming

```text
assert(spark.isInstanceOf[org.apache.spark.sql.SparkSession])
assert(spark.version.matches("2.4.[2-4]"), "Delta Lake supports Spark 2.4.2+")

// Input data "format"
case class User(id: Long, name: String, city: String)

// Any streaming data source would work
// Using memory data source
// Gives control over the input stream
implicit val ctx = spark.sqlContext
import org.apache.spark.sql.execution.streaming.MemoryStream
val usersIn = MemoryStream[User]
val users = usersIn.toDF

val deltaLake = "/tmp/delta-lake"
val checkpointLocation = "/tmp/delta-checkpointLocation"
val path = s"$deltaLake/users"
val partitionBy = "city"

// The streaming query that writes out to Delta Lake
val sq = users
  .writeStream
  .format("delta")
  .option("checkpointLocation", checkpointLocation)
  .option("path", path)
  .partitionBy(partitionBy)
  .start

// TIP: You could use git to version the path directory
//      and track the changes of every micro-batch

// TIP: Use web UI to monitor execution, e.g. http://localhost:4040

// FIXME: Use DESCRIBE HISTORY every micro-batch

val batch1 = Seq(
  User(0, "Agata", "Warsaw"),
  User(1, "Jacek", "Warsaw"))
val offset = usersIn.addData(batch1)
sq.processAllAvailable()

val history = s"DESCRIBE HISTORY delta.`$path`"
val clmns = Seq($"version", $"timestamp", $"operation", $"operationParameters", $"isBlindAppend")

val h = sql(history).select(clmns: _*).orderBy($"version".asc)
scala> h.show(truncate = false)
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
|version|timestamp          |operation       |operationParameters                                                                  |isBlindAppend|
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
|0      |2019-12-06 10:06:20|STREAMING UPDATE|[outputMode -> Append, queryId -> f3990048-f0b7-48b6-9bf6-397004c36e53, epochId -> 0]|true         |
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+

val batch2 = Seq(
  User(2, "Bartek", "Paris"),
  User(3, "Jacek", "Paris"))
val offset = usersIn.addData(batch2)
sq.processAllAvailable()

// You have to execute the history SQL command again
// It materializes immediately with whatever data is available at the time
val h = sql(history).select(clmns: _*).orderBy($"version".asc)
scala> h.show(truncate = false)
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
|version|timestamp          |operation       |operationParameters                                                                  |isBlindAppend|
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
|0      |2019-12-06 10:06:20|STREAMING UPDATE|[outputMode -> Append, queryId -> f3990048-f0b7-48b6-9bf6-397004c36e53, epochId -> 0]|true         |
|1      |2019-12-06 10:13:27|STREAMING UPDATE|[outputMode -> Append, queryId -> f3990048-f0b7-48b6-9bf6-397004c36e53, epochId -> 1]|true         |
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+

val batch3 = Seq(
  User(4, "Gorazd", "Ljubljana"))
val offset = usersIn.addData(batch3)
sq.processAllAvailable()

// Let's use DeltaTable API instead

import io.delta.tables.DeltaTable
val usersDT = DeltaTable.forPath(path)

val h = usersDT.history.select(clmns: _*).orderBy($"version".asc)
scala> h.show(truncate = false)
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
|version|timestamp          |operation       |operationParameters                                                                  |isBlindAppend|
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
|0      |2019-12-06 10:06:20|STREAMING UPDATE|[outputMode -> Append, queryId -> f3990048-f0b7-48b6-9bf6-397004c36e53, epochId -> 0]|true         |
|1      |2019-12-06 10:13:27|STREAMING UPDATE|[outputMode -> Append, queryId -> f3990048-f0b7-48b6-9bf6-397004c36e53, epochId -> 1]|true         |
|2      |2019-12-06 10:20:56|STREAMING UPDATE|[outputMode -> Append, queryId -> f3990048-f0b7-48b6-9bf6-397004c36e53, epochId -> 2]|true         |
+-------+-------------------+----------------+-------------------------------------------------------------------------------------+-------------+
```
