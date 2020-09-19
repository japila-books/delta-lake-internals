= Demo: Schema Evolution
:navtitle: Schema Evolution

[source,plaintext]
----
/*
spark-shell \
  --packages io.delta:delta-core_2.12:0.7.0 \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.databricks.delta.snapshotPartitions=1
*/
assert(spark.version.matches("2.4.[2-6]"), "Delta Lake supports Spark 2.4.2+")

case class PersonV1(id: Long, name: String)
import org.apache.spark.sql.Encoders
val schemaV1 = Encoders.product[PersonV1].schema
scala> schemaV1.printTreeString
root
 |-- id: long (nullable = false)
 |-- name: string (nullable = true)

val dataPath = "/tmp/delta/people"

// Write data
Seq(PersonV1(0, "Zero"), PersonV1(1, "One"))
  .toDF
  .write
  .format("delta")
  .mode("overwrite")
  .option("overwriteSchema", "true")
  .save(dataPath)

// Committed delta #0 to file:/tmp/delta/people/_delta_log

import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)
assert(deltaLog.snapshot.version == 0)

scala> deltaLog.snapshot.dataSchema.printTreeString
root
 |-- id: long (nullable = true)
 |-- name: string (nullable = true)

import io.delta.tables.DeltaTable
val dt = DeltaTable.forPath(dataPath)
scala> dt.toDF.show
+---+----+
| id|name|
+---+----+
|  0|Zero|
|  1| One|
+---+----+

val main = dt.as("main")

case class PersonV2(id: Long, name: String, newField: Boolean)
val schemaV2 = Encoders.product[PersonV2].schema
scala> schemaV2.printTreeString
root
 |-- id: long (nullable = false)
 |-- name: string (nullable = true)
 |-- newField: boolean (nullable = false)

val updates = Seq(
  PersonV2(0, "ZERO", newField = true),
  PersonV2(2, "TWO", newField = false)).toDF

// Merge two datasets and create a new version
// Schema evolution in play
main.merge(
    source = updates.as("updates"),
    condition = $"main.id" === $"updates.id")
  .whenMatched.updateAll
  .execute

val latestPeople = spark
  .read
  .format("delta")
  .load(dataPath)
scala> latestPeople.show
+---+----+
| id|name|
+---+----+
|  0|ZERO|
|  1| One|
+---+----+
----
