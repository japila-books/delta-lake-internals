---
hide:
  - navigation
---

# Demo: Optimize

This demo shows [OPTIMIZE](../commands/optimize/index.md) command in action.

## Create Delta Table

=== "Scala"

    ```scala
    sql("DROP TABLE IF EXISTS nums")
    spark.range(10e4.toLong)
      .repartitionByRange(3, $"id" % 10)
      .writeTo("nums")
      .using("delta")
      .create
    ```

Let's review the on-disk table representation.

=== "Shell"

    ```text
    tree -s spark-warehouse/nums
    ```

```text
[        288]  spark-warehouse/nums
├── [        128]  _delta_log
│   └── [       1624]  00000000000000000000.json
├── [     161036]  part-00000-9d2b6a10-d00e-4cdb-aa24-84ff7346bf08-c000.snappy.parquet
├── [     121265]  part-00001-cb9456b6-037d-469f-b0d1-c384064beadd-c000.snappy.parquet
└── [     121037]  part-00002-4aa15e4b-9db4-4a4a-9f97-dd4f4396792b-c000.snappy.parquet

2 directories, 4 files
```

## Optimize Table

=== "Scala"

    ```scala
    val optimizeMetrics = sql("OPTIMIZE nums")
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
 |    |-- numFilesSkippedToReduceWriteAmplification: long (nullable = false)
 |    |-- numBytesSkippedToReduceWriteAmplification: long (nullable = false)
 |    |-- startTimeMs: long (nullable = false)
 |    |-- endTimeMs: long (nullable = false)
 |    |-- totalClusterParallelism: long (nullable = false)
 |    |-- totalScheduledTasks: long (nullable = false)
 |    |-- autoCompactParallelismStats: struct (nullable = true)
 |    |    |-- maxClusterActiveParallelism: long (nullable = true)
 |    |    |-- minClusterActiveParallelism: long (nullable = true)
 |    |    |-- maxSessionActiveParallelism: long (nullable = true)
 |    |    |-- minSessionActiveParallelism: long (nullable = true)
```

=== "Scala"

    ```scala
    optimizeMetrics.show(truncate = false)
    ```

```text
+-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------+
|path             |metrics                                                                                                                                           |
+-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------+
|file:/tmp/numbers|{1, 3, {402620, 402620, 402620.0, 1, 402620}, {121037, 161036, 134446.0, 3, 403338}, 1, null, 1, 3, 0, false, 0, 0, 1678104379055, 0, 16, 0, null}|
+-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------+
```

Let's review the on-disk table representation (after `OPTIMIZE`).

=== "Shell"

    ```text
    tree -s spark-warehouse/nums
    ```

```text
[        352]  spark-warehouse/nums
├── [        192]  _delta_log
│   ├── [       1624]  00000000000000000000.json
│   └── [       1431]  00000000000000000001.json
├── [     402620]  part-00000-86af4440-5374-4c18-ae6f-07b0d3680e27-c000.snappy.parquet
├── [     161036]  part-00000-9d2b6a10-d00e-4cdb-aa24-84ff7346bf08-c000.snappy.parquet
├── [     121265]  part-00001-cb9456b6-037d-469f-b0d1-c384064beadd-c000.snappy.parquet
└── [     121037]  part-00002-4aa15e4b-9db4-4a4a-9f97-dd4f4396792b-c000.snappy.parquet

2 directories, 6 files
```

Note one extra file (`part-00000-86af4440-5374-4c18-ae6f-07b0d3680e27-c000.snappy.parquet`) in the file listing.

??? note "Use DeltaLog to Review Log Files"
    You can review the transaction log (i.e., the`00000000000000000001.json` commit file in particular) or use [DeltaLog](../DeltaLog.md).

    === "Scala"
        
        ```scala
        import org.apache.spark.sql.delta.DeltaLog
        import org.apache.spark.sql.catalyst.TableIdentifier
        val log = DeltaLog.forTable(spark, tableName = TableIdentifier("nums"))
        log.getSnapshotAt(1).allFiles.select('path).show(truncate = false)
        ```

    ```text
    +-------------------------------------------------------------------+
    |path                                                               |
    +-------------------------------------------------------------------+
    |part-00000-86af4440-5374-4c18-ae6f-07b0d3680e27-c000.snappy.parquet|
    +-------------------------------------------------------------------+
    ```

## Review History

[OPTIMIZE](../commands/optimize/index.md) is transactional and creates a new version.

=== "Scala"

    ```scala
    val history = sql("desc history nums")
      .select(
        "version",
        "operation",
        "operationParameters",
        "readVersion",
        "isolationLevel",
        "isBlindAppend",
        "operationMetrics")
    history.show(truncate = false)
    ```

```text
+-------+----------------------+-----------------------------------------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|version|operation             |operationParameters                                                          |readVersion|isolationLevel   |isBlindAppend|operationMetrics                                                                                                                                                                                                 |
+-------+----------------------+-----------------------------------------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|1      |OPTIMIZE              |{predicate -> [], zOrderBy -> []}                                            |0          |SnapshotIsolation|false        |{numRemovedFiles -> 3, numRemovedBytes -> 403338, p25FileSize -> 402620, minFileSize -> 402620, numAddedFiles -> 1, maxFileSize -> 402620, p75FileSize -> 402620, p50FileSize -> 402620, numAddedBytes -> 402620}|
|0      |CREATE TABLE AS SELECT|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|null       |Serializable     |true         |{numFiles -> 3, numOutputRows -> 100000, numOutputBytes -> 403338}                                                                                                                                               |
+-------+----------------------+-----------------------------------------------------------------------------+-----------+-----------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```
