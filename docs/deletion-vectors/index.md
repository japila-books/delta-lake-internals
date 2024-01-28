---
hide:
  - toc
---

# Deletion Vectors

**Deletion Vectors** table feature is used to speed up a conditional [DELETE](../commands/delete/index.md) command (when executed with a delete condition) in such a way that deleted rows as marked as such with no physical data file rewrite.

It is said that Deletion Vectors feature soft-deletes data.

Deletion Vectors can be enabled on a delta table using [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property.

Deletion Vectors is used on a delta table when all of the following hold:

1. [spark.databricks.delta.delete.deletionVectors.persistent](../configuration-properties/DeltaSQLConf.md#DELETE_USE_PERSISTENT_DELETION_VECTORS) system-wide configuration property is enabled
1. [delta.enableDeletionVectors](../table-properties/DeltaConfigs.md#enableDeletionVectors) table property is enabled
1. [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the [Protocol](../Protocol.md)

## REORG TABLE Command

[REORG TABLE](../commands/reorg/index.md) is used to purge soft-deleted data.

## Persistent Deletion Vectors

[spark.databricks.delta.delete.deletionVectors.persistent](../configuration-properties/index.md#delete.deletionVectors.persistent)

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
    sql("desc detail tbl")
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
