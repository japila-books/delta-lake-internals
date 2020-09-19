# Demo: Converting Parquet Dataset Into Delta Format

```text
/*
spark-shell \
  --packages io.delta:delta-core_2.12:0.7.0 \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.databricks.delta.snapshotPartitions=1
*/
assert(spark.version.matches("2.4.[2-6]"), "Delta Lake supports Spark 2.4.2+")

import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

val deltaLake = "/tmp/delta"

// Create parquet table
val users = s"$deltaLake/users"
import spark.implicits._
val data = Seq(
  (0L, "Agata", "Warsaw", "Poland"),
  (1L, "Jacek", "Warsaw", "Poland"),
  (2L, "Bartosz", "Paris", "France")
).toDF("id", "name", "city", "country")
data
  .write
  .format("parquet")
  .partitionBy("city", "country")
  .mode("overwrite")
  .save(users)

// TIP: Use git to version the users directory
//      to track the changes for import

// CONVERT TO DELTA only supports parquet tables
// TableIdentifier should be parquet.`users`

// Use TableIdentifier to refer to the parquet table
// The path itself would work too
val tableId = s"parquet.`$users`"
val partitionSchema = "city STRING, country STRING"

// Import users table into Delta Lake
// Well, convert the parquet table into delta table
// Use web UI to monitor execution, e.g. http://localhost:4040

import io.delta.tables.DeltaTable
val dt = DeltaTable.convertToDelta(spark, tableId, partitionSchema)
assert(dt.isInstanceOf[DeltaTable])

// users table is now in delta format
assert(DeltaTable.isDeltaTable(users))
```
