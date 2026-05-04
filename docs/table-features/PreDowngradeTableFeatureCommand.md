# PreDowngradeTableFeatureCommand

`PreDowngradeTableFeatureCommand` is an [abstraction](#contract) of [pre-downgrade table feature commands](#implementations) that can [removeFeatureTracesIfNeeded](#removeFeatureTracesIfNeeded).

??? note "Sealed Abstract Class"
    `PreDowngradeTableFeatureCommand` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).

## Contract

### removeFeatureTracesIfNeeded { #removeFeatureTracesIfNeeded }

```scala
removeFeatureTracesIfNeeded(
  spark: SparkSession): PreDowngradeStatus
```

See:

* [CoordinatedCommitsPreDowngradeCommand](../coordinated-commits/CoordinatedCommitsPreDowngradeCommand.md#removeFeatureTracesIfNeeded)
* [DeletionVectorsPreDowngradeCommand](../deletion-vectors/DeletionVectorsPreDowngradeCommand.md#removeFeatureTracesIfNeeded)

Used when:

* [ALTER TABLE DROP FEATURE](../commands/alter/AlterTableDropFeature.md) command is executed (and `AlterTableDropFeatureDeltaCommand` is requested to [executeDropFeatureWithCheckpointProtection](../commands/alter/AlterTableDropFeatureDeltaCommand.md#executeDropFeatureWithCheckpointProtection) and [executeDropFeatureWithHistoryTruncation](../commands/alter/AlterTableDropFeatureDeltaCommand.md#executeDropFeatureWithHistoryTruncation))

## Implementations

* `CheckConstraintsPreDowngradeTableFeatureCommand`
* `CheckpointProtectionPreDowngradeCommand`
* `ColumnMappingPreDowngradeCommand`
* [CoordinatedCommitsPreDowngradeCommand](../coordinated-commits/CoordinatedCommitsPreDowngradeCommand.md)
* [DeletionVectorsPreDowngradeCommand](../deletion-vectors/DeletionVectorsPreDowngradeCommand.md)
* `DomainMetadataPreDowngradeCommand`
* `InCommitTimestampsPreDowngradeCommand`
* `MaterializePartitionColumnsPreDowngradeCommand`
* `RedirectReaderWriterPreDowngradeCommand`
* `RedirectWriterOnlyPreDowngradeCommand`
* `RowTrackingPreDowngradeCommand`
* `TypeWideningPreDowngradeCommand`
* `V2CheckpointPreDowngradeCommand`
* `VacuumProtocolCheckPreDowngradeCommand`
