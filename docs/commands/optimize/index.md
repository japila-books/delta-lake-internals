# Optimize Command

`OPTIMIZE` command compacts files together (that are smaller than `spark.databricks.delta.optimize.minFileSize` to files of `spark.databricks.delta.optimize.maxFileSize` size).

`OPTIMIZE` command uses `spark.databricks.delta.optimize.maxThreads` threads for compaction.

`OPTIMIZE` command can be executed using [OPTIMIZE](OptimizeTableCommand.md) SQL command.

## Demo

```scala
// val q = sql("OPTIMIZE delta.`/tmp/delta/t1`")
val q = sql("OPTIMIZE delta_01")
```

```text

scala> q.show(truncate = false)
+--------------------------------------------------------+--------------------------------------------------------------------------------------------------+
|path                                                    |metrics                                                                                           |
+--------------------------------------------------------+--------------------------------------------------------------------------------------------------+
|file:/Users/jacek/dev/oss/spark/spark-warehouse/delta_01|{1, 9, {778, 778, 778.0, 1, 778}, {296, 692, 552.8888888888889, 9, 4976}, 1, null, 1, 9, 0, false}|
+--------------------------------------------------------+--------------------------------------------------------------------------------------------------+
```
