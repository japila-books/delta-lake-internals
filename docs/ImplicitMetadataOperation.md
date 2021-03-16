# ImplicitMetadataOperation

`ImplicitMetadataOperation` is an [abstraction](#contract) of [operations](#implementations) that can [update metadata](#updateMetadata) of a delta table (while writing out a new data).

`ImplicitMetadataOperation` operations can update schema by [merging](#canMergeSchema) and [overwriting](#canOverwriteSchema) schema.

## Contract

### <span id="canMergeSchema"> canMergeSchema

```scala
canMergeSchema: Boolean
```

Used when:

* `MergeIntoCommand` command is [executed](commands/MergeIntoCommand.md#run)
* `ImplicitMetadataOperation` is requested to [updateMetadata](#updateMetadata)

### <span id="canOverwriteSchema"> canOverwriteSchema

```scala
canOverwriteSchema: Boolean
```

Used when:

* `ImplicitMetadataOperation` is requested to [updateMetadata](#updateMetadata)

## Implementations

* [DeltaSink](DeltaSink.md)
* [MergeIntoCommand](commands/MergeIntoCommand.md)
* [WriteIntoDelta](commands/WriteIntoDelta.md)

## <span id="updateMetadata"> Updating Metadata

``` { .scala .annotate }
updateMetadata( // (1)
  txn: OptimisticTransaction,
  data: Dataset[_],
  partitionColumns: Seq[String],
  configuration: Map[String, String],
  isOverwriteMode: Boolean,
  rearrangeOnly: Boolean = false): Unit
updateMetadata(
  spark: SparkSession,
  txn: OptimisticTransaction,
  schema: StructType,
  partitionColumns: Seq[String],
  configuration: Map[String, String],
  isOverwriteMode: Boolean,
  rearrangeOnly: Boolean): Unit
```

1. Uses the `SparkSession` and the schema of the given `Dataset` and assumes the `rearrangeOnly` to be off

`updateMetadata`...FIXME

`updateMetadata` is used when:

* `WriteIntoDelta` command is [executed](commands/WriteIntoDelta.md#run)
* `MergeIntoCommand` command is [executed](commands/MergeIntoCommand.md#run)
* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)

### <span id="normalizePartitionColumns"> Normalizing Partition Columns

```scala
normalizePartitionColumns(
  spark: SparkSession,
  partitionCols: Seq[String],
  schema: StructType): Seq[String]
```

`normalizePartitionColumns`...FIXME
