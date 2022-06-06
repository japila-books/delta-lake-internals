---
hide:
  - navigation
---

# Demo: Data Skipping

This demo shows [Data Skipping](../data-skipping/index.md) in action.

## Logging

Enable logging for [PrepareDeltaScan](../data-skipping/PrepareDeltaScan.md#logging) and the others used in data skipping.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.stats=ALL
```

## Start Spark Shell

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```

```scala
import org.apache.spark.sql.delta.sources.DeltaSQLConf
assert(spark.sessionState.conf.getConf(DeltaSQLConf.DELTA_STATS_SKIPPING), "Data skipping should be enabled")
```

## Create Delta Table

```scala
val tableName = "d01"
sql(s"DROP TABLE IF EXISTS $tableName")
spark.range(5).writeTo(tableName).using("delta").create
```

## Show Column Statistics

```scala
import org.apache.spark.sql.delta._
import org.apache.spark.sql.catalyst.TableIdentifier
val d01 = DeltaLog.forTable(spark, TableIdentifier(tableName))
```

```scala
val partitionFilters = Nil
val filesWithStatsForScan = d01.snapshot.filesWithStatsForScan(partitionFilters)
filesWithStatsForScan.printSchema
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
val tableStats = filesWithStatsForScan.select('path, 'size, $"stats.*")
tableStats.orderBy('path).show
```

```text
+--------------------+----+----------+---------+---------+---------+
|                path|size|numRecords|minValues|maxValues|nullCount|
+--------------------+----+----------+---------+---------+---------+
|part-00000-43b9e4...| 296|         0|   {null}|   {null}|   {null}|
|part-00003-2685fb...| 478|         1|      {0}|      {0}|      {0}|
|part-00006-815e72...| 478|         1|      {1}|      {1}|      {0}|
|part-00009-654322...| 478|         1|      {2}|      {2}|      {0}|
|part-00012-f3a708...| 478|         1|      {3}|      {3}|      {0}|
|part-00015-5ca541...| 478|         1|      {4}|      {4}|      {0}|
+--------------------+----+----------+---------+---------+---------+
```

## Execute Query with Data Skipping

```scala
val q = sql(s"SELECT * FROM $tableName WHERE id IN (2, 3)")
q.show
```

You should see the following logs and the output.

```text
22/05/29 22:58:02 INFO PrepareDeltaScan: DELTA: Filtering files for query
22/05/29 22:58:02 INFO PrepareDeltaScan: DELTA: Done
+---+
| id|
+---+
|  3|
|  2|
+---+
```

## web UI

Open the [web UI](http://localhost:4040) to review the query and the associated job with the name `Filtering files for query`.
