# Deletion Vectors

**Deletion Vectors** is a [table feature](../table-features/index.md) to _soft-delete_ records (merely marking them as removed without rewriting the underlying parquet data files).

Deletion Vectors is supported by conditional [DELETE](../commands/delete/index.md)s (when executed with a delete condition).

Deletion Vectors can be enabled on a delta table using [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property.

```sql
ALTER TABLE my_delta_table SET TBLPROPERTIES ('delta.enableDeletionVectors' = true);
```

Deletion Vectors is used on a delta table when all of the following hold:

1. [spark.databricks.delta.delete.deletionVectors.persistent](../configuration-properties/DeltaSQLConf.md#DELETE_USE_PERSISTENT_DELETION_VECTORS) system-wide configuration property is enabled
1. [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property is enabled
1. [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the [Protocol](../Protocol.md)

(Persistent) Deletion Vectors are only supported on [parquet-based delta tables](../Protocol.md#assertTablePropertyConstraintsSatisfied).

## REORG TABLE Command

[REORG TABLE](../commands/reorg/index.md) is used to purge soft-deleted data.

## Persistent Deletion Vectors

[spark.databricks.delta.delete.deletionVectors.persistent](../configuration-properties/index.md#delete.deletionVectors.persistent)

## Iceberg-Compatibility Feature

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

## Learn More

1. [Delta Lake Deletion Vectors]({{ delta.blog }}/2023-07-05-deletion-vectors/)
