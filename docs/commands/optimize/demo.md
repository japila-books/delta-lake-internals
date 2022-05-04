# Optimize Demo

```scala
spark.range(10e4.toLong)
  .repartitionByRange(3, $"id" % 10)
  .write
  .format("delta")
  .save("/tmp/numbers")
```

```text
$ ls -l /tmp/numbers
total 800
drwxr-xr-x  4 jacek  wheel     128 May  4 11:36 _delta_log
-rw-r--r--  1 jacek  wheel  161036 May  4 11:36 part-00000-47704a0a-06fe-486f-8228-927341955364-c000.snappy.parquet
-rw-r--r--  1 jacek  wheel  121265 May  4 11:36 part-00001-957c1023-12c6-4028-95ef-55a4690f03d6-c000.snappy.parquet
-rw-r--r--  1 jacek  wheel  121037 May  4 11:36 part-00002-074c2195-4873-453a-b68f-ef99d7eecfc8-c000.snappy.parquet
```

```scala
val optimizeMetrics = sql("OPTIMIZE delta.`/tmp/numbers`")
```

```text
scala> optimizeMetrics.show(truncate = false)
+-----------------+-------------------------------------------------------------------------------------------------------------+
|path             |metrics                                                                                                      |
+-----------------+-------------------------------------------------------------------------------------------------------------+
|file:/tmp/numbers|{1, 3, {402620, 402620, 402620.0, 1, 402620}, {121037, 161036, 134446.0, 3, 403338}, 1, null, 1, 3, 0, false}|
+-----------------+-------------------------------------------------------------------------------------------------------------+
```

Note the extra `part-00000-76e0a4c6-af43-4981-a204-1ffdfc3105b4-c000.snappy.parquet` file in the following file listing.

```text
$ ls -l /tmp/numbers
total 1592
drwxr-xr-x  6 jacek  wheel     192 May  4 11:37 _delta_log
-rw-r--r--  1 jacek  wheel  161036 May  4 11:36 part-00000-47704a0a-06fe-486f-8228-927341955364-c000.snappy.parquet
-rw-r--r--  1 jacek  wheel  402620 May  4 11:37 part-00000-76e0a4c6-af43-4981-a204-1ffdfc3105b4-c000.snappy.parquet
-rw-r--r--  1 jacek  wheel  121265 May  4 11:36 part-00001-957c1023-12c6-4028-95ef-55a4690f03d6-c000.snappy.parquet
-rw-r--r--  1 jacek  wheel  121037 May  4 11:36 part-00002-074c2195-4873-453a-b68f-ef99d7eecfc8-c000.snappy.parquet
```

```scala
val history = sql("desc history delta.`/tmp/numbers`")
  .select(
    "version",
    "operation",
    "operationParameters",
    "readVersion",
    "isolationLevel",
    "isBlindAppend",
    "operationMetrics")
```

```text
scala> history.show(truncate = false)
+-------+---------+------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|version|operation|operationParameters                       |readVersion|isolationLevel   |isBlindAppend|operationMetrics                                                                                                                                                                                                 |
+-------+---------+------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|1      |OPTIMIZE |{predicate -> ["true"]}                   |0          |SnapshotIsolation|false        |{numRemovedFiles -> 3, numRemovedBytes -> 403338, p25FileSize -> 402620, minFileSize -> 402620, numAddedFiles -> 1, maxFileSize -> 402620, p75FileSize -> 402620, p50FileSize -> 402620, numAddedBytes -> 402620}|
|0      |WRITE    |{mode -> ErrorIfExists, partitionBy -> []}|null       |Serializable     |true         |{numFiles -> 3, numOutputRows -> 100000, numOutputBytes -> 403338}                                                                                                                                               |
+-------+---------+------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```
