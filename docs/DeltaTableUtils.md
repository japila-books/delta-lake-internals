# DeltaTableUtils Utility

`DeltaTableUtils` comes with the following utilities:

* <<isDeltaTable, DeltaTableUtils.isDeltaTable>> for checking out whether a given directory is part of delta table

* <<findDeltaTableRoot, DeltaTableUtils.findDeltaTableRoot>> for finding the root directory of a delta table

* <<splitMetadataAndDataPredicates, splitMetadataAndDataPredicates>>

## <span id="extractIfPathContainsTimeTravel"> extractIfPathContainsTimeTravel

```scala
extractIfPathContainsTimeTravel(
  session: SparkSession,
  path: String): (String, Option[DeltaTimeTravelSpec])
```

`extractIfPathContainsTimeTravel`...FIXME

`extractIfPathContainsTimeTravel` is used when `DeltaDataSource` is requested to [sourceSchema](DeltaDataSource.md#sourceSchema) and [parsePathIdentifier](DeltaDataSource.md#parsePathIdentifier).

## <span id="resolveTimeTravelVersion"> resolveTimeTravelVersion Utility

```scala
resolveTimeTravelVersion(
  conf: SQLConf,
  deltaLog: DeltaLog,
  tt: DeltaTimeTravelSpec): (Long, String)
```

`resolveTimeTravelVersion`...FIXME

`resolveTimeTravelVersion` is used when:

* `DeltaLog` is requested to [create a relation (per partition filters and time travel)](DeltaLog.md#createRelation)
* `DeltaTableV2` is requested for a [Snapshot](DeltaTableV2.md#snapshot)

== [[isDeltaTable]] isDeltaTable Utility

[source, scala]
----
isDeltaTable(
  spark: SparkSession,
  path: Path): Boolean
----

`isDeltaTable` tries to <<findDeltaTableRoot, find the root directory of the delta table>> for the given path and returns whether it was successful or not.

NOTE: `isDeltaTable` is used when `DeltaTable` utility is used to <<DeltaTable.md#forPath, create a DeltaTable>> or <<DeltaTable.md#isDeltaTable, check whether a directory is part of delta table or not>>.

== [[findDeltaTableRoot]] findDeltaTableRoot Utility

[source, scala]
----
findDeltaTableRoot(
  spark: SparkSession,
  path: Path): Option[Path]
----

`findDeltaTableRoot` traverses the Hadoop DFS-compliant path upwards (to the root directory of the file system) until `_delta_log` or `_samples` directories are found, or the root directory is reached.

For `_delta_log` or `_samples` directories, `findDeltaTableRoot` returns the parent directory.

[NOTE]
====
`findDeltaTableRoot` is used when:

* <<VacuumTableCommand.md#, VacuumTableCommand>> is executed

* `DeltaTableUtils` utility is used to <<isDeltaTable, isDeltaTable>>

* `DeltaDataSource` is requested to <<DeltaDataSource.md#RelationProvider-createRelation, create a relation>>
====

== [[splitMetadataAndDataPredicates]] splitMetadataAndDataPredicates Utility

[source, scala]
----
splitMetadataAndDataPredicates(
  condition: Expression,
  partitionColumns: Seq[String],
  spark: SparkSession): (Seq[Expression], Seq[Expression])
----

`splitMetadataAndDataPredicates`...FIXME

[NOTE]
====
`splitMetadataAndDataPredicates` is used when:

* `PartitionFiltering` is requested to PartitionFiltering.md#filesForScan[filesForScan]

* DeleteCommand.md[DeleteCommand] and UpdateCommand.md[UpdateCommand] are executed
====

== [[isPredicatePartitionColumnsOnly]] isPredicatePartitionColumnsOnly Utility

[source, scala]
----
isPredicatePartitionColumnsOnly(
  condition: Expression,
  partitionColumns: Seq[String],
  spark: SparkSession): Boolean
----

`isPredicatePartitionColumnsOnly`...FIXME

[NOTE]
====
`isPredicatePartitionColumnsOnly` is used when...FIXME
====

== [[combineWithCatalogMetadata]] combineWithCatalogMetadata Utility

[source, scala]
----
combineWithCatalogMetadata(
  sparkSession: SparkSession,
  table: CatalogTable): CatalogTable
----

`combineWithCatalogMetadata`...FIXME

NOTE: `combineWithCatalogMetadata` _seems_ unused.
