# ClassicMergeExecutor

`ClassicMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [MERGE command](index.md) (when requested to [run merge](MergeIntoCommand.md#runMerge)) when one of the following holds:

* MERGE is not [insert only](MergeIntoCommandBase.md#isInsertOnly) (contains `WHEN NOT MATCHED` clauses)
* [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is disabled

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): (Seq[AddFile], DeduplicateCDFDeletes)
```

`findTouchedFiles` registers an internal `SetAccumulator` with `internal.metrics.MergeIntoDelta.touchedFiles` name.

`findTouchedFiles` creates a non-deterministic UDF that records the names of touched files (adds them to the accumulator).

With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) with [getTargetOnlyPredicates](MergeIntoCommandBase.md#getTargetOnlyPredicates). Otherwise, `findTouchedFiles` requests it to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) with an accept-all predicate.

`findTouchedFiles` determines the join type (`joinType`).
With no [WHEN NOT MATCHED BY SOURCE clauses](MergeIntoCommandBase.md#notMatchedBySourceClauses), `findTouchedFiles` uses `INNER` join type. Otherwise, it is `RIGHT_OUTER` join.

!!! note "FIXME Show the diagrams of the different joins"

`findTouchedFiles` determines the matched predicate (`matchedPredicate`).
When [isMatchedOnly](MergeIntoCommandBase.md#isMatchedOnly), `findTouchedFiles` converts the [WHEN MATCHED clauses](MergeIntoCommandBase.md#matchedClauses) to their [condition](DeltaMergeIntoClause.md#condition)s, if defined, or falls back to accept-all predicate and then reduces to `Or` expressions. Otherwise, `findTouchedFiles` uses accept-all predicate for the matched predicate.

`findTouchedFiles`...FIXME (finished at `sourceDF`)

---

`findTouchedFiles` is used when:

* `MergeIntoCommand` is requested to [run a merge](MergeIntoCommand.md#runMerge)

## writeAllChanges { #writeAllChanges }

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile],
  deduplicateCDFDeletes: DeduplicateCDFDeletes): Seq[FileAction]
```

`writeAllChanges` [recordMergeOperation](MergeIntoCommandBase.md#recordMergeOperation) with the following:

Property | Value
---------|------
extraOpType | <ul><li>`writeAllUpdatesAndDeletes` when [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge)<li>`writeAllChanges` otherwise</ul>
status | `MERGE operation - Rewriting [filesToRewrite] files`
sqlMetricName | `rewriteTimeMs`

??? note "CDF Generation"
    `writeAllChanges` asserts that one of the following holds:

    1. CDF generation is disabled (based on the given `DeduplicateCDFDeletes`)
    1. [isCdcEnabled](MergeIntoCommandBase.md#isCdcEnabled) is enabled

    Otherwise, `writeAllChanges` reports an `IllegalArgumentException`:

    ```text
    CDF delete duplication is enabled but overall the CDF generation is disabled
    ```

`writeAllChanges` creates a `DataFrame` with the [target plan](#buildTargetPlanWithFiles) for the given [AddFile](../../AddFile.md)s to rewrite (and no `columnsToDrop`).

`writeAllChanges` determines the join type based on [shouldOptimizeMatchedOnlyMerge](MergeIntoCommandBase.md#shouldOptimizeMatchedOnlyMerge):

* `rightOuter` when enabled
* `fullOuter` otherwise

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges using [joinType] join:
  source.output: [source]
  target.output: [target]
  condition: [condition]
  newTarget.output: [baseTargetDF]
```

`writeAllChanges` [creates Catalyst expressions to increment SQL metrics](MergeIntoCommandBase.md#incrementMetricAndReturnBool):

* `numSourceRowsInSecondScan`
* `numTargetRowsCopied`

`writeAllChanges` creates a `DataFrame`.

!!! note "FIXME joinedDF"

`writeAllChanges` [generatePrecomputedConditionsAndDF](#generatePrecomputedConditionsAndDF) with the joined `DataFrame` and the given MERGE clauses (`matchedClauses`, `notMatchedClauses`, `notMatchedBySourceClauses`).

`writeAllChanges`...FIXME

---

`writeAllChanges` is used when:

* `MergeIntoCommand` is requested to [run merge](MergeIntoCommand.md#runMerge)

## Logging

`ClassicMergeExecutor` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
