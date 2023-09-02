# Merge Command

Delta Lake supports merging records into a delta table using the following high-level operators:

* [MERGE INTO](../../DeltaAnalysis.md#MergeIntoTable) SQL command ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable))
* [DeltaTable.merge](../../DeltaTable.md#merge)

Merge command is executed as a transactional [MergeIntoCommand](MergeIntoCommand.md).

While [running a merge](MergeIntoCommand.md#runMerge), `MergeIntoCommand` can choose between the available [MergeOutputGeneration](MergeOutputGeneration.md)s ([ClassicMergeExecutor](ClassicMergeExecutor.md) or [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)) for an optimized output of the merge command to write out.

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

[InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md#writeOnlyInserts) uses LEFT ANTI join to find the rows to insert (relying on [Data Skipping](../../data-skipping/index.md) along the way).

### Single Insert-Only Merges

There is a special handling of [single INSERT-only MERGEs](MergeIntoCommand.md#isSingleInsertOnly).

=== "SQL"

    ```sql
    MERGE INTO merge_demo to
    USING merge_demo_source from
    ON to.id = from.id
    WHEN NOT MATCHED THEN INSERT *;
    ```

## Schema Evolution (Auto Schema Merging) { #schema-evolution }

Merge command supports schema evolution for star and non-star [UPDATEs and INSERTs](DeltaMergeInto.md#resolveReferencesAndSchema) (with columns not in a target delta table) when [schema.autoMerge.enabled](../../configuration-properties/index.md#schema.autoMerge.enabled) is enabled.

!!! note "Explore Star UPDATEs with Nested Columns"
    Star [WHEN MATCHED UPDATE](DeltaMergeIntoMatchedUpdateClause.md)s with nested columns look very interesting.

!!! note "Explore Schema Evolution and Types"
    Schema merging allows for implicit conversions so the type of the source may be different in the target (cf. the note at the end of [resolveReferencesAndSchema](DeltaMergeInto.md#resolveReferencesAndSchema)).
    
    Can this lead to any troubles? 🤔

??? note "Learn More"
    Until this note is here, learn more in [resolveClause](DeltaMergeInto.md#resolveClause).

With [Auto Schema Merging](../../configuration-properties/index.md#schema.autoMerge.enabled) enabled, Delta Lake adds the new columns and nested fields to the target table (assigned to in [merge actions](DeltaMergeIntoClause.md#actions) of the [WHEN MATCHED](DeltaMergeInto.md#matchedClauses) and the [WHEN NOT MATCHED](DeltaMergeInto.md#notMatchedClauses) clauses that are not already part of the target schema).

??? note "NOT MATCHED BY SOURCE Excluded"
    [NOT MATCHED BY SOURCE](DeltaMergeIntoNotMatchedBySourceClause.md)s are excluded since they can't reference source columns by definition and thus can't introduce new columns in the target schema.

## Matched-Only Merges

A [matched-only merge](MergeIntoCommandBase.md#isMatchedOnly) contains one or more [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses) only (with neither [WHEN NOT MATCHED](MergeIntoCommandBase.md#notMatchedClauses) nor [WHEN NOT MATCHED BY SOURCE](MergeIntoCommandBase.md#notMatchedBySourceClauses) clauses).

In other words, a matched-only merge is a merge with [UPDATE](DeltaMergeIntoMatchedUpdateClause.md)s and [DELETE](DeltaMergeIntoMatchedDeleteClause.md)s only, and no `WHEN NOT MATCHED` clauses.

With [merge.optimizeMatchedOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_MATCHED_ONLY_ENABLED) enabled, Delta Lake optimizes matched-only merges to use a RIGHT OUTER join (instead of a FULL OUTER join) while [writing out all merge changes](ClassicMergeExecutor.md#writeAllChanges).

## Change Data Feed

With [Change Data Feed](../../change-data-feed/index.md) enabled on a delta table that is the target table of a merge command, `MergeIntoCommand`...FIXME

* [DeduplicateCDFDeletes](DeduplicateCDFDeletes.md)
* [WHEN NOT MATCHED THEN INSERT Sensitivity](MergeOutputGeneration.md#deduplicateCDFDeletes)

## Merge and Joins

Merge command uses different joins when executed.

## Repartition Before Write

[writeFiles](MergeIntoCommandBase.md#writeFiles) can repartition the output dataframe based on [merge.repartitionBeforeWrite.enabled](../../configuration-properties/index.md#merge.repartitionBeforeWrite.enabled).

## Materialized Source

The source of `MERGE` command can be [materialized](MergeIntoMaterializeSource.md#shouldMaterializeSource) based on [spark.databricks.delta.merge.materializeSource](../../configuration-properties/index.md#merge.materializeSource) configuration property.

## Demo

[Demo: Merge Operation](../../demo/merge-operation.md)

## Examples

### Conditional Update with Delete

!!! tip
    Use [this notebook](https://github.com/jaceklaskowski/learn-databricks/blob/main/Delta%20Lake/Merge.sql).

=== "SQL"

    ```sql
    CREATE TABLE source
    USING delta
    AS VALUES
      (0, 0),
      (1, 10),
      (2, 20) AS data(key, value);
    ```

    ```sql
    CREATE TABLE target
    USING delta
    AS VALUES
      (1, 1),
      (2, 2),
      (3, 3) AS data(key, value);
    ```

    ```sql
    MERGE INTO target t
    USING source s
    ON s.key = t.key
    WHEN MATCHED AND s.key <> 1 THEN UPDATE SET key = s.key, value = s.value
    WHEN MATCHED THEN DELETE
    ```

## Logging

Logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).

## Learn More

* [Optimizing Merge on Delta Lake](https://youtu.be/o2k9PICWdx0) (video)
