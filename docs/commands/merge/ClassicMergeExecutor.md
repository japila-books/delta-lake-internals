# ClassicMergeExecutor

`ClassicMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for "classic" execution of [MERGE command](index.md) (when requested to [run a merge](MergeIntoCommand.md#runMerge)) when one of the following holds:

* `MERGE` is not [insert-only](index.md#insert-only-merges) (so there are [WHEN MATCHED](MergeIntoCommandBase.md#matchedClauses) or [WHEN NOT MATCHED BY SOURCE](MergeIntoCommandBase.md#notMatchedBySourceClauses) clauses)
* [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is disabled (that would lead to use [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) instead)

??? note "InsertOnlyMergeExecutor"
    When one of the above requirements is not met, [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) is used instead.

With `ClassicMergeExecutor` chosen, [MergeIntoCommand](MergeIntoCommand.md) starts by [finding data files to rewrite](#findTouchedFiles) and, only when there are any `AddFile`s found, requests `ClassicMergeExecutor` to [write out merge changes to a target delta table](#writeAllChanges).

## Finding (Add)Files to Rewrite { #findTouchedFiles }

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): (Seq[AddFile], DeduplicateCDFDeletes)
```

!!! important
    `findTouchedFiles` is such a fine piece of art (_a Delta gem_). It uses a custom accumulator, a UDF (to use this accumulator to record touched file names) and `input_file_name()` standard function for the names of the files read.

    It is always worth keeping in mind that Delta Lake uses files for data storage and that is why `input_file_name()` standard function works. It would not work for non-file-based data sources.

??? note "Example 1: Understanding the Internals of `findTouchedFiles`"

    The following query writes out a 10-element dataset using the default parquet data source to `/tmp/parquet` directory:

    ```scala
    val target = "/tmp/parquet"
    spark.range(10).write.save(target)
    ```

    The number of parquet part files varies based on the number of partitions (CPU cores).

    The following query loads the parquet dataset back alongside `input_file_name()` standard function to mimic `findTouchedFiles`'s behaviour.

    ```scala
    val FILE_NAME_COL = "_file_name_"
    val dataFiles = spark.read.parquet(target).withColumn(FILE_NAME_COL, input_file_name())
    ```

    ```text
    scala> dataFiles.show(truncate = false)
    +---+---------------------------------------------------------------------------------------+
    |id |_file_name_                                                                            |
    +---+---------------------------------------------------------------------------------------+
    |4  |file:///tmp/parquet/part-00007-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |0  |file:///tmp/parquet/part-00001-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |3  |file:///tmp/parquet/part-00006-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |6  |file:///tmp/parquet/part-00011-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |1  |file:///tmp/parquet/part-00003-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |8  |file:///tmp/parquet/part-00014-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |2  |file:///tmp/parquet/part-00004-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |7  |file:///tmp/parquet/part-00012-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |5  |file:///tmp/parquet/part-00009-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |9  |file:///tmp/parquet/part-00015-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    +---+---------------------------------------------------------------------------------------+
    ```

    As you may have thought, not all part files have got data and so they are not included in the dataset. That is when `findTouchedFiles` uses `groupBy` operator and `count` action to calculate match frequency.

    ```text
    val counts = dataFiles.groupBy(FILE_NAME_COL).count()
    scala> counts.show(truncate = false)
    +---------------------------------------------------------------------------------------+-----+
    |_file_name_                                                                            |count|
    +---------------------------------------------------------------------------------------+-----+
    |file:///tmp/parquet/part-00015-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00007-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00003-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00011-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00012-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00006-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00001-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00004-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00009-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00014-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    +---------------------------------------------------------------------------------------+-----+
    ```

    Let's load all the part files in the `/tmp/parquet` directory and find which file(s) have no data.

    ```scala
    import scala.sys.process._
    val cmd = (s"ls $target" #| "grep .parquet").lineStream
    val allFiles = cmd.toArray.toSeq.toDF(FILE_NAME_COL)
      .select(concat(lit(s"file://$target/"), col(FILE_NAME_COL)) as FILE_NAME_COL)
    val joinType = "left_anti" // MergeIntoCommand uses inner as it wants data file
    val noDataFiles = allFiles.join(dataFiles, Seq(FILE_NAME_COL), joinType)
    ```

    Mind that the data vs non-data datasets could be different, but that should not "interfere" with the main reasoning flow.

    ```text
    scala> noDataFiles.show(truncate = false)
    +---------------------------------------------------------------------------------------+
    |_file_name_                                                                            |
    +---------------------------------------------------------------------------------------+
    |file:///tmp/parquet/part-00000-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    +---------------------------------------------------------------------------------------+
    ```

!!! note "Fun Fact: Synomyms"
    The phrases "touched files" and "files to rewrite" are synonyms.

`findTouchedFiles` [records this merge operation](MergeIntoCommandBase.md#recordMergeOperation) with the following:

Property | Value
---------|------
 `extraOpType` | **findTouchedFiles**
 `status` | **MERGE operation - scanning files for matches**
 `sqlMetricName` | [scanTimeMs](MergeIntoCommandBase.md#scanTimeMs)

`findTouchedFiles` registers an internal `SetAccumulator` with `internal.metrics.MergeIntoDelta.touchedFiles` name.

`findTouchedFiles` creates a non-deterministic UDF that records the names of touched files (adds them to the accumulator).

`findTouchedFiles` determines the [AddFiles](../../OptimisticTransactionImpl.md#filterFiles) and prune non-matching files (`dataSkippedFiles`).
With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) for the [AddFiles](../../OptimisticTransactionImpl.md#filterFiles) matching [getTargetOnlyPredicates](MergeIntoCommandBase.md#getTargetOnlyPredicates). Otherwise, `findTouchedFiles` requests for all the [AddFiles](../../OptimisticTransactionImpl.md#filterFiles) (an _accept-all_ predicate).

`findTouchedFiles` determines the join type (`joinType`).
With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` uses `INNER` join type. Otherwise, it is `RIGHT_OUTER` join.

??? note "Inner vs Right Outer Joins"
    Learn more on [Wikipedia](https://en.wikipedia.org/wiki/Join_(SQL)):

    * [Inner Join](https://en.wikipedia.org/wiki/Join_(SQL)#Inner_join)
    * [Right Outer Join](https://en.wikipedia.org/wiki/Join_(SQL)#Right_outer_join)

`findTouchedFiles` determines the matched predicate (`matchedPredicate`).
When [isMatchedOnly](MergeIntoCommandBase.md#isMatchedOnly), `findTouchedFiles` converts the [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses) to their [condition](DeltaMergeIntoClause.md#condition)s, if defined, or falls back to accept-all predicate and then reduces to `Or` expressions. Otherwise, `findTouchedFiles` uses accept-all predicate for the matched predicate.

`findTouchedFiles` creates a Catalyst expression (`incrSourceRowCountExpr`) that [increments](MergeIntoCommandBase.md#incrementMetricAndReturnBool) the [numSourceRows](MergeIntoCommandBase.md#numSourceRows) metric (and returns `true` value).

`findTouchedFiles` [gets the source DataFrame](MergeIntoMaterializeSource.md#getSourceDF) and adds an extra column `_source_row_present_` for the `incrSourceRowCountExpr` expression that is used to `DataFrame.filter` by (and, more importanly and as a side effect, counts the number of source rows).

`findTouchedFiles` [builds a target plan](MergeIntoCommandBase.md#buildTargetPlanWithFiles) with the `dataSkippedFiles` files (and any `columnsToDrop` to be dropped).

`findTouchedFiles` creates a target DataFrame from the target plan (`targetDF`) with two extra columns:

Column Name | Expression
------------|-----------
 `_row_id_` | `monotonically_increasing_id`
 `_file_name_` | `input_file_name`

`findTouchedFiles` creates a joined DataFrame (`joinToFindTouchedFiles`) with the `sourceDF` and `targetDF` dataframes, the [condition](MergeIntoCommandBase.md#condition) as the join condition, and the join type (INNER or RIGHT OUTER).

`findTouchedFiles` creates `recordTouchedFileName` UDF.
`recordTouchedFileName` UDF does two things:

1. Records the names of the touched files (the `_file_name_` column) in the `touchedFilesAccum` accumulator
1. Returns `1`

`findTouchedFiles` uses the two columns above (`_row_id_` and `_file_name_`) to select from the `joinToFindTouchedFiles` dataframe (`collectTouchedFiles`).
`findTouchedFiles` uses the `recordTouchedFileName` UDF with the `_file_name_` column and the `matchedPredicate` (based on the conditional [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses)).
The result is recorded in `one` column.
In other words, the `collectTouchedFiles` dataframe is made up of two columns:

* `_row_id_` (the values of `monotonically_increasing_id` standard function)
* `one` (with the result of the `recordTouchedFileName` UDF)

`findTouchedFiles` calculates the frequency of matches per source row.
`findTouchedFiles` calculates the total of `1`s per `_row_id_` column. The result is recorded in `count` column.
In other words, the `matchedRowCounts` dataframe is made up of two columns:

* `_row_id_` (the values of `monotonically_increasing_id` standard function)
* `count` (the total of the `1`s in `one` column)

`findTouchedFiles` counts the number of rows in the `matchedRowCounts` dataset with `count` above `1` (`multipleMatchCount`) and the total of `count` (`multipleMatchSum`).
If there are no such rows, the values are both `0`.

`findTouchedFiles` [makes a sanity check](MergeIntoCommandBase.md#throwErrorOnMultipleMatches) (based on `multipleMatchCount`).

With multiple matches (occurred and allowed), `findTouchedFiles` stores the difference of `multipleMatchSum` and `multipleMatchCount` in the [multipleMatchDeleteOnlyOvercount](MergeIntoCommandBase.md#multipleMatchDeleteOnlyOvercount).
This is only allowed for delete-only queries.

`findTouchedFiles` prints out the following TRACE message to the logs (with the value from the `touchedFilesAccum` accumulator):

```text
findTouchedFiles: matched files:
  [touchedFileNames]
```

!!! note "Finding Matched Files as Distributed Computation"
    There are a couple of very fundamental Spark "things" in play here:

    1. The `touchedFilesAccum` accumulator
    1. The `recordTouchedFileName` UDF that uses the accumulator
    1. The `collectTouchedFiles` dataframe with `input_file_name` standard function (as  `_file_name_` column)
    1. Calculating `multipleMatchCount` and `multipleMatchSum` values in a Spark job

    All together, it allowed `findTouchedFiles` to run a distributed computation (a Spark job) to collect (_accumulate_) matched files.

`findTouchedFiles`...FIXME (finished at `nameToAddFileMap` and `generateCandidateFileMap`)

!!! danger "FIXME Move the content from MergeIntoCommand"

---

`findTouchedFiles` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) (with a non-[insert-only](MergeIntoCommandBase.md#isInsertOnly) merge or [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) disabled)

## Writing Out All Merge Changes (to Delta Table) { #writeAllChanges }

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile],
  deduplicateCDFDeletes: DeduplicateCDFDeletes): Seq[FileAction]
```

!!! note "Change Data Feed"
    `writeAllChanges` acts differently with or no [Change Data Feed](../../change-data-feed/index.md) enabled.

`writeAllChanges` [records this merge operation](MergeIntoCommandBase.md#recordMergeOperation) with the following:

Property | Value
---------|------
 `extraOpType` | <ul><li>**writeAllUpdatesAndDeletes** for [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge)<li>**writeAllChanges** otherwise</ul>
 `status` | **MERGE operation - Rewriting [filesToRewrite] files**
 `sqlMetricName` | [rewriteTimeMs](MergeIntoCommandBase.md#rewriteTimeMs)

??? note "CDF Generation"
    `writeAllChanges` asserts that one of the following holds:

    1. CDF generation is disabled (based on the given `DeduplicateCDFDeletes` flag)
    1. [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) is enabled

    Otherwise, `writeAllChanges` reports an `IllegalArgumentException`:

    ```text
    CDF delete duplication is enabled but overall the CDF generation is disabled
    ```

`writeAllChanges` creates a `DataFrame` for the [target plan](#buildTargetPlanWithFiles) with the given [AddFile](../../AddFile.md)s to rewrite (`filesToRewrite`) (and no `columnsToDrop`).

`writeAllChanges` determines the join type based on [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge):

* `rightOuter` when enabled
* `fullOuter` otherwise

??? note "`shouldOptimizeMatchedOnlyMerge` Used Twice"
    [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge) is used twice for the following:

    1. `extraOpType` to [record this merge operation](MergeIntoCommandBase.md#recordMergeOperation)
    1. The join type

    shouldOptimizeMatchedOnlyMerge | extraOpType | joinType
    -------------------------------|-------------|---------
    `true` | **writeAllUpdatesAndDeletes** | RIGHT OUTER
    `false` | **writeAllChanges** | FULL OUTER

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges using [joinType] join:
  source.output: [source]
  target.output: [target]
  condition: [condition]
  newTarget.output: [baseTargetDF]
```

`writeAllChanges` [creates Catalyst expressions to increment SQL metrics](MergeIntoCommandBase.md#incrementMetricAndReturnBool):

Metric Name | valueToReturn
------------|--------------
 [numSourceRowsInSecondScan](MergeIntoCommandBase.md#numSourceRowsInSecondScan) | `true`
 [numTargetRowsCopied](MergeIntoCommandBase.md#numTargetRowsCopied) | `false`

`writeAllChanges` creates a DataFrame (`joinedDF`):

1. `writeAllChanges` adds an extra column `_source_row_index` (with `monotonically_increasing_id` expression) to the [source dataframe](MergeIntoMaterializeSource.md#getSourceDF) (possibly materialized) when the given `DeduplicateCDFDeletes` is enabled and `includesInserts`. The goal is to identify inserted rows during the cdf deleted rows deduplication.
1. `writeAllChanges` adds an extra column `_source_row_present_` (with the expression to increment the [numSourceRowsInSecondScan](MergeIntoCommandBase.md#numSourceRowsInSecondScan) metric) to `sourceDF` (`left`)
1. `writeAllChanges` adds an extra column `_target_row_present_` (with `true` value) to `baseTargetDF` (`targetDF`)
1. With `DeduplicateCDFDeletes` enabled, `writeAllChanges` adds an extra column `_target_row_index_` (with `monotonically_increasing_id` expression) to `targetDF` (`right`)
1. In the end, the left and right DataFrames are joined (using `DataFrame.join` operator) with the [condition](MergeIntoCommandBase.md#condition) as the join condition and the determined join type (`rightOuter` or `fullOuter`)

!!! note "FIXME Explain why all the above columns are needed"

`writeAllChanges` [generatePrecomputedConditionsAndDF](#generatePrecomputedConditionsAndDF) with the joined DataFrame and the given merge clauses ([matchedClauses](MergeIntoCommandBase.md#matchedClauses), [notMatchedClauses](MergeIntoCommandBase.md#notMatchedClauses), [notMatchedBySourceClauses](MergeIntoCommandBase.md#notMatchedBySourceClauses)).

`writeAllChanges` generates the output columns (`outputCols`):

1. `writeAllChanges` [determines the target output columns](MergeIntoCommandBase.md#getTargetOutputCols) (`targetOutputCols`)
1. `writeAllChanges` adds one extra `_row_dropped_` possibly with another `_change_type` extra column if [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) to the target output columns (`outputColNames`)
1. `writeAllChanges` adds the expression to increment the [incrNoopCountExpr](#incrNoopCountExpr) metric possibly with another sentinel `null` expression if [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) to the target output columns (`noopCopyExprs`)
1. In the end, `writeAllChanges` [generateWriteAllChangesOutputCols](MergeOutputGeneration.md#generateWriteAllChangesOutputCols)

`writeAllChanges` creates an output DataFrame (`outputDF`) based on [Change Data Feed](../../change-data-feed/index.md):

* With [Change Data Feed](../../change-data-feed/index.md) enabled, `writeAllChanges` [generateCdcAndOutputRows](MergeOutputGeneration.md#generateCdcAndOutputRows) (with `joinedAndPrecomputedConditionsDF` as the source dataframe)
* Otherwise, `writeAllChanges` selects the `outputCols` columns from the `joinedAndPrecomputedConditionsDF` dataframe (`Dataset.select` operator)

`writeAllChanges` makes sure that the output dataframe includes only rows that are not dropped (with `_row_dropped_` column being `false` using `Dataset.filter` operator).

`writeAllChanges` drops the `_row_dropped_` column from the output dataframe so it does not leak to the output.

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges: join output plan:
[outputDF]
```

`writeAllChanges` [writes out](MergeIntoCommandBase.md#writeFiles) the `outputDF` DataFrame (that gives [FileAction](../../FileAction.md)s).

In the end, `writeAllChanges` updates the [metrics](MergeIntoCommandBase.md#metrics).

---

`writeAllChanges` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) (with a non-[insert-only](MergeIntoCommandBase.md#isInsertOnly) merge or [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) disabled)

## Logging

`ClassicMergeExecutor` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
