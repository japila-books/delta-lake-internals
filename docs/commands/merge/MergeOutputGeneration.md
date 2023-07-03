# MergeOutputGeneration

`MergeOutputGeneration` is an extension of the [MergeIntoCommandBase](MergeIntoCommandBase.md) abstraction with logic to transform the merge clauses into expressions that can be evaluated to obtain the output of the [merge operation](index.md).

## Implementations

* [ClassicMergeExecutor](ClassicMergeExecutor.md)
* [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)

## generatePrecomputedConditionsAndDF { #generatePrecomputedConditionsAndDF }

```scala
generatePrecomputedConditionsAndDF(
  sourceDF: DataFrame,
  clauses: Seq[DeltaMergeIntoClause]): (DataFrame, Seq[DeltaMergeIntoClause])
```

`generatePrecomputedConditionsAndDF`...FIXME

---

`generatePrecomputedConditionsAndDF` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [generateInsertsOnlyOutputDF](InsertOnlyMergeExecutor.md#generateInsertsOnlyOutputDF)

## generateWriteAllChangesOutputCols { #generateWriteAllChangesOutputCols }

```scala
generateWriteAllChangesOutputCols(
  targetOutputCols: Seq[Expression],
  outputColNames: Seq[String],
  noopCopyExprs: Seq[Expression],
  clausesWithPrecompConditions: Seq[DeltaMergeIntoClause],
  cdcEnabled: Boolean,
  shouldCountDeletedRows: Boolean = true): IndexedSeq[Column]
```

`generateWriteAllChangesOutputCols`...FIXME

---

`generateWriteAllChangesOutputCols` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

### generateAllActionExprs { #generateAllActionExprs }

```scala
generateAllActionExprs(
  targetOutputCols: Seq[Expression],
  clausesWithPrecompConditions: Seq[DeltaMergeIntoClause],
  cdcEnabled: Boolean,
  shouldCountDeletedRows: Boolean): Seq[ProcessedClause]
```

`generateAllActionExprs`...FIXME

### generateClauseOutputExprs { #generateClauseOutputExprs }

```scala
generateClauseOutputExprs(
  numOutputCols: Integer,
  clauses: Seq[ProcessedClause],
  noopExprs: Seq[Expression]): Seq[Expression]
```

`generateClauseOutputExprs`...FIXME

## generateCdcAndOutputRows { #generateCdcAndOutputRows }

```scala
generateCdcAndOutputRows(
  sourceDf: DataFrame,
  outputCols: Seq[Column],
  outputColNames: Seq[String],
  noopCopyExprs: Seq[Expression],
  deduplicateDeletes: DeduplicateCDFDeletes): DataFrame
```

`generateCdcAndOutputRows`...FIXME

---

`generateCdcAndOutputRows` is used when:

* `ClassicMergeExecutor` is requested to [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)

### packAndExplodeCDCOutput { #packAndExplodeCDCOutput }

```scala
packAndExplodeCDCOutput(
  sourceDf: DataFrame,
  cdcArray: Column,
  cdcToMainDataArray: Column,
  outputColNames: Seq[String],
  dedupColumns: Seq[Column]): DataFrame
```

`packAndExplodeCDCOutput`...FIXME

### deduplicateCDFDeletes { #deduplicateCDFDeletes }

```scala
deduplicateCDFDeletes(
  deduplicateDeletes: DeduplicateCDFDeletes,
  df: DataFrame,
  cdcArray: Column,
  cdcToMainDataArray: Column,
  outputColNames: Seq[String]): DataFrame
```

`deduplicateCDFDeletes`...FIXME
