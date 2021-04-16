# Vacuum Command

`Vacuum` command allows for [garbage collection of a delta table](VacuumCommand.md#gc).

`Vacuum` command can be executed as a [SQL command](../../sql/index.md#VACUUM) or [DeltaTable](../../DeltaTable.md#vacuum) operator.

## Demo

### VACUUM SQL Command

```scala
val q = sql("VACUUM delta.`/tmp/delta/t1`")
```

```text
scala> q.show
Deleted 0 files and directories in a total of 2 directories.
+------------------+
|              path|
+------------------+
|file:/tmp/delta/t1|
+------------------+
```

### DeltaTable.vacuum

```scala
import io.delta.tables.DeltaTable
DeltaTable.forPath("/tmp/delta/t1").vacuum
```

### Dry Run

```scala
val path = "/tmp/delta/t1"
```

```scala
spark.range(4)
  .withColumn("p", 'id % 2)
  .write
  .format("delta")
  .partitionBy("p")
  .save(path)
```

```scala
import io.delta.tables.DeltaTable
DeltaTable.forPath(path).delete
```

```scala
spark.conf.set("spark.databricks.delta.retentionDurationCheck.enabled", false)

val q = sql(s"VACUUM delta.`$path` RETAIN 0 HOURS DRY RUN")
q.show(truncate = false)
```

```text
+------------------------------------------------------------------------------------------+
|path                                                                                      |
+------------------------------------------------------------------------------------------+
|file:/tmp/delta/t1/p=0/part-00003-15f41725-aab8-4c19-9b72-8e9f9d574539.c000.snappy.parquet|
|file:/tmp/delta/t1/p=0/part-00011-7196929f-54de-4d0e-9abc-f1a9674525bf.c000.snappy.parquet|
|file:/tmp/delta/t1/p=1/part-00015-5d28d069-6d63-4f68-9f6f-dd08979ad4c5.c000.snappy.parquet|
|file:/tmp/delta/t1/p=1/part-00007-d870b6c5-2a89-46f2-b6c6-1225f6dcc807.c000.snappy.parquet|
+------------------------------------------------------------------------------------------+
```

### Retain 0 Hours

```scala
sql(s"VACUUM delta.`$path` RETAIN 0 HOURS").show(truncate = false)
```

```text
Deleted 4 files and directories in a total of 3 directories.
+------------------+
|path              |
+------------------+
|file:/tmp/delta/t1|
+------------------+
```
