# DeltaTableUtils Utility

## <span id="extractIfPathContainsTimeTravel"> extractIfPathContainsTimeTravel

```scala
extractIfPathContainsTimeTravel(
  session: SparkSession,
  path: String): (String, Option[DeltaTimeTravelSpec])
```

`extractIfPathContainsTimeTravel` uses the internal [spark.databricks.delta.timeTravel.resolveOnIdentifier.enabled](configuration-properties/DeltaSQLConf.md#timeTravel.resolveOnIdentifier.enabled) configuration property to find time travel patterns in the given `path`.

`extractIfPathContainsTimeTravel`...FIXME

`extractIfPathContainsTimeTravel` is used when:

* `DeltaDataSource` is requested to [sourceSchema](delta/DeltaDataSource.md#sourceSchema) and [parsePathIdentifier](delta/DeltaDataSource.md#parsePathIdentifier)

## <span id="findDeltaTableRoot"> findDeltaTableRoot

```scala
findDeltaTableRoot(
  spark: SparkSession,
  path: Path,
  options: Map[String, String] = Map.empty): Option[Path]
```

`findDeltaTableRoot` traverses the Hadoop DFS-compliant path upwards (to the root directory of the file system) until `_delta_log` or `_samples` directories are found, or the root directory is reached.

For `_delta_log` or `_samples` directories, `findDeltaTableRoot` returns the parent directory (of `_delta_log` directory).

`findDeltaTableRoot` is used when:

* [DeltaTable.isDeltaTable](DeltaTable.md#isDeltaTable) utility is used
* [VacuumTableCommand](commands/vacuum/VacuumTableCommand.md) is executed
* `DeltaTableUtils` utility is used to [isDeltaTable](#isDeltaTable)
* `DeltaDataSource` utility is used to [parsePathIdentifier](delta/DeltaDataSource.md#parsePathIdentifier)

## <span id="isPredicatePartitionColumnsOnly"> isPredicatePartitionColumnsOnly

```scala
isPredicatePartitionColumnsOnly(
  condition: Expression,
  partitionColumns: Seq[String],
  spark: SparkSession): Boolean
```

`isPredicatePartitionColumnsOnly` holds `true` when all of the references of the `condition` expression are among the `partitionColumns`.

`isPredicatePartitionColumnsOnly` is used when:

* `DeltaTableUtils` is used to [isPredicateMetadataOnly](#isPredicateMetadataOnly)
* `OptimisticTransactionImpl` is requested for the [filterFiles](OptimisticTransactionImpl.md#filterFiles)
* `DeltaSourceSnapshot` is requested for the [partition](delta/DeltaSourceSnapshot.md#partitionFilters) and [data](delta/DeltaSourceSnapshot.md#dataFilters) filters

## <span id="isDeltaTable"> isDeltaTable

```scala
isDeltaTable(
  table: CatalogTable): Boolean
isDeltaTable(
  spark: SparkSession,
  path: Path): Boolean
isDeltaTable(
  spark: SparkSession,
  tableName: TableIdentifier): Boolean
```

`isDeltaTable`...FIXME

`isDeltaTable` is used when:

* `DeltaCatalog` is requested to [loadTable](DeltaCatalog.md#loadTable)
* [DeltaTable.forName](DeltaTable.md#forName), [DeltaTable.forPath](DeltaTable.md#forPath) and [DeltaTable.isDeltaTable](DeltaTable.md#isDeltaTable) utilities are used
* `DeltaTableIdentifier` utility is used to [create a DeltaTableIdentifier from a TableIdentifier](DeltaTableIdentifier.md#apply)
* `DeltaUnsupportedOperationsCheck` is requested to [fail](DeltaUnsupportedOperationsCheck.md#fail)

## <span id="resolveTimeTravelVersion"> resolveTimeTravelVersion

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

## <span id="splitMetadataAndDataPredicates"> splitMetadataAndDataPredicates

```scala
splitMetadataAndDataPredicates(
  condition: Expression,
  partitionColumns: Seq[String],
  spark: SparkSession): (Seq[Expression], Seq[Expression])
```

`splitMetadataAndDataPredicates` splits conjunctive (_and_) predicates in the given `condition` expression and partitions them into two collections based on the [isPredicateMetadataOnly](#isPredicateMetadataOnly) predicate (with the given `partitionColumns`).

`splitMetadataAndDataPredicates` is used when:

* `PartitionFiltering` is requested for [filesForScan](PartitionFiltering.md#filesForScan)
* [DeleteCommand](commands/delete/DeleteCommand.md) is executed (with a delete condition)
* [UpdateCommand](commands/update/UpdateCommand.md) is executed

### <span id="isPredicateMetadataOnly"> isPredicateMetadataOnly

```scala
isPredicateMetadataOnly(
  condition: Expression,
  partitionColumns: Seq[String],
  spark: SparkSession): Boolean
```

`isPredicateMetadataOnly` holds `true` when the following hold about the given `condition`:

1. Is [partition column only](#isPredicatePartitionColumnsOnly) (given the `partitionColumns`)
1. Does not contain a subquery
