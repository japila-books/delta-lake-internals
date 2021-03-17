---
hide:
  - navigation
---

# Demo: dataChange

This demo shows [dataChange](../options.md#dataChange) option in action.

In combination with `Overwrite` mode, `dataChange` option can be used to transactionally rearrange data in a delta table.

## Start Spark Shell

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```

## Create Delta Table

```text
val path = "/tmp/delta/d01"
```

Make sure that there is no delta table at the location. Remove it if exists and start over.

```text
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, path)
assert(deltaLog.tableExists == false)
```

Create the demo delta table (using SQL).

```text
sql(s"""
  CREATE TABLE delta.`$path`
  USING delta
  VALUES ((0, 'Jacek'), (1, 'Agata')) AS (id, name)
  """)
```

## Show History (Before)

``` scala
import io.delta.tables.DeltaTable
val dt = DeltaTable.forPath(path)
assert(dt.history.count == 1)
```

## Repartition Table

The following `dataChange` example shows a batch query that repartitions a delta table (perhaps while other queries could be using the delta table).

Let's check out the number of partitions.

```text
spark.read.format("delta").load(path).rdd.getNumPartitions
```

The key items to pay attention to are:

1. The batch query is independent from any other running streaming or batch queries over the delta table
1. The batch query reads from the same delta table it saves data to
1. The save mode is overwrite
1. dataChange option is disabled

```text
spark
  .read
  .format("delta")
  .load(path)
  .repartition(10)
  .write
  .format("delta")
  .mode("overwrite")
  .option("dataChange", false)
  .save(path)
```

Let's check out the number of partitions after the repartition.

```text
spark.read.format("delta").load(path).rdd.getNumPartitions
```

## Show History (After)

```scala
assert(dt.history.count == 2)
```

```text
dt.history
  .select('version, 'operation, 'operationParameters, 'operationMetrics)
  .orderBy('version.asc)
  .show(truncate = false)
```

```text
+-------+----------------------+------------------------------------------------------------------------------+-----------------------------------------------------------+
|version|operation             |operationParameters                                                           |operationMetrics                                           |
+-------+----------------------+------------------------------------------------------------------------------+-----------------------------------------------------------+
|0      |CREATE TABLE AS SELECT|{isManaged -> false, description -> null, partitionBy -> [], properties -> {}}|{numFiles -> 1, numOutputBytes -> 1273, numOutputRows -> 1}|
|1      |WRITE                 |{mode -> Overwrite, partitionBy -> []}                                        |{numFiles -> 2, numOutputBytes -> 1992, numOutputRows -> 1}|
+-------+----------------------+------------------------------------------------------------------------------+-----------------------------------------------------------+
```
