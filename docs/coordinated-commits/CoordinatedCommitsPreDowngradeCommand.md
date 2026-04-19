# CoordinatedCommitsPreDowngradeCommand

`CoordinatedCommitsPreDowngradeCommand` is a [PreDowngradeTableFeatureCommand](../table-features/PreDowngradeTableFeatureCommand.md).

## Creating Instance

`CoordinatedCommitsPreDowngradeCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../DeltaTableV2.md)

`CoordinatedCommitsPreDowngradeCommand` is created when:

* `CoordinatedCommitsTableFeature` is requested to [preDowngradeCommand](CoordinatedCommitsTableFeature.md#preDowngradeCommand)

## removeFeatureTracesIfNeeded { #removeFeatureTracesIfNeeded }

??? note "PreDowngradeTableFeatureCommand"

    ```scala
    removeFeatureTracesIfNeeded(
      spark: SparkSession): PreDowngradeStatus
    ```

    `removeFeatureTracesIfNeeded` is part of the [PreDowngradeTableFeatureCommand](../table-features/PreDowngradeTableFeatureCommand.md#removeFeatureTracesIfNeeded) abstraction.

`removeFeatureTracesIfNeeded`...FIXME
