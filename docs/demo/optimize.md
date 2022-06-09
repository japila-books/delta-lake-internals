---
hide:
  - navigation
---

# Demo: Optimize

This demo shows [OPTIMIZE](../commands/restore/index.md) command in action.

## Create Delta Table

=== "Scala"

    ```scala
    spark.range(10e4.toLong)
      .repartitionByRange(3, $"id" % 10)
      .write
      .format("delta")
      .save("/tmp/numbers")
    ```

Let's review the on-disk table representation.

```text
tree /tmp/numbers
```

```text
/tmp/numbers
├── _delta_log
│   └── 00000000000000000000.json
├── part-00000-9dfa9cb7-6f0e-4a6f-8aeb-fac8e9813e0b-c000.snappy.parquet
├── part-00001-30dbfd11-cb84-46a3-b096-ede0a890d210-c000.snappy.parquet
└── part-00002-b0c85f24-258b-4d4e-b1bd-4766760fa143-c000.snappy.parquet

1 directory, 4 files
```

## Optimize Table

=== "Scala"

    ```scala
    val optimizeMetrics = sql("OPTIMIZE delta.`/tmp/numbers`")
    ```

```text
scala> optimizeMetrics.printSchema
root
 |-- path: string (nullable = true)
 |-- metrics: struct (nullable = true)
 |    |-- numFilesAdded: long (nullable = false)
 |    |-- numFilesRemoved: long (nullable = false)
 |    |-- filesAdded: struct (nullable = true)
 |    |    |-- min: long (nullable = true)
 |    |    |-- max: long (nullable = true)
 |    |    |-- avg: double (nullable = false)
 |    |    |-- totalFiles: long (nullable = false)
 |    |    |-- totalSize: long (nullable = false)
 |    |-- filesRemoved: struct (nullable = true)
 |    |    |-- min: long (nullable = true)
 |    |    |-- max: long (nullable = true)
 |    |    |-- avg: double (nullable = false)
 |    |    |-- totalFiles: long (nullable = false)
 |    |    |-- totalSize: long (nullable = false)
 |    |-- partitionsOptimized: long (nullable = false)
 |    |-- zOrderStats: struct (nullable = true)
 |    |    |-- strategyName: string (nullable = true)
 |    |    |-- inputCubeFiles: struct (nullable = true)
 |    |    |    |-- num: long (nullable = false)
 |    |    |    |-- size: long (nullable = false)
 |    |    |-- inputOtherFiles: struct (nullable = true)
 |    |    |    |-- num: long (nullable = false)
 |    |    |    |-- size: long (nullable = false)
 |    |    |-- inputNumCubes: long (nullable = false)
 |    |    |-- mergedFiles: struct (nullable = true)
 |    |    |    |-- num: long (nullable = false)
 |    |    |    |-- size: long (nullable = false)
 |    |    |-- numOutputCubes: long (nullable = false)
 |    |    |-- mergedNumCubes: long (nullable = true)
 |    |-- numBatches: long (nullable = false)
 |    |-- totalConsideredFiles: long (nullable = false)
 |    |-- totalFilesSkipped: long (nullable = false)
 |    |-- preserveInsertionOrder: boolean (nullable = false)
```

```scala
optimizeMetrics.show(truncate = false)
```

```text
+-----------------+-------------------------------------------------------------------------------------------------------------+
|path             |metrics                                                                                                      |
+-----------------+-------------------------------------------------------------------------------------------------------------+
|file:/tmp/numbers|{1, 3, {402620, 402620, 402620.0, 1, 402620}, {121037, 161036, 134446.0, 3, 403338}, 1, null, 1, 3, 0, false}|
+-----------------+-------------------------------------------------------------------------------------------------------------+
```

Let's review the on-disk table representation (after `OPTIMIZE`).

```text
tree /tmp/numbers
```

```text
/tmp/numbers
├── _delta_log
│   ├── 00000000000000000000.json
│   └── 00000000000000000001.json
├── part-00000-2c801cd8-94c6-4dc3-b9da-be56f5741d0b-c000.snappy.parquet
├── part-00000-9dfa9cb7-6f0e-4a6f-8aeb-fac8e9813e0b-c000.snappy.parquet
├── part-00001-30dbfd11-cb84-46a3-b096-ede0a890d210-c000.snappy.parquet
└── part-00002-b0c85f24-258b-4d4e-b1bd-4766760fa143-c000.snappy.parquet

1 directory, 6 files
```

Note one extra file (`part-00000-2c801cd8-94c6-4dc3-b9da-be56f5741d0b-c000.snappy.parquet`) in the file listing.

??? note "Use DeltaLog to Review Log Files"
    You can review the transaction log (i.e., the`00000000000000000001.json` commit file in particular) or use [DeltaLog](../DeltaLog.md).

    ```scala
    import org.apache.spark.sql.delta.DeltaLog
    val log = DeltaLog.forTable(spark, dataPath = "/tmp/numbers")
    log.getSnapshotAt(1).allFiles.select('path).show(truncate = false)
    ```

    ```text
    +-------------------------------------------------------------------+
    |path                                                               |
    +-------------------------------------------------------------------+
    |part-00000-2c801cd8-94c6-4dc3-b9da-be56f5741d0b-c000.snappy.parquet|
    +-------------------------------------------------------------------+
    ```

## Review History

[OPTIMIZE](../commands/optimize/index.md) is transactional and creates a new version.

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

```scala
history.show(truncate = false)
```

```text
+-------+---------+------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|version|operation|operationParameters                       |readVersion|isolationLevel   |isBlindAppend|operationMetrics                                                                                                                                                                                                 |
+-------+---------+------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|1      |OPTIMIZE |{predicate -> ["true"]}                   |0          |SnapshotIsolation|false        |{numRemovedFiles -> 3, numRemovedBytes -> 403338, p25FileSize -> 402620, minFileSize -> 402620, numAddedFiles -> 1, maxFileSize -> 402620, p75FileSize -> 402620, p50FileSize -> 402620, numAddedBytes -> 402620}|
|0      |WRITE    |{mode -> ErrorIfExists, partitionBy -> []}|null       |Serializable     |true         |{numFiles -> 3, numOutputRows -> 100000, numOutputBytes -> 403338}                                                                                                                                               |
+-------+---------+------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```
