# MergeIntoCommandBase

`MergeIntoCommandBase` is a [DeltaCommand](../DeltaCommand.md) and an [extension](#contract) of the `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) abstraction for [merge delta commands](#implementations).

`MergeIntoCommandBase` is a [MergeIntoMaterializeSource](MergeIntoMaterializeSource.md).

## Contract (Subset)

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

### Running Merge { #runMerge }

```scala
runMerge(
  spark: SparkSession): Seq[Row]
```

See:

* [MergeIntoCommand](MergeIntoCommand.md#runMerge)

Used when:

* `MergeIntoCommandBase` is requested to [run](#run)

## Implementations

* [MergeIntoCommand](MergeIntoCommand.md)

## Performance Metrics { #metrics }

Name | web UI
------------|------------
 `numSourceRows` | number of source rows
 `numSourceRowsInSecondScan` | number of source rows (during repeated scan)
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
 `executionTimeMs` | time taken to execute the entire operation
 `scanTimeMs` | time taken to scan the files for matches
 `rewriteTimeMs` | time taken to rewrite the matched files

### number of deleted rows { #numTargetRowsDeleted }

### number of inserted rows { #numTargetRowsInserted }

### number of target rows rewritten unmodified { #numTargetRowsCopied }

`numTargetRowsCopied` performance metric (like the other [metrics](#performance-metrics)) is turned into a non-deterministic user-defined function (UDF).

`numTargetRowsCopied` becomes `incrNoopCountExpr` UDF.

`incrNoopCountExpr` UDF is resolved on a joined plan and used to create a [JoinedRowProcessor](JoinedRowProcessor.md#noopCopyOutput) for [processing partitions](#processPartition) of the joined plan `Dataset`.

### number of updated rows { #numTargetRowsUpdated }

## buildTargetPlanWithFiles { #buildTargetPlanWithFiles }

```scala
buildTargetPlanWithFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile],
  columnsToDrop: Seq[String]): LogicalPlan
```

`buildTargetPlanWithFiles`...FIXME

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

`buildTargetPlanWithIndex`...FIXME

## Special Columns

### \_row_dropped_ { #ROW_DROPPED_COL }

`_row_dropped_` column name is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [generateInsertsOnlyOutputDF](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputDF) and [generateInsertsOnlyOutputCols](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputCols)
* `MergeOutputGeneration` is requested to [generateCdcAndOutputRows](MergeOutputGeneration.md#generateCdcAndOutputRows)

!!! note
    It appears that `ClassicMergeExecutor` and `InsertOnlyMergeExecutor` use `_row_dropped_` column to filter out rows when it is `false` followed by dropping the column immediately.

    An "exception" to the behaviour is [MergeOutputGeneration](MergeOutputGeneration.md#generateCdcAndOutputRows) for CDC-aware output generation.

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      spark: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run`...FIXME

## isInsertOnly { #isInsertOnly }

```scala
isInsertOnly: Boolean
```

`isInsertOnly` is enabled (`true`) when all the following hold:

1. No [matchedClauses](#matchedClauses)
1. No [notMatchedBySourceClauses](#notMatchedBySourceClauses)
1. There are [notMatchedClauses](#notMatchedClauses)

---

`isInsertOnly` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge) (and [prepareSourceDFAndReturnMaterializeReason](MergeIntoMaterializeSource.md#prepareSourceDFAndReturnMaterializeReason))
* `MergeIntoCommandBase` is requested to [run](#run) (to [shouldMaterializeSource](MergeIntoMaterializeSource.md#shouldMaterializeSource))

## shouldOptimizeMatchedOnlyMerge { #shouldOptimizeMatchedOnlyMerge }

```scala
shouldOptimizeMatchedOnlyMerge(
  spark: SparkSession): Boolean
```

`shouldOptimizeMatchedOnlyMerge` is enabled (`true`) when all the following hold:

1. [isMatchedOnly](#isMatchedOnly)
1. [DeltaSQLConf.MERGE_MATCHED_ONLY_ENABLED](../../configuration-properties/DeltaSQLConf.md#MERGE_MATCHED_ONLY_ENABLED) is enabled

---

`shouldOptimizeMatchedOnlyMerge` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

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
