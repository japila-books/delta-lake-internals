# DeltaTableV2

**DeltaTableV2** is a logical representation of a writable Delta table.

Using the abstractions introduced in Spark SQL 3.0.0, `DeltaTableV2` is a [Table](https://jaceklaskowski.github.io/mastering-spark-sql-book/connector/catalog/Table/) that [SupportsWrite](https://jaceklaskowski.github.io/mastering-spark-sql-book/connector/catalog/SupportsWrite/).

## Creating Instance

`DeltaTableV2` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="path"> Hadoop Path
* <span id="catalogTable"> Optional Catalog Metadata (`Option[CatalogTable]`)
* <span id="tableIdentifier"> Optional Table ID (`Option[String]`)
* <span id="timeTravelOpt"> Optional Time Travel Specification (`Option[DeltaTimeTravelSpec]`)

`DeltaTableV2` is created when:

* `DeltaCatalog` is requested to [load a table](DeltaCatalog.md#loadTable)
* `DeltaDataSource` is requested to [load a table](DeltaDataSource.md#getTable) or [create a table relation](DeltaDataSource.md#RelationProvider-createRelation)

## <span id="snapshot"> Snapshot

```scala
snapshot: Snapshot
```

`DeltaTableV2` has a [Snapshot](Snapshot.md) (that is loaded once when first accessed).

`DeltaTableV2` uses the [DeltaLog](#deltaLog) to [load it at a given version](#getSnapshotAt) (based on the optional [timeTravelSpec](#timeTravelSpec)) or [update to the latest version](#update).

`snapshot` is used when `DeltaTableV2` is requested for the [schema](#schema), [partitioning](#partitioning) and [properties](#properties).

## <span id="timeTravelSpec"> DeltaTimeTravelSpec

```scala
timeTravelSpec: Option[DeltaTimeTravelSpec]
```

`DeltaTableV2` may have a `DeltaTimeTravelSpec` specified that is either [timeTravelOpt](#timeTravelOpt) or [timeTravelByPath](#timeTravelByPath).

`timeTravelSpec` is used when `DeltaTableV2` is requested for a [Snapshot](#snapshot) and [BaseRelation](#toBaseRelation).

## <span id="toBaseRelation"> BaseRelation

```scala
toBaseRelation: BaseRelation
```

`toBaseRelation` is...FIXME

`toBaseRelation` is used when:

* `DeltaDataSource` is requested to [createRelation](DeltaDataSource.md#RelationProvider-createRelation)
* `DeltaRelation` utility is used to `fromV2Relation`
