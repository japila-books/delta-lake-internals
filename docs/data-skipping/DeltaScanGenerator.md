# DeltaScanGenerator

`DeltaScanGenerator` is an [abstraction](#contract) of [delta table scan generators](#implementations).

## Contract

### <span id="filesForScan"> filesForScan

```scala
filesForScan(
  limit: Long): DeltaScan
filesForScan(
  limit: Long,
  partitionFilters: Seq[Expression]): DeltaScan
filesForScan(
  filters: Seq[Expression],
  keepNumRecords: Boolean = false): DeltaScan
```

[DeltaScan](DeltaScan.md) with the files to scan

Used when:

* `PrepareDeltaScanBase` is requested to [filesForScan](PrepareDeltaScanBase.md#filesForScan)

### <span id="filesWithStatsForScan"> filesWithStatsForScan

```scala
filesWithStatsForScan(
  partitionFilters: Seq[Expression]): DataFrame
```

Used when:

* `OptimizeMetadataOnlyDeltaQuery` is requested to [optimizeQueryWithMetadata](OptimizeMetadataOnlyDeltaQuery.md#optimizeQueryWithMetadata)

### <span id="snapshotToScan"> Snapshot to Scan

```scala
snapshotToScan: Snapshot
```

[Snapshot](../Snapshot.md) to generate a table scan for

Used when:

* `DataSkippingReaderBase` is requested to [filesForScan](DataSkippingReaderBase.md#filesForScan)
* `PrepareDeltaScanBase` is requested to [filesForScan](PrepareDeltaScanBase.md#filesForScan)

## Implementations

* [DataSkippingReaderBase](DataSkippingReaderBase.md)
* [OptimisticTransactionImpl](../OptimisticTransactionImpl.md)
