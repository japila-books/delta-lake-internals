# MergeIntoCommandBase

`MergeIntoCommandBase` is a [DeltaCommand](../DeltaCommand.md) and an [extension](#contract) of the `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) abstraction for [merge delta commands](#implementations).

`MergeIntoCommandBase` is a [MergeIntoMaterializeSource](MergeIntoMaterializeSource.md).

## Contract (Subset)

### Merge Condition { #condition }

```scala
condition: Expression
```

The "join" condition of this merge

See:

* [MergeIntoCommand](MergeIntoCommand.md#condition)

Used when:

* `MergeIntoCommandBase` is requested to [collectMergeStats](#collectMergeStats) and [getTargetOnlyPredicates](#getTargetOnlyPredicates)
* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles) and [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts) (with `filterMatchedRows` enabled to trim the [source table](MergeIntoMaterializeSource.md#getSourceDF))

### WHEN MATCHED Clauses { #matchedClauses }

```scala
matchedClauses: Seq[DeltaMergeIntoMatchedClause]
```

[DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)s

See:

* [MergeIntoCommand](MergeIntoCommand.md#matchedClauses)

Used when:

* `MergeIntoCommandBase` is requested to [isMatchedOnly](#isMatchedOnly), [isInsertOnly](#isInsertOnly), [collectMergeStats](#collectMergeStats), [isOnlyOneUnconditionalDelete](#isOnlyOneUnconditionalDelete), [getTargetOnlyPredicates](#getTargetOnlyPredicates)
* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles), [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

### WHEN NOT MATCHED Clauses { #notMatchedClauses }

```scala
notMatchedClauses: Seq[DeltaMergeIntoNotMatchedClause]
```

[DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md)s

See:

* [MergeIntoCommand](MergeIntoCommand.md#notMatchedClauses)

Used when:

* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)
* `MergeIntoCommandBase` is requested to [isMatchedOnly](#isMatchedOnly), [isInsertOnly](#isInsertOnly), [includesInserts](#includesInserts), [collectMergeStats](#collectMergeStats)
* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts), [generateInsertsOnlyOutputDF](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputDF), [generateOneInsertOutputCols](InsertOnlyMergeExecutor.md#generateOneInsertOutputCols)

### WHEN NOT MATCHED BY SOURCE Clauses { #notMatchedBySourceClauses }

```scala
notMatchedBySourceClauses: Seq[DeltaMergeIntoNotMatchedBySourceClause]
```

[DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md)s

See:

* [MergeIntoCommand](MergeIntoCommand.md#notMatchedBySourceClauses)

Used when:

* `MergeIntoCommandBase` is requested to [isMatchedOnly](#isMatchedOnly), [isInsertOnly](#isInsertOnly), [collectMergeStats](#collectMergeStats)
* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles), [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

### Running Merge { #runMerge }

```scala
runMerge(
  spark: SparkSession): Seq[Row]
```

See:

* [MergeIntoCommand](MergeIntoCommand.md#runMerge)

Used when:

* `MergeIntoCommandBase` is requested to [run](#run)

### Source Data { #source }

```scala
source: LogicalPlan
```

A `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan)) of the source data to merge from (internally referred to as _source_)

See:

* [MergeIntoCommand](MergeIntoCommand.md#source)

Used when:

* `MergeIntoCommandBase` is requested to [run](#run)

## Implementations

* [MergeIntoCommand](MergeIntoCommand.md)

## Performance Metrics { #metrics }

Name | web UI
------------|------------
 `numSourceRows` | number of source rows
 [numSourceRowsInSecondScan](#numSourceRowsInSecondScan) | number of source rows (during repeated scan)
 `numTargetRowsCopied` | number of target rows rewritten unmodified
 [numTargetRowsInserted](#numTargetRowsInserted) | number of inserted rows
 [numTargetRowsUpdated](#numTargetRowsUpdated) | number of updated rows
 [numTargetRowsDeleted](#numTargetRowsDeleted) | number of deleted rows
 `numTargetFilesBeforeSkipping` | number of target files before skipping
 `numTargetFilesAfterSkipping` | number of target files after skipping
 `numTargetFilesRemoved` | number of files removed to target
 `numTargetFilesAdded` | number of files added to target
 `numTargetChangeFilesAdded` | number of change data capture files generated
 `numTargetChangeFileBytes` | total size of change data capture files generated
 `numTargetBytesBeforeSkipping` | number of target bytes before skipping
 `numTargetBytesAfterSkipping` | number of target bytes after skipping
 `numTargetBytesRemoved` | number of target bytes removed
 `numTargetBytesAdded` | number of target bytes added
 `numTargetPartitionsAfterSkipping` | number of target partitions after skipping
 `numTargetPartitionsRemovedFrom` | number of target partitions from which files were removed
 `numTargetPartitionsAddedTo` | number of target partitions to which files were added
 [numTargetRowsMatchedDeleted](#numTargetRowsMatchedDeleted) | number of rows deleted by a matched clause
 [numTargetRowsNotMatchedBySourceDeleted](#numTargetRowsNotMatchedBySourceDeleted) | number of rows deleted by a not matched by source clause
 [numTargetRowsMatchedUpdated](#numTargetRowsMatchedUpdated) | number of rows updated by a matched clause
 [numTargetRowsNotMatchedBySourceUpdated](#numTargetRowsNotMatchedBySourceUpdated) | number of rows updated by a not matched by source clause
 `executionTimeMs` | time taken to execute the entire operation
 [scanTimeMs](#scanTimeMs) | time taken to scan the files for matches
 [rewriteTimeMs](#rewriteTimeMs) | time taken to rewrite the matched files

### number of deleted rows { #numTargetRowsDeleted }

### number of inserted rows { #numTargetRowsInserted }

### number of rows deleted by a matched clause { #numTargetRowsMatchedDeleted }

### number of rows deleted by a not matched by source clause { #numTargetRowsNotMatchedBySourceDeleted }

### number of rows updated by a matched clause { #numTargetRowsMatchedUpdated }

### number of rows updated by a not matched by source clause { #numTargetRowsNotMatchedBySourceUpdated }

### number of source rows (during repeated scan) { #numSourceRowsInSecondScan }

### number of target rows rewritten unmodified { #numTargetRowsCopied }

`numTargetRowsCopied` performance metric (like the other [metrics](#performance-metrics)) is turned into a non-deterministic user-defined function (UDF).

`numTargetRowsCopied` becomes `incrNoopCountExpr` UDF.

`incrNoopCountExpr` UDF is resolved on a joined plan and used to create a [JoinedRowProcessor](JoinedRowProcessor.md#noopCopyOutput) for [processing partitions](#processPartition) of the joined plan `Dataset`.

### number of updated rows { #numTargetRowsUpdated }

### time taken to execute the entire operation { #executionTimeMs }

### time taken to rewrite the matched files { #rewriteTimeMs }

### time taken to scan the files for matches { #scanTimeMs }

## Building Target (Logical) Plan Spanned Over Fewer Files { #buildTargetPlanWithFiles }

```scala
buildTargetPlanWithFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile],
  columnsToDrop: Seq[String]): LogicalPlan
```

??? note "`columnsToDrop` Argument"
    `columnsToDrop` is always empty (`Nil`) but for `ClassicMergeExecutor` to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles).

`buildTargetPlanWithFiles` creates a [TahoeBatchFileIndex](../../TahoeBatchFileIndex.md) for the given [AddFile](../../AddFile.md)s (`files`) only.

!!! note
    `buildTargetPlanWithFiles` creates a `LogicalPlan` of a delta table that is possibly smaller parquet data files (spanning over a smaller number of files) than the "source".

In the end, `buildTargetPlanWithFiles` [buildTargetPlanWithIndex](#buildTargetPlanWithIndex) for the `TahoeBatchFileIndex` and the given `columnsToDrop` column names.

---

`buildTargetPlanWithFiles` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles) and [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)

### buildTargetPlanWithIndex { #buildTargetPlanWithIndex }

```scala
buildTargetPlanWithIndex(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  fileIndex: TahoeFileIndex,
  columnsToDrop: Seq[String]): LogicalPlan
```

`buildTargetPlanWithIndex` gets the references to columns in the target dataframe  (`AttributeReference`s) and `null`s for new columns that are added to the target table (as part of this [OptimisticTransaction](../../OptimisticTransaction.md)).

In the end, `buildTargetPlanWithIndex` creates a `Project` logical operator with new columns (with `null`s) after the existing ones.

## Special Columns

### \_row_dropped_ { #ROW_DROPPED_COL }

`_row_dropped_` column name is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [generateInsertsOnlyOutputDF](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputDF) and [generateInsertsOnlyOutputCols](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputCols)
* `MergeOutputGeneration` is requested to [generateCdcAndOutputRows](MergeOutputGeneration.md#generateCdcAndOutputRows)

!!! note "CDF-Aware Output Generation"
    It appears that `ClassicMergeExecutor` and `InsertOnlyMergeExecutor` use `_row_dropped_` column to include the rows with `false` value in output dataframes followed by dropping the column immediately.

    An "exception" to the behaviour is [MergeOutputGeneration](MergeOutputGeneration.md#generateCdcAndOutputRows) for CDF-aware output generation.

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      spark: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) abstraction.

`run` is a transactional operation that is made up of the following steps:

1. [The metrics are reset](#reset-metrics)
1. Check if the [source](#source) table [should be materialized](MergeIntoMaterializeSource.md#shouldMaterializeSource)
1. [Runs this merge](#runMerge) when no materialization or [runWithMaterializedSourceLostRetries](MergeIntoMaterializeSource.md#runWithMaterializedSourceLostRetries)

### Reset Metrics

The following metrics are reset (set to `0`):

* [time taken to execute the entire operation](#executionTimeMs)
* [time taken to scan the files for matches](#scanTimeMs)
* [time taken to rewrite the matched files](#rewriteTimeMs)

## isInsertOnly { #isInsertOnly }

```scala
isInsertOnly: Boolean
```

`isInsertOnly` is positive for an [insert-only merge](index.md#insert-only-merges) (i.e. when there are [WHEN NOT MATCHED clauses](#notMatchedClauses) only in this MERGE command).

---

In other words, `isInsertOnly` is enabled (`true`) when all the following hold:

1. There are neither [WHEN MATCHED](#matchedClauses) nor [WHEN NOT MATCHED BY SOURCE](#notMatchedBySourceClauses) clauses
1. There are [WHEN NOT MATCHED](#notMatchedClauses) clauses

---

`isInsertOnly` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) (and [prepareSourceDFAndReturnMaterializeReason](MergeIntoMaterializeSource.md#prepareSourceDFAndReturnMaterializeReason))
* `MergeIntoCommandBase` is requested to [run](#run) (to [shouldMaterializeSource](MergeIntoMaterializeSource.md#shouldMaterializeSource))

## Matched-Only Merge { #isMatchedOnly }

```scala
isMatchedOnly: Boolean
```

`isMatchedOnly` is enabled (`true`) when this merge is [WHEN MATCHED-only](index.md#matched-only-merges):

* There is at least one [WHEN MATCHED clause](#matchedClauses)
* There are no other clause types (neither [WHEN NOT MATCHED](#notMatchedClauses) nor [WHEN NOT MATCHED BY SOURCE](#notMatchedBySourceClauses))

---

`isMatchedOnly` is used when:

* `MergeIntoCommandBase` is requested to [shouldOptimizeMatchedOnlyMerge](#shouldOptimizeMatchedOnlyMerge) and [getTargetOnlyPredicates](#getTargetOnlyPredicates)
* `ClassicMergeExecutor` is requested to [find files to rewrite](ClassicMergeExecutor.md#findTouchedFiles)

## shouldOptimizeMatchedOnlyMerge { #shouldOptimizeMatchedOnlyMerge }

```scala
shouldOptimizeMatchedOnlyMerge(
  spark: SparkSession): Boolean
```

`shouldOptimizeMatchedOnlyMerge` is enabled (`true`) when the following all hold:

* This merge is [matched-only](#isMatchedOnly)
* [merge.optimizeMatchedOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_MATCHED_ONLY_ENABLED) is enabled

---

`shouldOptimizeMatchedOnlyMerge` is used when:

* `ClassicMergeExecutor` is requested to [write out merge changes](ClassicMergeExecutor.md#writeAllChanges)

## Finding Target-Only Predicates (Among Merge and Clause Conditions) { #getTargetOnlyPredicates }

```scala
getTargetOnlyPredicates(
  spark: SparkSession): Seq[Expression]
```

`getTargetOnlyPredicates` determines the target-only predicates in the [merge condition](#condition) first (`targetOnlyPredicatesOnCondition`).
`getTargetOnlyPredicates` splits conjunctive predicates (`And`s) in the merge condition and leaves only the ones with the column references to the columns in the [target](#target) table only.

`getTargetOnlyPredicates` branches off based on whether this merge is [matched-only](#isMatchedOnly) or not.

For a non-[matched-only](#isMatchedOnly) merge, `getTargetOnlyPredicates` returns the target-only condition predicates.

Otherwise, `getTargetOnlyPredicates` does the same (what it has just done with the [merge condition](#condition)) with conditional [WHEN MATCHED clauses](#matchedClauses) (the ones with a [condition](DeltaMergeIntoClause.md#condition) specified).
`getTargetOnlyPredicates` splits conjunctive predicates (`And`s) in the conditions of the `matchedClauses` and leaves only the ones with the column references to the [target](#target).

In the end, `getTargetOnlyPredicates` returns the target-only condition predicates (from the [merge condition](#condition) and all the [condition](DeltaMergeIntoClause.md#condition)s from the conditional [WHEN MATCHED clauses](#matchedClauses)).

---

`getTargetOnlyPredicates` is used when:

* `ClassicMergeExecutor` is requested to [find files to rewrite](ClassicMergeExecutor.md#findTouchedFiles)

## throwErrorOnMultipleMatches { #throwErrorOnMultipleMatches }

```scala
throwErrorOnMultipleMatches(
  hasMultipleMatches: Boolean,
  spark: SparkSession): Unit
```

??? warning "Procedure"
    `throwErrorOnMultipleMatches` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`throwErrorOnMultipleMatches` throws a `DeltaUnsupportedOperationException` when the given `hasMultipleMatches` is enabled (`true`) and [isOnlyOneUnconditionalDelete](#isOnlyOneUnconditionalDelete) is disabled (`false`).

---

`throwErrorOnMultipleMatches` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles)

### isOnlyOneUnconditionalDelete { #isOnlyOneUnconditionalDelete }

```scala
isOnlyOneUnconditionalDelete: Boolean
```

`isOnlyOneUnconditionalDelete` is positive (`true`) when there is only one [when matched clause](#matchedClauses) that is a `DELETE` with no condition.

---

In other words, `isOnlyOneUnconditionalDelete` is `true` for the following:

* [matchedClauses](#matchedClauses) is exactly a [DeltaMergeIntoMatchedDeleteClause](DeltaMergeIntoMatchedDeleteClause.md) with no [condition](DeltaMergeIntoMatchedDeleteClause.md#condition) (hence the name _unconditional delete_)

## Recording Merge Operation { #recordMergeOperation }

```scala
recordMergeOperation[A](
  extraOpType: String = "",
  status: String = null,
  sqlMetricName: String = null)(
  thunk: => A): A
```

`recordMergeOperation` creates a operation type (`changedOpType`) based on the given `extraOpType` identifier as follows:

```text
delta.dml.merge.[extraOpType]
```

`recordMergeOperation` appends the given `status` to the existing Spark job description (as `spark.job.description` local property), if any.

In the end, `recordMergeOperation` executes the given `thunk` code block:

1. Records the start time
1. Sets a human readable description of the current job ([Spark Core]({{ book.spark_core }}/SparkContext#setJobDescription)) as the prefixed `status`
1. Adds the time taken to the given `sqlMetricName`
1. Restores the job description to the previous one, if any

---

MergeOutputGeneration | extraOpType | status | sqlMetricName
----------------------|-------------|--------|--------------
 [ClassicMergeExecutor](ClassicMergeExecutor.md#findTouchedFiles) | findTouchedFiles | MERGE operation - scanning files for matches | [scanTimeMs](#scanTimeMs)
 [ClassicMergeExecutor](ClassicMergeExecutor.md#writeAllChanges) | writeAllUpdatesAndDeletes or writeAllChanges | MERGE operation - Rewriting n files | [rewriteTimeMs](#rewriteTimeMs)
 [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md#writeOnlyInserts) | writeInsertsOnlyWhenNoMatchedClauses or writeInsertsOnlyWhenNoMatches | MERGE operation - writing new files for only inserts | [rewriteTimeMs](#rewriteTimeMs)

---

`recordMergeOperation` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles), [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)

## Is WHEN NOT MATCHED THEN INSERT Clause Used { #includesInserts }

```scala
includesInserts: Boolean
```

`includesInserts` is positive (`true`) when there are [WHEN NOT MATCHED clauses](#notMatchedClauses) in this merge (with [WHEN NOT MATCHED THEN INSERT](DeltaMergeIntoNotMatchedInsertClause.md)s possible and hence the name of this method).

---

`includesInserts` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles) (to create a [DeduplicateCDFDeletes](DeduplicateCDFDeletes.md))
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts) (and stop early)

## Auto Schema Merging { #canMergeSchema }

??? note "ImplicitMetadataOperation"

    ```scala
    canMergeSchema: Boolean
    ```

    `canMergeSchema` is part of the [ImplicitMetadataOperation](../../ImplicitMetadataOperation.md#canMergeSchema) abstraction.

`canMergeSchema` creates a [DeltaOptions](../../spark-connector/DeltaOptions.md) for the [canMergeSchema](../../spark-connector/DeltaWriteOptionsImpl.md#canMergeSchema) (based on the [SQLConf](#conf) only).

??? note "Options always empty"
    Delta options cannot be passed to MERGE INTO, so they will always be empty and `canMergeSchema` relies on the [SQLConf](#conf) only.

## Create IncrementMetric Expression { #incrementMetricAndReturnBool }

```scala
incrementMetricAndReturnBool(
  name: String,
  valueToReturn: Boolean): Expression
```

`incrementMetricAndReturnBool` creates a `IncrementMetric` unary expression with the following:

IncrementMetric | Value
----------------|------
Child `Expression` | A `Literal` with the given `valueToReturn` (when executed)
`SQLMetric` | The [metric](#metrics) by the given `name`

!!! note "IncrementMetric"
    The `IncrementMetric` presents itself under `increment_metric` name in query plans.

    When executed, `IncrementMetric` increments the [metric](#metrics) (by the given `name`) and returns the given `valueToReturn`.

Usage | Metric Name | valueToReturn
------|-------------|--------------
 `ClassicMergeExecutor` to [find files to rewrite](ClassicMergeExecutor.md#findTouchedFiles) | [numSourceRows](#numSourceRows) | `true`
 `ClassicMergeExecutor` to [write out merge changes](ClassicMergeExecutor.md#writeAllChanges) | [numSourceRowsInSecondScan](#numSourceRowsInSecondScan) | `true`
 | [numTargetRowsCopied](#numTargetRowsCopied) | `false`
 `InsertOnlyMergeExecutor` to [write out inserts](InsertOnlyMergeExecutor.md#writeOnlyInserts) | [numSourceRows](#numSourceRows) or [numSourceRowsInSecondScan](#numSourceRowsInSecondScan) | `true`
 `InsertOnlyMergeExecutor` to [generateInsertsOnlyOutputCols](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputCols) | [numTargetRowsInserted](#numTargetRowsInserted) | `false`
 `MergeOutputGeneration` to [generateAllActionExprs](MergeOutputGeneration.md#generateAllActionExprs) | [numTargetRowsUpdated](#numTargetRowsUpdated) | `false`
 | [numTargetRowsDeleted](#numTargetRowsDeleted) | `true`
 | [numTargetRowsInserted](#numTargetRowsInserted) | `false`

## Writing Data(Frame) Out to Delta Table { #writeFiles }

```scala
writeFiles(
  spark: SparkSession,
  txn: OptimisticTransaction,
  outputDF: DataFrame): Seq[FileAction]
```

!!! note "Fun Fact: The Name"
    The `writeFiles` name stems from the (fun?) fact that writing out to a delta table is actually creating new files.

    You can also look at the given `DataFrame` that is usually another delta table that is nothing but a collection of [AddFile](../../AddFile.md)s.

    I found it a little funny, _et toi?_ 😉

If the target table is [partitioned](../../Metadata.md#partitionColumns) and [merge.repartitionBeforeWrite.enabled](../../configuration-properties/index.md#merge.repartitionBeforeWrite.enabled) is enabled, `writeFiles` repartitions the given `outputDF` dataframe (using `Dataset.repartition` operator) before writing it out.

In the end, `writeFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [write the data(frame) out](../../TransactionalWrite.md#writeFiles).

---

`writeFiles` is used when `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) and does one of the following:

* `ClassicMergeExecutor` is requested to [write out merge changes](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [write out inserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)

## isCdcEnabled { #isCdcEnabled }

```scala
isCdcEnabled(
  deltaTxn: OptimisticTransaction): Boolean
```

`isCdcEnabled` is the value of the [enableChangeDataFeed](../../DeltaConfigs.md#CHANGE_DATA_FEED) table property ([from](../../DeltaConfig.md#fromMetaData) the metadata of a delta table).

---

`isCdcEnabled` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles), [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
