# DeletionVectorsPreDowngradeCommand

`DeletionVectorsPreDowngradeCommand` is a [PreDowngradeTableFeatureCommand](../table-features/PreDowngradeTableFeatureCommand.md).

## Creating Instance

`DeletionVectorsPreDowngradeCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../DeltaTableV2.md)

`DeletionVectorsPreDowngradeCommand` is created when:

* `DeletionVectorsTableFeature` is requested to [preDowngradeCommand](DeletionVectorsTableFeature.md#preDowngradeCommand)

## removeFeatureTracesIfNeeded { #removeFeatureTracesIfNeeded }

??? note "PreDowngradeTableFeatureCommand"

    ```scala
    removeFeatureTracesIfNeeded(
      spark: SparkSession): PreDowngradeStatus
    ```

    `removeFeatureTracesIfNeeded` is part of the [PreDowngradeTableFeatureCommand](../table-features/PreDowngradeTableFeatureCommand.md#removeFeatureTracesIfNeeded) abstraction.

`removeFeatureTracesIfNeeded`...FIXME

### generateDVTombstones { #generateDVTombstones }

```scala
generateDVTombstones(
  spark: SparkSession,
  checkIfSnapshotUpdatedSinceTs: Long,
  metrics: DeletionVectorsRemovalMetrics): Unit
```

`generateDVTombstones`...FIXME
