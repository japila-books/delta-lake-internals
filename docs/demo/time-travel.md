---
hide:
  - navigation
---

# Demo: Time Travel

This demo shows [Time Travel](../time-travel/index.md) in action.

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```

```scala
import io.delta.implicits._

Seq(("r1", 500), ("r2", 600)).toDF("id", "value").write.delta("/tmp/delta/demo")

sql("DESCRIBE HISTORY delta.`/tmp/delta/demo`").select('version, 'operation).show(truncate = false)

// +-------+---------+
// |version|operation|
// +-------+---------+
// |0      |WRITE    |
// +-------+---------+

sql("UPDATE delta.`/tmp/delta/demo` SET value = '700' WHERE id = 'r1'")

sql("DESCRIBE HISTORY delta.`/tmp/delta/demo`").select('version, 'operation).show(truncate = false)

// +-------+---------+
// |version|operation|
// +-------+---------+
// |1      |UPDATE   |
// |0      |WRITE    |
// +-------+---------+

spark.read.delta("/tmp/delta/demo").show

// +---+-----+
// | id|value|
// +---+-----+
// | r1|  700|
// | r2|  600|
// +---+-----+

spark.read.option("versionAsOf", 0).delta("/tmp/delta/demo").show

// +---+-----+
// | id|value|
// +---+-----+
// | r1|  500|
// | r2|  600|
// +---+-----+
```

The above query over a previous version is also possible using [version pattern](../time-travel/DeltaTimeTravelSpec.md#time-travel-patterns).

```scala
spark.read.delta("/tmp/delta/demo@v1").show
```

## Cataloged Delta Table

For a delta table registered in a catalog, you could use the following query:

```scala
spark.read.format("delta").option("versionAsOf", 0).table(tableName).show
```
