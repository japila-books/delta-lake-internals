# ClassicMergeExecutor

`ClassicMergeExecutor` is an extension of the [MergeOutputGeneration](MergeOutputGeneration.md) abstraction for optimized execution of [merge command](index.md).

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): (Seq[AddFile], DeduplicateCDFDeletes)
```

`findTouchedFiles` registers an internal `SetAccumulator` with `internal.metrics.MergeIntoDelta.touchedFiles` name.

`findTouchedFiles` creates a non-deterministic UDF that records the names of touched files (adds them to the accumulator).

With no [notMatchedBySourceClauses](#notMatchedBySourceClauses), `findTouchedFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) with [getTargetOnlyPredicates](MergeIntoCommandBase.md#getTargetOnlyPredicates). Otherwise, `findTouchedFiles` requests it to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) with an accept-all predicate.

With no [notMatchedBySourceClauses](#notMatchedBySourceClauses), `findTouchedFiles` uses `inner` join type. Otherwise, it is `right_outer` join.

!!! note "FIXME Show the diagrams of the different joins"

When [isMatchedOnly](#isMatchedOnly), `findTouchedFiles` converts the [matchedClauses](#matchedClauses) to their [condition](DeltaMergeIntoClause.md#condition)s, if defined, or falls back to accept-all predicate and then reduces to `Or` expressions. Otherwise, `findTouchedFiles` uses accept-all predicate for the matched predicate.

`findTouchedFiles`...FIXME (finished at `sourceDF`)

---

`findTouchedFiles` is used when:

* `MergeIntoCommand` is requested to [runMerge](MergeIntoCommand.md#runMerge)

## writeAllChanges { #writeAllChanges }

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile],
  deduplicateCDFDeletes: DeduplicateCDFDeletes): Seq[FileAction]
```

`writeAllChanges`...FIXME

---

`writeAllChanges` is used when:

* `MergeIntoCommand` is requested to [runMerge](MergeIntoCommand.md#runMerge)
