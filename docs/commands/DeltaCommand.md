# DeltaCommand

`DeltaCommand` is a marker interface for [delta commands](#implementations) to work with delta tables.

## Implementations

* [AlterDeltaTableCommand](alter/AlterDeltaTableCommand.md)
* [ConvertToDeltaCommand](convert/ConvertToDeltaCommand.md)
* [DeleteCommand](delete/DeleteCommand.md)
* [MergeIntoCommand](merge/MergeIntoCommand.md)
* [OptimizeExecutor](optimize/OptimizeExecutor.md)
* [OptimizeTableCommand](optimize/OptimizeTableCommand.md)
* [RestoreTableCommand](restore/RestoreTableCommand.md)
* [StatisticsCollection](../StatisticsCollection.md)
* [UpdateCommand](update/UpdateCommand.md)
* [VacuumCommandImpl](vacuum/VacuumCommandImpl.md)
* [WriteIntoDelta](WriteIntoDelta.md)

## <span id="parsePartitionPredicates"> parsePartitionPredicates

```scala
parsePartitionPredicates(
  spark: SparkSession,
  predicate: String): Seq[Expression]
```

`parsePartitionPredicates`...FIXME

`parsePartitionPredicates` is used when...FIXME

## <span id="verifyPartitionPredicates"> verifyPartitionPredicates

```scala
verifyPartitionPredicates(
  spark: SparkSession,
  partitionColumns: Seq[String],
  predicates: Seq[Expression]): Unit
```

`verifyPartitionPredicates`...FIXME

`verifyPartitionPredicates` is used when...FIXME

## <span id="generateCandidateFileMap"> generateCandidateFileMap

```scala
generateCandidateFileMap(
  basePath: Path,
  candidateFiles: Seq[AddFile]): Map[String, AddFile]
```

`generateCandidateFileMap`...FIXME

`generateCandidateFileMap` is used when...FIXME

## <span id="removeFilesFromPaths"> removeFilesFromPaths

```scala
removeFilesFromPaths(
  deltaLog: DeltaLog,
  nameToAddFileMap: Map[String, AddFile],
  filesToRewrite: Seq[String],
  operationTimestamp: Long): Seq[RemoveFile]
```

`removeFilesFromPaths`...FIXME

`removeFilesFromPaths` is used when:

* [DeleteCommand](delete/DeleteCommand.md) and [UpdateCommand](update/UpdateCommand.md) commands are executed

## <span id="buildBaseRelation"> Creating HadoopFsRelation (with TahoeBatchFileIndex)

```scala
buildBaseRelation(
  spark: SparkSession,
  txn: OptimisticTransaction,
  actionType: String,
  rootPath: Path,
  inputLeafFiles: Seq[String],
  nameToAddFileMap: Map[String, AddFile]): HadoopFsRelation
```

`buildBaseRelation` converts the given `inputLeafFiles` to [AddFiles](#getTouchedFile) (with the given `rootPath` and `nameToAddFileMap`).

`buildBaseRelation` creates a [TahoeBatchFileIndex](../TahoeBatchFileIndex.md) for the `AddFile`s (with the input `actionType` and `rootPath`).

In the end, `buildBaseRelation` creates a `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation/)) with the `TahoeBatchFileIndex` (and the other properties based on the [metadata](../OptimisticTransactionImpl.md#metadata) of the given [OptimisticTransaction](../OptimisticTransaction.md)).

`buildBaseRelation` is used when:

* [DeleteCommand](delete/DeleteCommand.md) and [UpdateCommand](update/UpdateCommand.md) commands are executed (with `delete` and `update` action types, respectively)

## <span id="getTouchedFile"> getTouchedFile

```scala
getTouchedFile(
  basePath: Path,
  filePath: String,
  nameToAddFileMap: Map[String, AddFile]): AddFile
```

`getTouchedFile`...FIXME

`getTouchedFile` is used when:

* `DeltaCommand` is requested to [removeFilesFromPaths](#removeFilesFromPaths) and [create a HadoopFsRelation](#buildBaseRelation) (for [DeleteCommand](delete/DeleteCommand.md) and [UpdateCommand](update/UpdateCommand.md) commands)

* [MergeIntoCommand](merge/MergeIntoCommand.md) is executed

## <span id="isCatalogTable"> isCatalogTable

```scala
isCatalogTable(
  analyzer: Analyzer,
  tableIdent: TableIdentifier): Boolean
```

`isCatalogTable`...FIXME

`isCatalogTable` is used when...FIXME

## <span id="isPathIdentifier"> isPathIdentifier

```scala
isPathIdentifier(
  tableIdent: TableIdentifier): Boolean
```

`isPathIdentifier`...FIXME

`isPathIdentifier` is used when...FIXME

## <span id="commitLarge"> commitLarge

```scala
commitLarge(
  spark: SparkSession,
  txn: OptimisticTransaction,
  actions: Iterator[Action],
  op: DeltaOperations.Operation,
  context: Map[String, String],
  metrics: Map[String, String]): Long
```

`commitLarge`...FIXME

`commitLarge` is used when:

* [ConvertToDeltaCommand](convert/ConvertToDeltaCommand.md) command is executed

### <span id="updateAndCheckpoint"> updateAndCheckpoint

```scala
updateAndCheckpoint(
  spark: SparkSession,
  deltaLog: DeltaLog,
  commitSize: Int,
  attemptVersion: Long): Unit
```

`updateAndCheckpoint`...FIXME
