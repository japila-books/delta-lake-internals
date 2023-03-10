# Metadata

`Metadata` is an [Action](Action.md) to update the metadata of a [delta table](DeltaLog.md#metadata) (indirectly via the [Snapshot](Snapshot.md#metadata)).

Use [DescribeDeltaDetailCommand](commands/describe-detail/DescribeDeltaDetailCommand.md) to review the metadata of a delta table.

## Creating Instance

`Metadata` takes the following to be created:

* [Id](#id)
* <span id="name"> Name (default: `null`)
* <span id="description"> Description (default: `null`)
* <span id="format"> Format (default: empty)
* <span id="schemaString"><span id="schema"> Schema (default: `null`)
* <span id="partitionColumns"> Partition Columns (default: `Nil`)
* <span id="configuration"> Table Configuration (default: `Map.empty`)
* <span id="createdTime"> Created Time (default: current time)

`Metadata` is created when:

* `DeltaLog` is requested for the [metadata](DeltaLog.md#metadata) (but that should be rare)
* `InitialSnapshot` is created
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)

## Updating Metadata

`Metadata` can be [updated](OptimisticTransactionImpl.md#updateMetadata) in a [transaction](OptimisticTransactionImpl.md) once only (and only when created for an uninitialized table, when [readVersion](OptimisticTransactionImpl.md#readVersion) is `-1`).

```scala
txn.metadata
```

## Demo

```scala
val path = "/tmp/delta/users"

import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, path)

import org.apache.spark.sql.delta.actions.Metadata
assert(deltaLog.snapshot.metadata.isInstanceOf[Metadata])

deltaLog.snapshot.metadata.id
```

## <span id="id"> Table ID

`Metadata` uses a **Table ID** (aka [reservoirId](DeltaSourceOffset.md#reservoirId)) to uniquely identify a delta table and is never going to change through the history of the table.

`Metadata` can be given a table ID when [created](#creating-instance) or defaults to a random UUID ([Java]({{ java.api }}/java/util/UUID.html#randomUUID)).

!!! note
    When I asked the question [tableId and reservoirId - Why two different names for metadata ID?](https://groups.google.com/forum/#!topic/delta-users/5OKEFvVKiew) on delta-users mailing list, Tathagata Das wrote:

    > Any reference to "reservoir" is just legacy code. In the early days of this project, the project was called "Tahoe" and each table is called a "reservoir" (Tahoe is one of the 2nd deepest lake in US, and is a very large reservoir of water ;) ). So you may still find those two terms all around the codebase.

    > In some cases, like DeltaSourceOffset, the term `reservoirId` is in the json that is written to the streaming checkpoint directory. So we cannot change that for backward compatibility.

## <span id="columnMappingMode"> Column Mapping Mode

```scala
columnMappingMode: DeltaColumnMappingMode
```

`columnMappingMode` is the value of [columnMapping.mode](DeltaConfigs.md#COLUMN_MAPPING_MODE) table property ([from this Metadata](DeltaConfig.md#fromMetaData)).

`columnMappingMode` is used when:

* `DeltaFileFormat` is requested for the [FileFormat](DeltaFileFormat.md#fileFormat)

## <span id="dataSchema"> Data Schema (of Delta Table)

```scala
dataSchema: StructType
```

??? note "Lazy Value"
    `dataSchema` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`dataSchema` is the [schema](#schema) without the [partition columns](#partitionColumns) (and is the columns written out to data files).

`dataSchema` is used when:

* `OptimisticTransactionImpl` is requested to [verify a new metadata](OptimisticTransactionImpl.md#verifyNewMetadata)
* `Snapshot` is requested for the [data schema](Snapshot.md#dataSchema)
