# DeltaTableV2

`DeltaTableV2` is a logical representation of a writable Delta table.

In Spark SQL 3's terms, `DeltaTableV2` is a `Table` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/Table/)) that `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/SupportsWrite/)).

## Creating Instance

`DeltaTableV2` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="path"> Hadoop Path
* <span id="catalogTable"> Optional Catalog Metadata (`Option[CatalogTable]`)
* <span id="tableIdentifier"> Optional Table ID (`Option[String]`)
* Optional [DeltaTimeTravelSpec](#timeTravelOpt)

`DeltaTableV2` is created when:

* `DeltaCatalog` is requested to [load a table](DeltaCatalog.md#loadTable)
* `DeltaDataSource` is requested to [load a table](DeltaDataSource.md#getTable) or [create a table relation](DeltaDataSource.md#RelationProvider-createRelation)

## <span id="timeTravelOpt"> DeltaTimeTravelSpec

`DeltaTableV2` may be given a [DeltaTimeTravelSpec](DeltaTimeTravelSpec.md) when [created](#creating-instance).

`DeltaTimeTravelSpec` is assumed not to be defined by default (`None`).

`DeltaTableV2` is given a `DeltaTimeTravelSpec` when:

* `DeltaDataSource` is requested for a [BaseRelation](DeltaDataSource.md#RelationProvider-createRelation)

`DeltaTimeTravelSpec` is used for [timeTravelSpec](#timeTravelSpec).

## <span id="snapshot"> Snapshot

```scala
snapshot: Snapshot
```

`DeltaTableV2` has a [Snapshot](Snapshot.md). In other words, `DeltaTableV2` represents a Delta table at a specific version.

!!! note "Scala lazy value"
    `snapshot` is a Scala lazy value and is initialized once when first accessed. Once computed it stays unchanged.

`DeltaTableV2` uses the [DeltaLog](#deltaLog) to [load it at a given version](#getSnapshotAt) (based on the optional [timeTravelSpec](#timeTravelSpec)) or [update to the latest version](#update).

`snapshot` is used when `DeltaTableV2` is requested for the [schema](#schema), [partitioning](#partitioning) and [properties](#properties).

## <span id="timeTravelSpec"> DeltaTimeTravelSpec

```scala
timeTravelSpec: Option[DeltaTimeTravelSpec]
```

`DeltaTableV2` may have a [DeltaTimeTravelSpec](DeltaTimeTravelSpec.md) specified that is either [given](#timeTravelOpt) or [extracted from the path](DeltaTableUtils.md#extractIfPathContainsTimeTravel) (for [timeTravelByPath](#timeTravelByPath)).

`timeTravelSpec` throws an `AnalysisException` when [timeTravelOpt](#timeTravelOpt) and [timeTravelByPath](#timeTravelByPath) are both defined:

```text
Cannot specify time travel in multiple formats.
```

`timeTravelSpec` is used when `DeltaTableV2` is requested for a [Snapshot](#snapshot) and [BaseRelation](#toBaseRelation).

## <span id="timeTravelByPath"> DeltaTimeTravelSpec by Path

```scala
timeTravelByPath: Option[DeltaTimeTravelSpec]
```

!!! note "Scala lazy value"
    `timeTravelByPath` is a Scala lazy value and is initialized once when first accessed. Once computed it stays unchanged.

`timeTravelByPath` is undefined when [CatalogTable](#catalogTable) is defined.

With no [CatalogTable](#catalogTable) defined, `DeltaTableV2` [parses](DeltaDataSource.md#parsePathIdentifier) the given [Path](#path) for the `timeTravelByPath` (that [resolvePath](DeltaTimeTravelSpec.md#resolvePath) under the covers).

## <span id="toBaseRelation"> Converting to Insertable HadoopFsRelation

```scala
toBaseRelation: BaseRelation
```

`toBaseRelation` [verifyAndCreatePartitionFilters](DeltaDataSource.md#verifyAndCreatePartitionFilters) for the [Path](#path), the [current Snapshot](SnapshotManagement.md#snapshot) and [partitionFilters](#partitionFilters).

In the end, `toBaseRelation` requests the [DeltaLog](#deltaLog) for an [insertable HadoopFsRelation](DeltaLog.md#createRelation).

`toBaseRelation` is used when:

* `DeltaDataSource` is requested to [createRelation](DeltaDataSource.md#RelationProvider-createRelation)
* `DeltaRelation` utility is used to `fromV2Relation`
