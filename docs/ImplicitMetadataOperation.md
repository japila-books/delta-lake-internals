= [[ImplicitMetadataOperation]] ImplicitMetadataOperation -- Operations Updating Metadata (Schema And Partitioning)

`ImplicitMetadataOperation` is an <<contract, abstraction>> of <<implementations, operations>> that can <<updateMetadata, update metadata>> of a delta table (while writing out a new data to a delta table).

`ImplicitMetadataOperation` operations can update schema by <<canMergeSchema, merging>> and <<canOverwriteSchema, overwriting>> schema.

[[contract]]
.ImplicitMetadataOperation Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| canMergeSchema
a| [[canMergeSchema]]

[source, scala]
----
canMergeSchema: Boolean
----

Used when `ImplicitMetadataOperation` is requested to <<updateMetadata, updateMetadata>>

| canOverwriteSchema
a| [[canOverwriteSchema]]

[source, scala]
----
canOverwriteSchema: Boolean
----

Used when `ImplicitMetadataOperation` is requested to <<updateMetadata, updateMetadata>>

|===

[[implementations]]
.ImplicitMetadataOperations
[cols="30,70",options="header",width="100%"]
|===
| ImplicitMetadataOperation
| Description

| <<WriteIntoDelta.adoc#, WriteIntoDelta>>
| [[WriteIntoDelta]] Delta command for batch queries (Spark SQL)

| <<DeltaSink.adoc#, DeltaSink>>
| [[DeltaSink]] Streaming sink for streaming queries (Spark Structured Streaming)

|===

## <span id="updateMetadata"> Updating Metadata

```scala
updateMetadata(
  txn: OptimisticTransaction,
  data: Dataset[_],
  partitionColumns: Seq[String],
  configuration: Map[String, String],
  isOverwriteMode: Boolean): Unit
```

`updateMetadata`...FIXME

`updateMetadata` is used when:

* [WriteIntoDelta](WriteIntoDelta.md) command is executed
* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)

== [[normalizePartitionColumns]] Normalize Partition Columns -- `normalizePartitionColumns` Internal Method

[source, scala]
----
normalizePartitionColumns(
  spark: SparkSession,
  partitionCols: Seq[String],
  schema: StructType): Seq[String]
----

`normalizePartitionColumns`...FIXME

NOTE: `normalizePartitionColumns` is used when `ImplicitMetadataOperation` is requested to <<updateMetadata, updateMetadata>>.
