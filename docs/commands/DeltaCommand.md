# DeltaCommand

**DeltaCommand** is a marker interface for [commands](#implementations) to work with data in delta tables.

## Implementations

* [AlterDeltaTableCommand](AlterDeltaTableCommand.md)
* [ConvertToDeltaCommand](ConvertToDeltaCommand.md)
* [DeleteCommand](DeleteCommand.md)
* [MergeIntoCommand](MergeIntoCommand.md)
* [UpdateCommand](UpdateCommand.md)
* [VacuumCommandImpl](VacuumCommandImpl.md)
* [WriteIntoDelta](WriteIntoDelta.md)

## <span id="parsePartitionPredicates"> parsePartitionPredicates Method

```scala
parsePartitionPredicates(
  spark: SparkSession,
  predicate: String): Seq[Expression]
```

`parsePartitionPredicates`...FIXME

`parsePartitionPredicates` is used when...FIXME

## <span id="verifyPartitionPredicates"> verifyPartitionPredicates Method

```scala
verifyPartitionPredicates(
  spark: SparkSession,
  partitionColumns: Seq[String],
  predicates: Seq[Expression]): Unit
```

`verifyPartitionPredicates`...FIXME

`verifyPartitionPredicates` is used when...FIXME

## <span id="generateCandidateFileMap"> generateCandidateFileMap Method

```scala
generateCandidateFileMap(
  basePath: Path,
  candidateFiles: Seq[AddFile]): Map[String, AddFile]
```

`generateCandidateFileMap`...FIXME

`generateCandidateFileMap` is used when...FIXME

## <span id="removeFilesFromPaths"> removeFilesFromPaths Method

```scala
removeFilesFromPaths(
  deltaLog: DeltaLog,
  nameToAddFileMap: Map[String, AddFile],
  filesToRewrite: Seq[String],
  operationTimestamp: Long): Seq[RemoveFile]
```

`removeFilesFromPaths`...FIXME

`removeFilesFromPaths` is used when [DeleteCommand](DeleteCommand.md) and [UpdateCommand](UpdateCommand.md) commands are executed.

## <span id="buildBaseRelation"> Creating HadoopFsRelation (With TahoeBatchFileIndex)

```scala
buildBaseRelation(
  spark: SparkSession,
  txn: OptimisticTransaction,
  actionType: String,
  rootPath: Path,
  inputLeafFiles: Seq[String],
  nameToAddFileMap: Map[String, AddFile]): HadoopFsRelation
```

[[buildBaseRelation-scannedFiles]]
`buildBaseRelation` converts the given `inputLeafFiles` to <<getTouchedFile, AddFiles>> (with the given `rootPath` and `nameToAddFileMap`).

`buildBaseRelation` creates a <<TahoeBatchFileIndex.md#, TahoeBatchFileIndex>> for the `actionType`, the <<buildBaseRelation-scannedFiles, AddFiles>> and the `rootPath`.

In the end, `buildBaseRelation` creates a `HadoopFsRelation` with the `TahoeBatchFileIndex` (and the other properties based on the <<OptimisticTransactionImpl.md#metadata, metadata>> of the given <<OptimisticTransaction.md#, OptimisticTransaction>>).

`buildBaseRelation` is used when [DeleteCommand](DeleteCommand.md) and [UpdateCommand](UpdateCommand.md) commands are executed (with `delete` and `update` action types, respectively).

## <span id="getTouchedFile"> getTouchedFile Method

```scala
getTouchedFile(
  basePath: Path,
  filePath: String,
  nameToAddFileMap: Map[String, AddFile]): AddFile
```

`getTouchedFile`...FIXME

`getTouchedFile` is used when:

* `DeltaCommand` is requested to [removeFilesFromPaths](#removeFilesFromPaths) and [create a HadoopFsRelation](#buildBaseRelation) (for [DeleteCommand](DeleteCommand.md) and [UpdateCommand](UpdateCommand.md) commands)

* [MergeIntoCommand](MergeIntoCommand.md) is executed

## <span id="isCatalogTable"> isCatalogTable Method

```scala
isCatalogTable(
  analyzer: Analyzer,
  tableIdent: TableIdentifier): Boolean
```

`isCatalogTable`...FIXME

`isCatalogTable` is used when...FIXME

## <span id="isPathIdentifier"> isPathIdentifier Method

```scala
isPathIdentifier(
  tableIdent: TableIdentifier): Boolean
```

`isPathIdentifier`...FIXME

`isPathIdentifier` is used when...FIXME
