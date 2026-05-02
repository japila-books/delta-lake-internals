# Metadata

`Metadata` is an [Action](Action.md) to update the metadata of a [delta table](../DeltaLog.md#metadata) (indirectly via the [Snapshot](../Snapshot.md#metadata)).

`Metadata` of a delta table can be reviewed using [DESCRIBE DETAIL](../commands/describe-detail/index.md) command.

## Creating Instance

`Metadata` takes the following to be created:

* [Id](#id)
* <span id="name"> Name (default: `null`)
* <span id="description"> Description (default: `null`)
* <span id="format"> Format (default: empty)
* <span id="schemaString"><span id="schema"> Schema (default: `null`)
* <span id="partitionColumns"> Partition Columns (default: `Nil`)
* <span id="configuration"> Table Configuration (default: (empty))
* <span id="createdTime"> Created Time (default: undefined)

`Metadata` is created when:

* `DeltaLog` is requested for the [metadata](../DeltaLog.md#metadata) (but that should be rare)
* `InitialSnapshot` is created
* [CONVERT TO DELTA](../commands/convert/index.md) command is executed
* `ImplicitMetadataOperation` is requested to [updateMetadata](../ImplicitMetadataOperation.md#updateMetadata)

## Update Metadata

`Metadata` can be [updated](../OptimisticTransactionImpl.md#updateMetadata) in a [transaction](../OptimisticTransactionImpl.md) only once (and only when created for an uninitialized table, when [readVersion](../OptimisticTransactionImpl.md#readVersion) is `-1`).

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

## Table ID { #id }

`Metadata` uses a **Table ID** (aka [reservoirId](../spark-connector/DeltaSourceOffset.md#reservoirId)) to uniquely identify a delta table.

This table ID never changes through the history of the table.

`Metadata` can be given a table ID when [created](#creating-instance) or defaults to a random UUID ([Java]({{ java.api }}/java/util/UUID.html#randomUUID)).

!!! note
    When I asked the question [tableId and reservoirId - Why two different names for metadata ID?](https://groups.google.com/forum/#!topic/delta-users/5OKEFvVKiew) on delta-users mailing list, Tathagata Das wrote:

    > Any reference to "reservoir" is just legacy code. In the early days of this project, the project was called "Tahoe" and each table is called a "reservoir" (Tahoe is one of the 2nd deepest lake in US, and is a very large reservoir of water ;) ). So you may still find those two terms all around the codebase.

    > In some cases, like DeltaSourceOffset, the term `reservoirId` is in the json that is written to the streaming checkpoint directory. So we cannot change that for backward compatibility.

## Column Mapping Mode { #columnMappingMode }

```scala
columnMappingMode: DeltaColumnMappingMode
```

`columnMappingMode` is the value of [columnMapping.mode](../table-properties/DeltaConfigs.md#COLUMN_MAPPING_MODE) table property ([from this Metadata](../table-properties/DeltaConfig.md#fromMetaData)).

`columnMappingMode` is used when:

* `DeltaFileFormat` is requested for the [FileFormat](../DeltaFileFormat.md#fileFormat)

## Data Schema (of Delta Table) { #dataSchema }

```scala
dataSchema: StructType
```

`dataSchema` is the [schema](#schema) without the [partition columns](#partitionColumns) (and is the columns written out to data files).

??? note "Lazy Value"
    `dataSchema` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

---

`dataSchema` is used when:

* `OptimisticTransactionImpl` is requested to [verify a new metadata](../OptimisticTransactionImpl.md#verifyNewMetadata)
* `Snapshot` is requested for the [data schema](../Snapshot.md#dataSchema)

## coordinatedCommitsCoordinatorName { #coordinatedCommitsCoordinatorName }

```scala
coordinatedCommitsCoordinatorName: Option[String]
```

`coordinatedCommitsCoordinatorName` is the value of [delta.coordinatedCommits.commitCoordinator-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_NAME) in [this Metadata](../table-properties/DeltaConfig.md#fromMetaData).

??? note "Lazy Value"
    `coordinatedCommitsCoordinatorName` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

---

`coordinatedCommitsCoordinatorName` is used when:

* `OptimisticTransactionImpl` is requested to [doCommitRetryIteratively](../OptimisticTransactionImpl.md#doCommitRetryIteratively) and [prepareCommit](../OptimisticTransactionImpl.md#prepareCommit)
* `CoordinatedCommitsUtils` is requested to [getCommitCoordinatorClient](../coordinated-commits/CoordinatedCommitsUtils.md#getCommitCoordinatorClient) and [getCoordinatedCommitsConfs](../coordinated-commits/CoordinatedCommitsUtils.md#getCoordinatedCommitsConfs)
* `TransactionHelper` is requested to [createCoordinatedCommitsStats](../TransactionHelper.md#createCoordinatedCommitsStats)
