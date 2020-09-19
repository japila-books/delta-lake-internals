= DeltaConfig -- Configuration Property Of Delta Table (Metadata)

[[T]]
`DeltaConfig` (of type `T`) represents a <<key, named configuration property>> of a delta table with values (of type `T`) in an <<validationFunction, acceptable range>>.

`DeltaConfig` can be <<fromMetaData, read from a metadata>>.

== [[creating-instance]] Creating DeltaConfig Instance

`DeltaConfig` takes the following to be created:

* [[key]] Key
* [[defaultValue]] Default value
* [[fromString]] Conversion function (from text representation of the `DeltaConfig` to the <<T, type>>, i.e. `String => T`)
* [[validationFunction]] Validation function (that guards from incorrect values, i.e. `T => Boolean`)
* [[helpMessage]] Help message
* [[minimumProtocolVersion]] (optional) Minimum version of <<Protocol.adoc#, protocol>> supported

`DeltaConfig` initializes the <<internal-properties, internal properties>>.

== [[fromMetaData]] Reading Configuration Property From Metadata -- `fromMetaData` Method

[source, scala]
----
fromMetaData(
  metadata: Metadata): T
----

`fromMetaData` looks up the <<key, key>> in the <<Metadata.adoc#configuration, configuration>> of the given <<Metadata.adoc#, Metadata>>. If not found, `fromMetaData` gives the <<defaultValue, default value>>.

In the end, `fromMetaData` converts the text representation to the proper type using <<fromString, fromString>> conversion function.

[NOTE]
====
`fromMetaData` is used when:

* `DeltaLog` is requested for <<DeltaLog.adoc#checkpointInterval, checkpointInterval>> and <<DeltaLog.adoc#tombstoneRetentionMillis, deletedFileRetentionDuration>> table properties, and to <<DeltaLog.adoc#assertRemovable, assert a table can be modified (not read-only)>>

* `MetadataCleanup` is requested for the <<MetadataCleanup.adoc#enableExpiredLogCleanup, enableExpiredLogCleanup>> and the <<MetadataCleanup.adoc#deltaRetentionMillis, deltaRetentionMillis>>

* `Snapshot` is requested for the <<Snapshot.adoc#numIndexedCols, numIndexedCols>>
====
