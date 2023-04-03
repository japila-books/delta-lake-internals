---
hide:
  - navigation
---

# Demo: replaceWhere

This demo shows [replaceWhere](../delta/options.md#replaceWhere) predicate option.

In combination with `Overwrite` mode, a `replaceWhere` option can be used to transactionally replace data that matches a predicate.

## Create Delta Table

```scala
val table = "d1"
```

```scala
sql(s"""
  CREATE TABLE $table (`id` LONG, p STRING)
  USING delta
  PARTITIONED BY (p)
  COMMENT 'Delta table'
""")
```

```scala
spark.catalog.listTables.show
```

```text
+----+--------+-----------+---------+-----------+
|name|database|description|tableType|isTemporary|
+----+--------+-----------+---------+-----------+
|  d1| default|Delta table|  MANAGED|      false|
+----+--------+-----------+---------+-----------+
```

```scala
import org.apache.spark.sql.delta.DeltaLog
val dt = DeltaLog.forTable(spark, table)
val m = dt.snapshot.metadata
val partitionSchema = m.partitionSchema
```

## Write Data

```scala
Seq((0L, "a"),
    (1L, "a"))
  .toDF("id", "p")
  .write
  .format("delta")
  .option("replaceWhere", "p = 'a'")
  .mode("overwrite")
  .saveAsTable(table)
```
