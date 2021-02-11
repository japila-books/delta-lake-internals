# DeltaConfig

`DeltaConfig` (of type `T`) represents a [named configuration property](#key) of a delta table with values (of type `T`) in an [acceptable range](#validationFunction).

`DeltaConfig` can be [read from a metadata](#fromMetaData).

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

== [[fromMetaData]] Reading Configuration Property From Metadata -- `fromMetaData` Method

[source, scala]
----
fromMetaData(
  metadata: Metadata): T
----

`fromMetaData` looks up the <<key, key>> in the <<Metadata.md#configuration, configuration>> of the given <<Metadata.md#, Metadata>>. If not found, `fromMetaData` gives the <<defaultValue, default value>>.

In the end, `fromMetaData` converts the text representation to the proper type using <<fromString, fromString>> conversion function.

[NOTE]
====
`fromMetaData` is used when:

* `DeltaLog` is requested for <<DeltaLog.md#checkpointInterval, checkpointInterval>> and <<DeltaLog.md#tombstoneRetentionMillis, deletedFileRetentionDuration>> table properties, and to <<DeltaLog.md#assertRemovable, assert a table can be modified (not read-only)>>

* `MetadataCleanup` is requested for the <<MetadataCleanup.md#enableExpiredLogCleanup, enableExpiredLogCleanup>> and the <<MetadataCleanup.md#deltaRetentionMillis, deltaRetentionMillis>>

* `Snapshot` is requested for the <<Snapshot.md#numIndexedCols, numIndexedCols>>
====
