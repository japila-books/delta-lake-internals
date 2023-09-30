---
hide:
  - toc
---

# Deletion Vectors

**Deletion Vectors** is enabled using [delta.enableDeletionVectors](../DeltaConfigs.md#enableDeletionVectors) table property.

## Demo

Create a delta table with [delta.enableDeletionVectors](../DeltaConfigs.md#enableDeletionVectors) table property enabled.

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
