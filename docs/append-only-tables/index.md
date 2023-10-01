---
hide:
  - toc
---

# Append-Only Tables

**Append-Only Tables** is a [table feature](AppendOnlyTableFeature.md) that [forbids deleting data files](../DeltaLog.md#assertRemovable) that could be a result of the following:

* [Delete](../commands/delete/index.md), [Update](../commands/update/index.md), [WriteIntoDelta](../commands/WriteIntoDelta.md) (in `Overwrite` save mode) commands
* `DeltaSink` to [addBatch](../delta/DeltaSink.md#addBatch) in `Complete` output mode
* [RemoveFile](../RemoveFile.md)s with [dataChange](../RemoveFile.md#dataChange) (at [prepareCommit](../OptimisticTransactionImpl.md#prepareCommit))

Append-Only Tables is enabled on a delta table using [delta.appendOnly](../DeltaConfigs.md#IS_APPEND_ONLY) table property (indirectly, through [AppendOnlyTableFeature](AppendOnlyTableFeature.md) that is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md) and uses this table property).

## Demo

Create a delta table with [delta.appendOnly](../DeltaConfigs.md#appendOnly) table property enabled.

=== "SQL"

    ```sql
    CREATE TABLE tbl(a int)
    USING delta
    TBLPROPERTIES (
      'delta.appendOnly' = 'true'
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
    +-------------------------+--------------------------+----------------+----------------+------------------------+
    |name                     |properties                |minReaderVersion|minWriterVersion|tableFeatures           |
    +-------------------------+--------------------------+----------------+----------------+------------------------+
    |spark_catalog.default.tbl|{delta.appendOnly -> true}|1               |2               |[appendOnly, invariants]|
    +-------------------------+--------------------------+----------------+----------------+------------------------+
    ```

Insert a record.

=== "SQL"

    ```sql
    INSERT INTO tbl
    VALUES (1)
    ```

Delete a record. It should fail.

=== "SQL"

    ```sql
    DELETE FROM tbl
    WHERE a = 1
    ```

And it did 👍

```text
org.apache.spark.sql.delta.DeltaUnsupportedOperationException: This table is configured to only allow appends. If you would like to permit updates or deletes, use 'ALTER TABLE null SET TBLPROPERTIES (delta.appendOnly=false)'.
  at org.apache.spark.sql.delta.DeltaErrorsBase.modifyAppendOnlyTableException(DeltaErrors.scala:890)
  at org.apache.spark.sql.delta.DeltaErrorsBase.modifyAppendOnlyTableException$(DeltaErrors.scala:886)
  at org.apache.spark.sql.delta.DeltaErrors$.modifyAppendOnlyTableException(DeltaErrors.scala:2884)
  at org.apache.spark.sql.delta.DeltaLog$.assertRemovable(DeltaLog.scala:947)
  at org.apache.spark.sql.delta.commands.DeleteCommand.$anonfun$run$2(DeleteCommand.scala:115)
  at org.apache.spark.sql.delta.commands.DeleteCommand.$anonfun$run$2$adapted(DeleteCommand.scala:114)
  at org.apache.spark.sql.delta.DeltaLog.withNewTransaction(DeltaLog.scala:216)
  at org.apache.spark.sql.delta.commands.DeleteCommand.$anonfun$run$1(DeleteCommand.scala:114)
  ...
```
