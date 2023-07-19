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

**Insert-Only Merges** are MERGE queries with [WHEN NOT MATCHED clauses only](MergeIntoCommandBase.md#isInsertOnly) ([DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md)s precisely that can only be [WHEN NOT MATCHED THEN INSERT clauses](DeltaMergeIntoNotMatchedInsertClause.md)).

```antlr
notMatchedClause
    : WHEN NOT MATCHED (BY TARGET)? (AND notMatchedCond)? THEN notMatchedAction
    ;

notMatchedAction
    : INSERT *
    | INSERT (columns) VALUES (expressions)
    ;
```

Delta Lake applies extra optimizations to insert-only merges only with [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) enabled.

For insert-only merges, [merge](MergeIntoCommand.md#runMerge) becomes a [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts) (using [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)) (instead of [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges) using [ClassicMergeExecutor](ClassicMergeExecutor.md)).

### Single Insert-Only Merges

There is a special handling of [single INSERT-only MERGEs](MergeIntoCommand.md#isSingleInsertOnly).

=== "SQL"

    ```sql
    MERGE INTO merge_demo to
    USING merge_demo_source from
    ON to.id = from.id
    WHEN NOT MATCHED THEN INSERT *;
    ```

## Schema Evolution

Merge command supports schema evolution for [non-star UPDATEs and INSERTs](DeltaMergeInto.md#resolveReferencesAndSchema) (when a column is not in the target delta table) when [schema.autoMerge.enabled](../../configuration-properties/index.md#schema.autoMerge.enabled) is enabled.

With [schema evolution](../../configuration-properties/index.md#schema.autoMerge.enabled) enabled, Delta Lake adds new columns and nested fields to a target table (assigned to in [merge actions](DeltaMergeIntoClause.md#actions) of the [WHEN MATCHED](DeltaMergeInto.md#matchedClauses) and the [WHEN NOT MATCHED](DeltaMergeInto.md#notMatchedClauses) clauses that are not already part of the target schema).

??? note "NOT MATCHED BY SOURCE Excluded"
    [NOT MATCHED BY SOURCE](DeltaMergeIntoNotMatchedBySourceClause.md)s are excluded since they can't reference source columns by definition and thus can't introduce new columns in the target schema.

## Demo

[Demo: Merge Operation](../../demo/merge-operation.md)

## Logging

Logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).

## Learn More

* [Optimizing Merge on Delta Lake](https://youtu.be/o2k9PICWdx0) (video)
