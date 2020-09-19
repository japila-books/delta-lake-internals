= DeltaSourceOffset -- Streaming Offset Of DeltaSource

`DeltaSourceOffset` is a streaming `Offset` for DeltaSource.adoc[DeltaSource].

TIP: Read up on https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-Offset.html[Offset] in https://bit.ly/spark-structured-streaming[The Internals of Spark Structured Streaming] online book.

`DeltaSourceOffset` is <<creating-instance, created>> (via <<apply, apply>> utility) when `DeltaSource` is requested for the DeltaSource.adoc#getOffset[latest offset] and a DeltaSource.adoc#getBatch[batch (for the given starting and ending offsets)].

[[VERSION]]
`DeltaSourceOffset` uses the version `1`.

== [[creating-instance]] Creating DeltaSourceOffset Instance

`DeltaSourceOffset` takes the following to be created:

* [[sourceVersion]] Source Version (always <<VERSION, 1>>)
* [[reservoirId]] Reservoir ID (aka DeltaSource.adoc#tableId[Table ID])
* [[reservoirVersion]] Reservoir Version
* [[index]] Index
* [[isStartingVersion]] `isStartingVersion` flag

== [[apply]] Creating DeltaSourceOffset Instance -- `apply` Utility

[source, scala]
----
apply(
  reservoirId: String,
  reservoirVersion: Long,
  index: Long,
  isStartingVersion: Boolean): DeltaSourceOffset
apply(
  reservoirId: String,
  offset: Offset): DeltaSourceOffset
----

`apply` creates a new `DeltaSourceOffset` (for the <<VERSION, version>> and the given arguments) or converts the given `Offset` to a `DeltaSourceOffset`.

NOTE: `apply` is used when `DeltaSource` is requested for the DeltaSource.adoc#getOffset[latest offset] and a DeltaSource.adoc#getBatch[batch (for the given starting and ending offsets)].

== [[json]] `json` Method

[source, scala]
----
json: String
----

NOTE: `json` is part of the `Offset` contract to serialize an offset to JSON.

`json`...FIXME

== [[validateSourceVersion]] `validateSourceVersion` Internal Utility

[source, scala]
----
validateSourceVersion(
  json: String): Unit
----

`validateSourceVersion`...FIXME

NOTE: `validateSourceVersion` is used when...FIXME
