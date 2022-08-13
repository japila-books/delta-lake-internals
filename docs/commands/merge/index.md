# Merge Command

Delta Lake supports merging records into a delta table using the following high-level operators:

* [MERGE INTO](../../DeltaAnalysis.md#MergeIntoTable) SQL command ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable))
* [DeltaTable.merge](../../DeltaTable.md#merge)

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