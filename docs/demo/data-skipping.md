---
hide:
  - navigation
---

# Demo: Data Skipping

This demo shows **Data Skipping** in action.

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```

```scala
val tableName = "d01"
spark.range(5).write.format("delta").saveAsTable(tableName)
```

```scala
import org.apache.spark.sql.delta._
import org.apache.spark.sql.catalyst.TableIdentifier
val d01 = DeltaLog.forTable(spark, TableIdentifier(tableName))
```

```scala
val partitionFilters = Nil
d01.snapshot.filesWithStatsForScan(partitionFilters).printSchema
```

```text
root
 |-- path: string (nullable = true)
 |-- partitionValues: map (nullable = true)
 |    |-- key: string
 |    |-- value: string (valueContainsNull = true)
 |-- size: long (nullable = false)
 |-- modificationTime: long (nullable = false)
 |-- dataChange: boolean (nullable = false)
 |-- stats: struct (nullable = true)
 |    |-- numRecords: long (nullable = true)
 |    |-- minValues: struct (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |-- maxValues: struct (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |-- nullCount: struct (nullable = true)
 |    |    |-- id: long (nullable = true)
 |-- tags: map (nullable = true)
 |    |-- key: string
 |    |-- value: string (valueContainsNull = true)
```

```scala
val tableStats = d01.snapshot.filesWithStatsForScan(partitionFilters).select('path, 'size, $"stats.*")
```

```text
scala> tableStats.show
+--------------------+----+----------+---------+---------+---------+
|                path|size|numRecords|minValues|maxValues|nullCount|
+--------------------+----+----------+---------+---------+---------+
|part-00003-e2489b...| 478|         1|      {0}|      {0}|      {0}|
|part-00012-81afe9...| 478|         1|      {3}|      {3}|      {0}|
|part-00015-10c3b3...| 478|         1|      {4}|      {4}|      {0}|
|part-00006-fc62fe...| 478|         1|      {1}|      {1}|      {0}|
|part-00009-04ceb6...| 478|         1|      {2}|      {2}|      {0}|
|part-00000-ef076d...| 296|         0|   {null}|   {null}|   {null}|
+--------------------+----+----------+---------+---------+---------+
```
