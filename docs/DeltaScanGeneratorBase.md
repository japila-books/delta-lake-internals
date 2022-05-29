# DeltaScanGeneratorBase

`DeltaScanGeneratorBase` is an [abstraction](#contract) of [delta scan generators](#implementations).

## Contract

### <span id="filesForScan"> Files to Scan

```scala
filesForScan(
  projection: Seq[Attribute],
  filters: Seq[Expression]): DeltaScan
```

Creates a [DeltaScan](data-skipping/DeltaScan.md) with the files to scan

Used when:

* `PrepareDeltaScanBase` is requested to [filesForScan](data-skipping/PrepareDeltaScanBase.md#filesForScan)

### <span id="filesWithStatsForScan"> filesWithStatsForScan

```scala
filesWithStatsForScan(
  partitionFilters: Seq[Expression]): DataFrame
```

!!! note
    Seems unused.

### <span id="snapshotToScan"> snapshotToScan

```scala
snapshotToScan: Snapshot
```

[Snapshot](Snapshot.md) to scan

Used when:

* `PrepareDeltaScanBase` is requested to [filesForScan](data-skipping/PrepareDeltaScanBase.md#filesForScan)

## Implementations

* [DeltaScanGenerator](DeltaScanGenerator.md)
