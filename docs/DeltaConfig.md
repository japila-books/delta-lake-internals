# DeltaConfig

`DeltaConfig` (of type `T`) represents a [named configuration property](#key) of a delta table with values (of type `T`).

## Creating Instance

`DeltaConfig` takes the following to be created:

* <span id="key"> Configuration Key
* <span id="defaultValue"> Default Value
* <span id="fromString"> Conversion function (from text representation of the `DeltaConfig` to the `T` type, i.e. `String => T`)
* <span id="validationFunction"> Validation function (that guards from incorrect values, i.e. `T => Boolean`)
* <span id="helpMessage"> Help message
* <span id="minimumProtocolVersion"> (optional) Minimum version of [protocol](Protocol.md) supported (default: undefined)

`DeltaConfig` is created when:

* `DeltaConfigs` utility is used to [build a DeltaConfig](DeltaConfigs.md#buildConfig)

## <span id="fromMetaData"> Reading Configuration Property From Metadata

```scala
fromMetaData(
  metadata: Metadata): T
```

`fromMetaData` looks up the [key](#key) in the [configuration](Metadata.md#configuration) of the given [Metadata](Metadata.md). If not found, `fromMetaData` gives the [default value](#defaultValue).

In the end, `fromMetaData` converts the text representation to the proper type using [fromString](#fromString) conversion function.

`fromMetaData` is used when:

* `Checkpoints` utility is used to [buildCheckpoint](Checkpoints.md#buildCheckpoint)
* `DeltaErrors` utility is used to [logFileNotFoundException](DeltaErrors.md#logFileNotFoundException)
* `DeltaLog` is requested for [checkpointInterval](DeltaLog.md#checkpointInterval) and [deletedFileRetentionDuration](DeltaLog.md#tombstoneRetentionMillis) table properties, and to [assert a table is not read-only](DeltaLog.md#assertRemovable)
* `MetadataCleanup` is requested for the [enableExpiredLogCleanup](MetadataCleanup.md#enableExpiredLogCleanup) and the [deltaRetentionMillis](MetadataCleanup.md#deltaRetentionMillis)
* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit)
* `Snapshot` is requested for the [numIndexedCols](Snapshot.md#numIndexedCols)
