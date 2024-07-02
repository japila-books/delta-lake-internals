---
hide:
  - toc
---

# Append-Only Tables

**Append-Only Tables** is a [table feature](AppendOnlyTableFeature.md) in Delta Lake that [forbids deleting data files](../DeltaLog.md#assertRemovable) that could be a result of the following:

* [Delete](../commands/delete/index.md), [Update](../commands/update/index.md), [WriteIntoDelta](../commands/WriteIntoDelta.md) (in `Overwrite` save mode) commands
* `DeltaSink` to [addBatch](../spark-connector/DeltaSink.md#addBatch) in `Complete` output mode
* [RemoveFile](../RemoveFile.md)s with [dataChange](../RemoveFile.md#dataChange) (at [prepareCommit](../OptimisticTransactionImpl.md#prepareCommit))

Append-Only Tables is enabled on a delta table using [delta.appendOnly](../table-properties/DeltaConfigs.md#IS_APPEND_ONLY) table property (indirectly, through [AppendOnlyTableFeature](AppendOnlyTableFeature.md) that is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md) and uses this table property).

## Demo

Create a delta table with [delta.appendOnly](../table-properties/DeltaConfigs.md#appendOnly) table property enabled.

=== "Scala"

    ```scala
    sql("""
    CREATE TABLE tbl(a int)
    USING delta
    TBLPROPERTIES (
      'delta.appendOnly' = 'true'
    )
    """)
    ```

Describe the detail of the delta table using [DESCRIBE DETAIL](../commands/describe-detail/index.md) command.

=== "Scala"

    ```scala
    sql("""
      DESC DETAIL tbl
      """)
      .select("name", "properties", "minReaderVersion", "minWriterVersion", "tableFeatures")
      .show(truncate = false)
    ```

    ```text
    +-------------------------+--------------------------+----------------+----------------+------------------------+
    |name                     |properties                |minReaderVersion|minWriterVersion|tableFeatures           |
    +-------------------------+--------------------------+----------------+----------------+------------------------+
    |spark_catalog.default.tbl|{delta.appendOnly -> true}|1               |2               |[appendOnly, invariants]|
    +-------------------------+--------------------------+----------------+----------------+------------------------+
    ```

Insert a record.

=== "Scala"

    ```scala
    sql("""
    INSERT INTO tbl
    VALUES (1)
    """)
    ```

Delete a record. It should fail.

=== "Scala"

    ```scala
    sql("""
    DELETE FROM tbl
    WHERE a = 1
    """)
    ```

And it did! 👍

```text
org.apache.spark.sql.delta.DeltaUnsupportedOperationException: [DELTA_CANNOT_MODIFY_APPEND_ONLY] This table is configured to only allow appends. If you would like to permit updates or deletes, use 'ALTER TABLE null SET TBLPROPERTIES (delta.appendOnly=false)'.
  at org.apache.spark.sql.delta.DeltaErrorsBase.modifyAppendOnlyTableException(DeltaErrors.scala:961)
  at org.apache.spark.sql.delta.DeltaErrorsBase.modifyAppendOnlyTableException$(DeltaErrors.scala:957)
  at org.apache.spark.sql.delta.DeltaErrors$.modifyAppendOnlyTableException(DeltaErrors.scala:3382)
  at org.apache.spark.sql.delta.DeltaLog$.assertRemovable(DeltaLog.scala:1009)
  at org.apache.spark.sql.delta.commands.DeleteCommand.$anonfun$run$2(DeleteCommand.scala:122)
  at org.apache.spark.sql.delta.commands.DeleteCommand.$anonfun$run$2$adapted(DeleteCommand.scala:121)
  at org.apache.spark.sql.delta.DeltaLog.withNewTransaction(DeltaLog.scala:227)
  at org.apache.spark.sql.delta.commands.DeleteCommand.$anonfun$run$1(DeleteCommand.scala:121)
  ...
```
