# Deletion Vectors

**Deletion Vectors** is a [table feature](../table-features/index.md) to _soft-delete_ records (merely marking them as removed without rewriting the underlying parquet data files).

Deletion Vectors is supported by the following commands (based on their corresponding "guard" configuration properties):

Command | Configuration Property
-|-
 [DELETE](../commands/delete/index.md)<br>(when executed with a condition) | [spark.databricks.delta.delete.deletionVectors.persistent](../configuration-properties/index.md#delete.deletionVectors.persistent)
 [MERGE](../commands/merge/index.md) | [spark.databricks.delta.merge.deletionVectors.persistent](../configuration-properties/index.md#merge.deletionVectors.persistent)
 [UPDATE](../commands/update/index.md) | [spark.databricks.delta.update.deletionVectors.persistent](../configuration-properties/index.md#update.deletionVectors.persistent)

Deletion Vectors can be enabled on a delta table using [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property.

```sql
ALTER TABLE my_delta_table
SET TBLPROPERTIES ('delta.enableDeletionVectors' = true);
```

Deletion Vectors is used on a delta table when all of the following hold:

1. [spark.databricks.delta.delete.deletionVectors.persistent](../configuration-properties/DeltaSQLConf.md#DELETE_USE_PERSISTENT_DELETION_VECTORS) system-wide configuration property is enabled
1. [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property is enabled
1. [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the [Protocol](../Protocol.md)

There are two types of deletion vectors:

* inline
* on-disk (persistent)

(Persistent) Deletion Vectors are only supported on [parquet-based delta tables](../Protocol.md#assertTablePropertyConstraintsSatisfied).

## Purge Soft-Deleted Rows

[VACUUM](../commands/vacuum/index.md) and [OPTIMIZE](../commands/optimize/index.md) commands are used to purge soft-deleted rows.

## UniForm Iceberg

UniForm Iceberg (`IcebergCompatV2` and `IcebergCompatV1`) uses `CheckNoDeletionVector` check to assert that Deletion Vectors are disabled on a delta table.

```text
IcebergCompatV<version> requires Deletion Vectors to be disabled on the table.
Please use the ALTER TABLE DROP FEATURE command to disable Deletion Vectors
and to remove the existing Deletion Vectors from the table.
```

??? note "ALTER TABLE DROP FEATURE SQL command"
    Use [ALTER TABLE DROP FEATURE](../sql/index.md#ALTER-TABLE-DROP-FEATURE) SQL command to drop a feature on a delta table.

The Iceberg-compatibility feature ([REORG TABLE](../commands/reorg/index.md) with `ICEBERG_COMPAT_VERSION`) turns Deletion Vectors off.

## Demo

Create a delta table with [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property enabled.

=== "SQL"

    ```sql
    CREATE TABLE tbl(a int)
    USING delta
    TBLPROPERTIES (
      'delta.enableDeletionVectors' = 'true'
    )
    ```

=== "Scala"

    ```scala
    sql("""
    CREATE OR REPLACE TABLE tbl(id int)
    USING delta
    TBLPROPERTIES (
      'delta.enableDeletionVectors' = 'true'
    )
    """)
    ```

Describe the detail of the delta table using [DESCRIBE DETAIL](../commands/describe-detail/index.md) command.

=== "Scala"

    ```scala
    sql("DESC DETAIL tbl")
      .select("name", "properties", "minReaderVersion", "minWriterVersion", "tableFeatures")
      .show(truncate = false)
    ```

    ```text
    +-------------------------+-------------------------------------+----------------+----------------+-----------------+
    |name                     |properties                           |minReaderVersion|minWriterVersion|tableFeatures    |
    +-------------------------+-------------------------------------+----------------+----------------+-----------------+
    |spark_catalog.default.tbl|{delta.enableDeletionVectors -> true}|3               |7               |[deletionVectors]|
    +-------------------------+-------------------------------------+----------------+----------------+-----------------+
    ```

```scala
sql("INSERT INTO tbl VALUES 1, 2, 3")
```

Deletion Vectors is supported by [DELETE](../commands/delete/index.md) command.

=== "Scala"

    ```text
    scala> sql("DELETE FROM tbl WHERE id=1").show()
    +-----------------+
    |num_affected_rows|
    +-----------------+
    |                1|
    +-----------------+
    ```

```scala
val location = sql("DESC DETAIL tbl").select("location").as[String].head()
```

```console hl_lines="4"
$ ls -l spark-warehouse/tbl
total 32
drwxr-xr-x@ 9 jacek  staff  288 Jun 11 20:41 _delta_log
-rw-r--r--@ 1 jacek  staff   43 Jun 11 20:41 deletion_vector_5366f7d2-59db-4b86-b160-af5b8f5944d6.bin
-rw-r--r--@ 1 jacek  staff  449 Jun 11 20:39 part-00000-be36d6d7-fd71-4b4a-a6b3-fbb41d568abc-c000.snappy.parquet
-rw-r--r--@ 1 jacek  staff  449 Jun 11 20:39 part-00001-728e8290-6af7-465d-9372-df7d0f981b62-c000.snappy.parquet
-rw-r--r--@ 1 jacek  staff  449 Jun 11 20:39 part-00002-85c45a7f-8903-4a7c-bdd1-2f4998fcc8b4-c000.snappy.parquet
```

Physically delete dropped rows using [VACUUM](../commands/vacuum/index.md) command.

```text
scala> sql("DESC HISTORY tbl").select("version", "operation", "operationParameters").show(truncate=false)
+-------+------------+----------------------------------------------------------------------------------------------------------------------------------+
|version|operation   |operationParameters                                                                                                               |
+-------+------------+----------------------------------------------------------------------------------------------------------------------------------+
|2      |DELETE      |{predicate -> ["(a#2003 = 1)"]}                                                                                                   |
|1      |WRITE       |{mode -> Append, partitionBy -> []}                                                                                               |
|0      |CREATE TABLE|{partitionBy -> [], clusterBy -> [], description -> NULL, isManaged -> true, properties -> {"delta.enableDeletionVectors":"true"}}|
+-------+------------+----------------------------------------------------------------------------------------------------------------------------------+
```

```text
scala> sql("SET spark.databricks.delta.retentionDurationCheck.enabled = false").show(truncate=false)
+-----------------------------------------------------+-----+
|key                                                  |value|
+-----------------------------------------------------+-----+
|spark.databricks.delta.retentionDurationCheck.enabled|false|
+-----------------------------------------------------+-----+
```

```text
scala> sql("VACUUM tbl RETAIN 0 HOURS").show(truncate=false)
Deleted 2 files and directories in a total of 1 directories.
+---------------------------------------------------+
|path                                               |
+---------------------------------------------------+
|file:/Users/jacek/dev/oss/spark/spark-warehouse/tbl|
+---------------------------------------------------+
```

```text
scala> sql("DESC HISTORY tbl").select("version", "operation", "operationParameters").show(truncate=false)
+-------+------------+----------------------------------------------------------------------------------------------------------------------------------+
|version|operation   |operationParameters                                                                                                               |
+-------+------------+----------------------------------------------------------------------------------------------------------------------------------+
|4      |VACUUM END  |{status -> COMPLETED}                                                                                                             |
|3      |VACUUM START|{retentionCheckEnabled -> false, defaultRetentionMillis -> 604800000, specifiedRetentionMillis -> 0}                              |
|2      |DELETE      |{predicate -> ["(a#2003 = 1)"]}                                                                                                   |
|1      |WRITE       |{mode -> Append, partitionBy -> []}                                                                                               |
|0      |CREATE TABLE|{partitionBy -> [], clusterBy -> [], description -> NULL, isManaged -> true, properties -> {"delta.enableDeletionVectors":"true"}}|
+-------+------------+----------------------------------------------------------------------------------------------------------------------------------+
```

```console
$ ls -l spark-warehouse/tbl
total 16
drwxr-xr-x@ 13 jacek  staff  416 Jun 11 21:08 _delta_log
-rw-r--r--@  1 jacek  staff  449 Jun 11 20:39 part-00001-728e8290-6af7-465d-9372-df7d0f981b62-c000.snappy.parquet
-rw-r--r--@  1 jacek  staff  449 Jun 11 20:39 part-00002-85c45a7f-8903-4a7c-bdd1-2f4998fcc8b4-c000.snappy.parquet
```

## Learn More

1. [Delta Lake Deletion Vectors]({{ delta.blog }}/2023-07-05-deletion-vectors/)
