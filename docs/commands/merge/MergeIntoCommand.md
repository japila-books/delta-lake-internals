# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](../DeltaCommand.md) (indirectly as a [MergeIntoCommandBase](MergeIntoCommandBase.md)) that represents a [DeltaMergeInto](DeltaMergeInto.md) logical command at execution.

`MergeIntoCommand` is transactional (and starts a new transaction when [executed](#runMerge)).

`MergeIntoCommand` can [optimize output generation](MergeOutputGeneration.md) ([ClassicMergeExecutor](ClassicMergeExecutor.md) or [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)).

## Creating Instance

`MergeIntoCommand` takes the following to be created:

* [Source Data](MergeIntoCommandBase.md#source)
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

At this stage, `runMerge` is finally ready to apply all the necessary changes to the delta table ( _execute this merge_) that result in a collection of [FileAction](../../FileAction.md)s (`deltaActions`).

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

## <span id="writeInsertsOnlyWhenNoMatchedClauses"> Writing Out Single Insert-Only Merge

```scala
writeInsertsOnlyWhenNoMatchedClauses(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): Seq[FileAction]
```

In the end, `writeInsertsOnlyWhenNoMatchedClauses` returns the [FileAction](../../FileAction.md)s (from [writing out data](../../TransactionalWrite.md#writeFiles)).

`writeInsertsOnlyWhenNoMatchedClauses` is used when:

* `MergeIntoCommand` is [executed](#run) (for [single insert-only merge](#isSingleInsertOnly) with [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/DeltaSQLConf.md#MERGE_INSERT_ONLY_ENABLED) enabled)

### Target Output Columns { #writeInsertsOnlyWhenNoMatchedClauses-outputCols }

`writeInsertsOnlyWhenNoMatchedClauses` gets the names of the output (_target_) columns.

`writeInsertsOnlyWhenNoMatchedClauses` creates a collection of output columns with the target names and the [resolved DeltaMergeActions](DeltaMergeIntoClause.md#resolvedActions) of a single FIXME (as `Alias` expressions).

### <span id="writeInsertsOnlyWhenNoMatchedClauses-sourceDF"> Source DataFrame

`writeInsertsOnlyWhenNoMatchedClauses` [creates a UDF](#makeMetricUpdateUDF) to update [numSourceRows](#numSourceRows) metric.

`writeInsertsOnlyWhenNoMatchedClauses` creates a source `DataFrame` for the [source](#source) data with `Dataset.filter`s with the UDF and the FIXME of the FIXME (if defined) or `Literal.TrueLiteral`.

!!! note "Use condition for filter pushdown optimization"
    The `condition` of this single FIXME is pushed down to the [source](#source) when Spark SQL optimizes the query.

### <span id="writeInsertsOnlyWhenNoMatchedClauses-dataSkippedFiles"> Data-Skipped AddFiles

`writeInsertsOnlyWhenNoMatchedClauses` splits conjunctive predicates (`And` expressions) in the [merge condition](#condition) and determines a so-called _targetOnlyPredicates_ (predicates with the [target](#target) columns only). `writeInsertsOnlyWhenNoMatchedClauses` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) matching the target-only predicates (that gives [AddFile](../../AddFile.md)s).

!!! note "Merge Condition and Data Skipping"
    The [merge condition](#condition) of this [MergeIntoCommand](MergeIntoCommand.md) is used for [Data Skipping](../../data-skipping/index.md).

### <span id="writeInsertsOnlyWhenNoMatchedClauses-insertDf"> Insert DataFrame

`writeInsertsOnlyWhenNoMatchedClauses` [creates a UDF](#makeMetricUpdateUDF) to update [numTargetRowsInserted](#numTargetRowsInserted) metric.

`writeInsertsOnlyWhenNoMatchedClauses` left-anti joins the source `DataFrame` with the target `DataFrame` on the [merge condition](#condition). `writeInsertsOnlyWhenNoMatchedClauses` selects the output columns and uses `Dataset.filter` with the UDF.

??? note "Demo: Left-Anti Join"

    ```scala
    val source = Seq(0, 1, 2, 3).toDF("id") // (1)!
    val target = Seq(3, 4, 5).toDF("id") // (2)!
    val usingColumns = Seq("id")
    val q = source.join(target, usingColumns, "leftanti")
    ```

    1. Equivalent to `spark.range(4)`

        ```text
        +---+
        | id|
        +---+
        |  0|
        |  1|
        |  2|
        |  3|
        +---+
        ```

    1. Equivalent to `spark.range(3, 6)`

        ```text
        +---+
        | id|
        +---+
        |  3|
        |  4|
        |  5|
        +---+
        ```

    ```text
    scala> q.show
    +---+
    | id|
    +---+
    |  0|
    |  1|
    |  2|
    +---+
    ```

### <span id="writeInsertsOnlyWhenNoMatchedClauses-writeFiles"> writeFiles

`writeInsertsOnlyWhenNoMatchedClauses` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [write out](../../TransactionalWrite.md#writeFiles) the [insertDf](#writeInsertsOnlyWhenNoMatchedClauses-insertDf) (possibly [repartitionIfNeeded](#repartitionIfNeeded) on the [partitionColumns](../../Metadata.md#partitionColumns) of the [target delta table](#targetFileIndex)).

!!! note
    This step triggers a Spark write job (and this active [transaction](../../OptimisticTransaction.md) is marked as [hasWritten](../../TransactionalWrite.md#hasWritten)).

## <span id="findTouchedFiles"> Finding Files to Rewrite

`findTouchedFiles` [builds a logical query plan](#buildTargetPlanWithFiles) for the files (matching the predicates) and creates another `DataFrame` for the target data. `findTouchedFiles` adds two columns to the target dataframe:

1. `_row_id_` for `monotonically_increasing_id()` standard function
1. `_file_name_` for `input_file_name()` standard function

`findTouchedFiles` creates (a `DataFrame` that is) an INNER JOIN of the source and target `DataFrame`s using the [condition](#condition) expression.

`findTouchedFiles` takes the joined dataframe and selects `_row_id_` column and the [recordTouchedFileName](#findTouchedFiles-recordTouchedFileName) UDF on the `_file_name_` column as `one`. The `DataFrame` is internally known as `collectTouchedFiles`.

`findTouchedFiles` uses `groupBy` operator on `_row_id_` to calculate a sum of all the values in the `one` column (as `count` column) in the two-column `collectTouchedFiles` dataset. The `DataFrame` is internally known as `matchedRowCounts`.

!!! note
    No Spark job has been submitted yet. `findTouchedFiles` is still in "query preparation" mode.

`findTouchedFiles` uses `filter` on the `count` column (in the `matchedRowCounts` dataset) with values greater than `1`. If there are any, `findTouchedFiles` throws an `UnsupportedOperationException` exception:

```text
Cannot perform MERGE as multiple source rows matched and attempted to update the same
target row in the Delta table. By SQL semantics of merge, when multiple source rows match
on the same target row, the update operation is ambiguous as it is unclear which source
should be used to update the matching target row.
You can preprocess the source table to eliminate the possibility of multiple matches.
```

!!! note
    Since `findTouchedFiles` uses `count` action there should be a Spark SQL query reported (and possibly Spark jobs) in web UI.

`findTouchedFiles` requests the `touchedFilesAccum` accumulator for the touched file names.

??? note "Example 2: Understanding the Internals of `findTouchedFiles`"

    ```scala
    val TOUCHED_FILES_ACCUM_NAME = "MergeIntoDelta.touchedFiles"
    val touchedFilesAccum = spark.sparkContext.collectionAccumulator[String](TOUCHED_FILES_ACCUM_NAME)
    val recordTouchedFileName = udf { (fileName: String) => {
      touchedFilesAccum.add(fileName)
      1
    }}.asNondeterministic()
    ```

    ```scala
    val target = "/tmp/parquet"
    spark.range(10).write.save(target)
    ```

    ```scala
    val FILE_NAME_COL = "_file_name_"
    val dataFiles = spark.read.parquet(target).withColumn(FILE_NAME_COL, input_file_name())
    val collectTouchedFiles = dataFiles.select(col(FILE_NAME_COL), recordTouchedFileName(col(FILE_NAME_COL)).as("one"))
    ```

    ```text
    scala> collectTouchedFiles.show(truncate = false)
    +---------------------------------------------------------------------------------------+---+
    |_file_name_                                                                            |one|
    +---------------------------------------------------------------------------------------+---+
    |file:///tmp/parquet/part-00007-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00001-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00006-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00011-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00003-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00014-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00004-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00012-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00009-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00015-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    +---------------------------------------------------------------------------------------+---+    
    ```

    ```scala
    import scala.collection.JavaConverters._
    val touchedFileNames = touchedFilesAccum.value.asScala.toSeq
    ```

    Use the Stages tab in web UI to review the accumulator values.

`findTouchedFiles` prints out the following TRACE message to the logs:

```text
findTouchedFiles: matched files:
  [touchedFileNames]
```

`findTouchedFiles` [generateCandidateFileMap](#generateCandidateFileMap) for the [files that match the target-only predicates](#findTouchedFiles-dataSkippedFiles).

`findTouchedFiles` [getTouchedFile](#getTouchedFile) for every touched file name.

`findTouchedFiles` updates the following performance metrics:

* [numTargetFilesBeforeSkipping](#numTargetFilesBeforeSkipping) and adds the [numOfFiles](#numOfFiles) of the [Snapshot](../../OptimisticTransaction.md#snapshot) of the given [OptimisticTransaction](../../OptimisticTransaction.md)
* [numTargetFilesAfterSkipping](#numTargetFilesAfterSkipping) and adds the number of the [files that match the target-only predicates](#findTouchedFiles-dataSkippedFiles)
* [numTargetFilesRemoved](#numTargetFilesRemoved) and adds the number of the touched files

In the end, `findTouchedFiles` gives the touched files (as [AddFile](../../AddFile.md)s).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.MergeIntoCommand` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.MergeIntoCommand.name = org.apache.spark.sql.delta.commands.MergeIntoCommand
logger.MergeIntoCommand.level = all
```

Refer to [Logging](../../logging.md).
