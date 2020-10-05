# PartitionFiltering

`PartitionFiltering` is an abstraction of [snapshots](#implementations) with [partition filtering for scan](#filesForScan).

## Implementations

[Snapshot](Snapshot.md) is the default and only known `PartitionFiltering` in Delta Lake.

## <span id="filesForScan"> Files to Scan (Matching Projection Attributes and Predicates)

```scala
filesForScan(
  projection: Seq[Attribute],
  filters: Seq[Expression],
  keepStats: Boolean = false): DeltaScan
```

`filesForScan`...FIXME

`filesForScan` is used when:

* `OptimisticTransactionImpl` is requested for the [files to scan matching given predicates](OptimisticTransactionImpl.md#filterFiles)
* `TahoeLogFileIndex` is requested for the [files matching predicates](TahoeLogFileIndex.md#matchingFiles) and the [input files](TahoeLogFileIndex.md#inputFiles)
