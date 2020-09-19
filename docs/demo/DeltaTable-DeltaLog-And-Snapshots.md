= Demo: DeltaTable, DeltaLog And Snapshots

NOTE: Use Converting-Parquet-Dataset-Into-Delta-Format.adoc[Demo: Converting Parquet Dataset Into Delta Format] to create the delta table for the demo.

[source, scala]
----
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

val dataPath = "/tmp/delta/users"
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)

// Review the cached RDD for the state (snapshot)
// Use http://localhost:4040/storage/

assert(deltaLog.snapshot.version == 0)

// Show the changes (actions)
scala> deltaLog.snapshot.state.toDF.show
+----+--------------------+------+--------------------+--------+----------+
| txn|                 add|remove|            metaData|protocol|commitInfo|
+----+--------------------+------+--------------------+--------+----------+
|null|                null|  null|                null|  [1, 2]|      null|
|null|                null|  null|[3799b291-dbfa-4f...|    null|      null|
|null|[city=Paris/count...|  null|                null|    null|      null|
|null|[city=Warsaw/coun...|  null|                null|    null|      null|
|null|[city=Warsaw/coun...|  null|                null|    null|      null|
+----+--------------------+------+--------------------+--------+----------+

val dt = DeltaTable.forPath(deltaLog.dataPath.toString)
scala> dt.history.show
+-------+-------------------+------+--------+---------+--------------------+----+--------+---------+-----------+--------------+-------------+
|version|          timestamp|userId|userName|operation| operationParameters| job|notebook|clusterId|readVersion|isolationLevel|isBlindAppend|
+-------+-------------------+------+--------+---------+--------------------+----+--------+---------+-----------+--------------+-------------+
|      0|2020-01-06 17:08:02|  null|    null|  CONVERT|[numFiles -> 3, p...|null|    null|     null|       null|          null|         null|
+-------+-------------------+------+--------+---------+--------------------+----+--------+---------+-----------+--------------+-------------+

// Show the data (for the changes)
val users = dt.toDF
scala> users.show
+---+-------+------+-------+
| id|   name|  city|country|
+---+-------+------+-------+
|  2|Bartosz| Paris| France|
|  0|  Agata|Warsaw| Poland|
|  1|  Jacek|Warsaw| Poland|
+---+-------+------+-------+

// Add a new user
val loic = Seq((3L, "Loic", "Paris", "France")).toDF("id", "name", "city", "country")
scala> loic.show
+---+----+-----+-------+
| id|name| city|country|
+---+----+-----+-------+
|  3|Loic|Paris| France|
+---+----+-----+-------+

loic.write.format("delta").mode("append").save(deltaLog.dataPath.toString)

// Review the cached RDD for the state (snapshot)
// Use http://localhost:4040/storage/

assert(deltaLog.snapshot.version == 1)

scala> users.show
+---+-------+------+-------+
| id|   name|  city|country|
+---+-------+------+-------+
|  2|Bartosz| Paris| France|
|  0|  Agata|Warsaw| Poland|
|  1|  Jacek|Warsaw| Poland|
|  3|   Loic| Paris| France|
+---+-------+------+-------+

scala> dt.history.show
+-------+-------------------+------+--------+---------+--------------------+----+--------+---------+-----------+--------------+-------------+
|version|          timestamp|userId|userName|operation| operationParameters| job|notebook|clusterId|readVersion|isolationLevel|isBlindAppend|
+-------+-------------------+------+--------+---------+--------------------+----+--------+---------+-----------+--------------+-------------+
|      1|2020-01-06 17:12:28|  null|    null|    WRITE|[mode -> Append, ...|null|    null|     null|          0|          null|         true|
|      0|2020-01-06 17:08:02|  null|    null|  CONVERT|[numFiles -> 3, p...|null|    null|     null|       null|          null|         null|
+-------+-------------------+------+--------+---------+--------------------+----+--------+---------+-----------+--------------+-------------+
----
