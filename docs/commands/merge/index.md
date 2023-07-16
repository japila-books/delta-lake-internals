# Merge Command

Delta Lake supports merging records into a delta table using the following high-level operators:

* [MERGE INTO](../../DeltaAnalysis.md#MergeIntoTable) SQL command ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable))
* [DeltaTable.merge](../../DeltaTable.md#merge)

Merge command is executed as a transactional [MergeIntoCommand](MergeIntoCommand.md).

!!! note "SQL MERGE (DML Statement)"
    Quoting [Wikipedia](https://en.wikipedia.org/wiki/Merge_(SQL)):

    > `MERGE` (also called _upsert_) statements are used to simultaneously `INSERT` new records or `UPDATE` existing records depending on whether condition matches.

    Merge command lets you transactionally execute multiple `INSERT`, `UPDATE`, and `DELETE` DML statements.

## Insert-Only Merges

[Insert-only merges](MergeIntoCommandBase.md#isInsertOnly) have got special support but only with [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) enabled.

## Single INSERT-only MERGEs

There is a special handling of [single INSERT-only MERGEs](MergeIntoCommand.md#isSingleInsertOnly).

=== "SQL"

    ```sql
    MERGE INTO merge_demo to
    USING merge_demo_source from
    ON to.id = from.id
    WHEN NOT MATCHED THEN INSERT *;
    ```

## Demo

* [Demo: Merge Operation](../../demo/merge-operation.md)

## Logging

Logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).

## Learn More

* [Optimizing Merge on Delta Lake](https://youtu.be/o2k9PICWdx0) (video)
