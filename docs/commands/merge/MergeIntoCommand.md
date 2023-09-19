# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](../DeltaCommand.md) (indirectly as a [MergeIntoCommandBase](MergeIntoCommandBase.md)) that represents a [DeltaMergeInto](DeltaMergeInto.md) logical command at execution.

`MergeIntoCommand` is transactional (and starts a new transaction when [executed](#runMerge)).

`MergeIntoCommand` can [optimize output generation](MergeOutputGeneration.md) ([ClassicMergeExecutor](ClassicMergeExecutor.md) or [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)).

## Creating Instance

`MergeIntoCommand` takes the following to be created:

* [Source Table](MergeIntoCommandBase.md#source)
* <span id="target"> Target table ([LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="targetFileIndex"> [TahoeFileIndex](../../TahoeFileIndex.md)
* <span id="condition"> Merge Condition ([Expression]({{ book.spark_sql }}/expressions/Expression/))
* <span id="matchedClauses"> [WHEN MATCHED Clause](DeltaMergeIntoMatchedClause.md)s
* <span id="notMatchedClauses"> [WHEN NOT MATCHED Clause](DeltaMergeIntoNotMatchedClause.md)s
* <span id="notMatchedBySourceClauses"> [WHEN NOT MATCHED BY SOURCE Clause](DeltaMergeIntoNotMatchedBySourceClause.md)s
* [Migrated Schema](#migratedSchema)

`MergeIntoCommand` is created when:

* [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule is executed (to resolve a [DeltaMergeInto](DeltaMergeInto.md) logical command)

### Migrated Schema { #migratedSchema }

```scala
migratedSchema: Option[StructType]
```

`MergeIntoCommand` can be given a `migratedSchema` ([Spark SQL]({{ book.spark_sql }}/types/StructType)).

## Output Attributes { #output }

??? note "Command"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command/#output)) abstraction.

`output` is a fixed-length collection of the following `AttributeReference`s:

Name | Type
-----|-----
 `num_affected_rows` | `LongType`
 `num_updated_rows` | `LongType`
 `num_deleted_rows` | `LongType`
 `num_inserted_rows` | `LongType`

## Running Merge { #runMerge }

??? note "MergeIntoCommandBase"

    ```scala
    runMerge(
      spark: SparkSession): Seq[Row]
    ```

    `runMerge` is part of the [MergeIntoCommandBase](MergeIntoCommandBase.md#runMerge) abstraction.

`runMerge` records the start time.

`runMerge` [starts a new transaction](../../DeltaLog.md#withNewTransaction) (on the [targetDeltaLog](MergeIntoCommandBase.md#targetDeltaLog)).

If [hasBeenExecuted](#hasBeenExecuted), `runMerge` [announces the updates](../DeltaCommand.md#sendDriverMetrics) of the [metrics](MergeIntoCommandBase.md#metrics) and quits early (returns no `Row`s).

!!! warning "FIXME When would `hasBeenExecuted` happen?"

??? note "DeltaAnalysisException"
    In case the schema of the [target](#target) table changed (compared to the time the [transaction started](MergeIntoCommandBase.md#targetDeltaLog)), `runMerge` throws a `DeltaAnalysisException`.

    ---

    The [schema](../../Metadata.md#schema) of a delta table is in the [Metadata](../../Metadata.md#schema) of the [OptimisticTransactionImpl](../../OptimisticTransactionImpl.md).

With [Auto Schema Merging](MergeIntoCommandBase.md#canMergeSchema) enabled (that boils down to [schema.autoMerge.enabled](../../configuration-properties/index.md#schema.autoMerge.enabled)), `runMerge` [updates the metadata](../../ImplicitMetadataOperation.md#updateMetadata).

`runMerge` [prepareSourceDFAndReturnMaterializeReason](#prepareSourceDFAndReturnMaterializeReason).

At this stage, `runMerge` is finally ready to apply all the necessary changes to the delta table (_execute this merge_) that result in a collection of [FileAction](../../FileAction.md)s (`deltaActions`).

`runMerge` writes out [inserts](InsertOnlyMergeExecutor.md#writeOnlyInserts) or [all changes](ClassicMergeExecutor.md#writeAllChanges) based on the following:

* Whether this merge is [insert-only](index.md#insert-only-merges) and [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) is enabled
* Whether there are any [files to rewrite](ClassicMergeExecutor.md#findTouchedFiles)

!!! note "`runMerge` and `MergeOutputGeneration`s"
    `runMerge` uses [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) or [ClassicMergeExecutor](ClassicMergeExecutor.md) output generators.

`runMerge` [collects the merge statistics](MergeIntoCommandBase.md#collectMergeStats).

`runMerge` requests the `CacheManager` ([Spark SQL]({{ book.spark_sql }}/CacheManager)) to re-cache all the cached logical plans that refer to the [target](#target) logical plan (since it has just changed).

`runMerge` [announces the updates](../DeltaCommand.md#sendDriverMetrics) of the [metrics](MergeIntoCommandBase.md#metrics).

In the end, `runMerge` returns the following performance metrics (as a single `Row` with the [output](#output)):

Column Name | Metric
------------|-------
 `num_affected_rows` | Total of the values of the metrics: <ul><li>[number of updated rows](MergeIntoCommandBase.md#numTargetRowsUpdated)<li>[number of deleted rows](MergeIntoCommandBase.md#numTargetRowsDeleted)<li>[number of inserted rows](MergeIntoCommandBase.md#numTargetRowsInserted)</ul>
 `num_updated_rows` | [number of updated rows](MergeIntoCommandBase.md#numTargetRowsUpdated)
 `num_deleted_rows` | [number of deleted rows](MergeIntoCommandBase.md#numTargetRowsDeleted)
 `num_inserted_rows` | [number of inserted rows](MergeIntoCommandBase.md#numTargetRowsInserted)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.MergeIntoCommand` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.MergeIntoCommand.name = org.apache.spark.sql.delta.commands.MergeIntoCommand
logger.MergeIntoCommand.level = all
```

Refer to [Logging](../../logging.md).
