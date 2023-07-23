# ImplicitMetadataOperation

`ImplicitMetadataOperation` is an [abstraction](#contract) of [operations](#implementations) that can [update the metadata](#updateMetadata) of a delta table (while writing out a new data).

`ImplicitMetadataOperation` operations can update schema by [merging](#canMergeSchema) and [overwriting](#canOverwriteSchema) schema.

## Contract

### canMergeSchema { #canMergeSchema }

```scala
canMergeSchema: Boolean
```

Controls schema merging (_evolution_)

See:

* [MergeIntoCommandBase](commands/merge/MergeIntoCommandBase.md#canMergeSchema)
* [WriteIntoDelta](commands/WriteIntoDelta.md#canMergeSchema)
* [DeltaSink](delta/DeltaSink.md#canMergeSchema)

Used when:

* `ImplicitMetadataOperation` is requested to [update the metadata](#updateMetadata)

### canOverwriteSchema { #canOverwriteSchema }

```scala
canOverwriteSchema: Boolean
```

Used when:

* `ImplicitMetadataOperation` is requested to [update the metadata](#updateMetadata)

## Implementations

* [DeltaSink](delta/DeltaSink.md)
* [MergeIntoCommand](commands/merge/MergeIntoCommand.md)
* [WriteIntoDelta](commands/WriteIntoDelta.md)

## Updating Metadata { #updateMetadata }

```scala
updateMetadata(
  spark: SparkSession,
  txn: OptimisticTransaction,
  schema: StructType,
  partitionColumns: Seq[String],
  configuration: Map[String, String],
  isOverwriteMode: Boolean,
  rearrangeOnly: Boolean): Unit
```

??? note "Final Method"
    `updateMetadata` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

`updateMetadata` is used when:

* `MergeIntoCommand` is [executed](commands/merge/MergeIntoCommand.md#runMerge) (with [canMergeSchema](commands/merge/MergeIntoCommand.md#canMergeSchema) enabled)
* `WriteIntoDelta` command is requested to [write](commands/WriteIntoDelta.md#write)
* `DeltaSink` is requested to [add a streaming micro-batch](delta/DeltaSink.md#addBatch)

---

`updateMetadata` [dropColumnMappingMetadata](column-mapping/DeltaColumnMappingBase.md#dropColumnMappingMetadata) from the given `schema` (that produces `dataSchema`).

`updateMetadata` [mergeSchema](#mergeSchema) (with the `dataSchema` and the `isOverwriteMode` and `canOverwriteSchema` flags).

`updateMetadata` [normalizePartitionColumns](#normalizePartitionColumns).

`updateMetadata` branches off based on the following conditions:

1. [Delta table is just being created](#updateMetadata-table-being-created)
1. [Overwriting schema is enabled](#updateMetadata-overwriting-schema) (i.e. `isOverwriteMode` and `canOverwriteSchema` flags are enabled, and either the schema is new or partitioning changed)
1. [Merging schema is enabled](#updateMetadata-merging-schema) the schema is new and the [canMergeSchema](#canMergeSchema) is enabled (but the partitioning has not changed)
1. [Data or Partitioning Schema has changed](#updateMetadata-new-data-or-partitioning-schema)

### <span id="updateMetadata-table-being-created"> Table Being Created

`updateMetadata` creates a new [Metadata](Metadata.md) with the following:

* Uses the value of `comment` key (in the [configuration](#updateMetadata-configuration)) for the description
* FIXME

`updateMetadata` requests the given [OptimisticTransaction](OptimisticTransaction.md) to [updateMetadata](OptimisticTransactionImpl.md#updateMetadata).

### <span id="updateMetadata-overwriting-schema"> Overwriting Schema

`updateMetadata`...FIXME

### <span id="updateMetadata-merging-schema"> Merging Schema

`updateMetadata`...FIXME

### <span id="updateMetadata-new-data-or-partitioning-schema"> New Data or Partitioning Schema

`updateMetadata`...FIXME

### <span id="updateMetadata-isOverwriteMode"> isOverwriteMode

`updateMetadata` is given `isOverwriteMode` flag as follows:

* Only `false` for [MergeIntoCommand](commands/merge/MergeIntoCommand.md) with [canMergeSchema](commands/merge/MergeIntoCommand.md#canMergeSchema) enabled
* `true` for [WriteIntoDelta](commands/WriteIntoDelta.md#write) in [Overwrite](commands/WriteIntoDelta.md#isOverwriteOperation) save mode; `false` otherwise
* `true` for [DeltaSink](delta/DeltaSink.md#addBatch) in [Complete](delta/DeltaSink.md#outputMode) output mode; `false` otherwise

### <span id="updateMetadata-rearrangeOnly"> rearrangeOnly

`updateMetadata` is given `rearrangeOnly` flag as follows:

* Only `false` for [MergeIntoCommand](commands/merge/MergeIntoCommand.md) with [canMergeSchema](commands/merge/MergeIntoCommand.md#canMergeSchema) enabled
* [rearrangeOnly]((delta/DeltaWriteOptionsImpl.md#rearrangeOnly) option for [WriteIntoDelta](commands/WriteIntoDelta.md#write)
* `false` for [DeltaSink](delta/DeltaSink.md#addBatch)

### <span id="updateMetadata-configuration"> configuration

`updateMetadata` is given `configuration` as follows:

* The existing [configuration](Metadata.md#configuration) (of the [metadata](OptimisticTransactionImpl.md#metadata) of the transaction) for [MergeIntoCommand](commands/merge/MergeIntoCommand.md) with [canMergeSchema](commands/merge/MergeIntoCommand.md#canMergeSchema) enabled
* [configuration](commands/WriteIntoDelta.md#configuration) of the `WriteIntoDelta` command (while [writing out](commands/WriteIntoDelta.md#write))
* Always empty for [DeltaSink](delta/DeltaSink.md#addBatch)

### <span id="normalizePartitionColumns"> Normalizing Partition Columns

```scala
normalizePartitionColumns(
  spark: SparkSession,
  partitionCols: Seq[String],
  schema: StructType): Seq[String]
```

`normalizePartitionColumns`...FIXME

### <span id="mergeSchema"> mergeSchema

```scala
mergeSchema(
  txn: OptimisticTransaction,
  dataSchema: StructType,
  isOverwriteMode: Boolean,
  canOverwriteSchema: Boolean): StructType
```

`mergeSchema`...FIXME

## Logging

`ImplicitMetadataOperation` is an abstract class and logging is configured using the logger of the [implementations](#implementations).
