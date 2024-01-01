# DeltaCommand

`DeltaCommand` is a marker interface for [delta commands](#implementations).

## Implementations

* [AlterDeltaTableCommand](alter/AlterDeltaTableCommand.md)
* [ConvertToDeltaCommandBase](convert/ConvertToDeltaCommand.md)
* [CreateDeltaTableCommand](CreateDeltaTableCommand.md)
* [DeleteCommand](delete/DeleteCommand.md)
* [DescribeDeltaDetailCommand](describe-detail/DescribeDeltaDetailCommand.md)
* [DescribeDeltaHistory](describe-history/DescribeDeltaHistory.md)
* [DMLWithDeletionVectorsHelper](../deletion-vectors/DMLWithDeletionVectorsHelper.md)
* [MergeIntoCommandBase](merge/MergeIntoCommandBase.md)
* [OptimizeExecutor](optimize/OptimizeExecutor.md)
* [OptimizeTableCommandBase](optimize/OptimizeTableCommandBase.md)
* [RestoreTableCommand](restore/RestoreTableCommand.md)
* [ShowDeltaTableColumnsCommand](show-columns/ShowDeltaTableColumnsCommand.md)
* [StatisticsCollection](../StatisticsCollection.md)
* [UpdateCommand](update/UpdateCommand.md)
* [VacuumCommandImpl](vacuum/VacuumCommandImpl.md)
* [WriteIntoDelta](WriteIntoDelta.md)

## <span id="parsePredicates"> Converting Predicate Text to Catalyst Expression

```scala
parsePredicates(
  spark: SparkSession,
  predicate: String): Seq[Expression]
```

`parsePredicates` converts the given `predicate` text to an `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)).

---

`parsePredicates` requests the given `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession)) for the session `ParserInterface` ([Spark SQL]({{ book.spark_sql }}/sql/ParserInterface)) to `parseExpression` the given `predicate` text.

---

`parsePredicates` is used when:

* [OptimizeTableCommand](optimize/OptimizeTableCommand.md) is executed (to convert the [partitionPredicate](optimize/OptimizeTableCommand.md#partitionPredicate))
* `WriteIntoDelta` command is requested to [write](WriteIntoDelta.md#write) (to convert the [replaceWhere](../delta/DeltaWriteOptions.md#replaceWhere) option with predicates)

## <span id="verifyPartitionPredicates"> Verifying Partition Predicates

```scala
verifyPartitionPredicates(
  spark: SparkSession,
  partitionColumns: Seq[String],
  predicates: Seq[Expression]): Unit
```

`verifyPartitionPredicates` asserts that the given `predicates` expressions are as follows:

* Contain no subqueries
* Reference partition columns only (`partitionColumns`)

`verifyPartitionPredicates` is used when:

* [OptimizeTableCommand](optimize/OptimizeTableCommand.md) is executed (to verify the [partitionPredicate](optimize/OptimizeTableCommand.md#partitionPredicate) if defined)
* `WriteIntoDelta` command is requested to [write](WriteIntoDelta.md#write) (to verify the [replaceWhere](../delta/DeltaWriteOptions.md#replaceWhere) option for [SaveMode.Overwrite](WriteIntoDelta.md#mode) mode)
* `StatisticsCollection` utility is used to [recompute statistics of a delta table](../StatisticsCollection.md#recompute)

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

## Creating HadoopFsRelation (with TahoeBatchFileIndex) { #buildBaseRelation }

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

---

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

`isCatalogTable` is used when:

* `ConvertToDeltaCommandBase` is requested to [isCatalogTable](convert/ConvertToDeltaCommand.md#isCatalogTable)

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

* [ConvertToDeltaCommand](convert/ConvertToDeltaCommand.md) command is executed (and requested to [performConvert](convert/ConvertToDeltaCommand.md#performConvert))
* [RestoreTableCommand](restore/RestoreTableCommand.md) command is executed

### <span id="updateAndCheckpoint"> updateAndCheckpoint

```scala
updateAndCheckpoint(
  spark: SparkSession,
  deltaLog: DeltaLog,
  commitSize: Int,
  attemptVersion: Long): Unit
```

`updateAndCheckpoint` requests the given [DeltaLog](../DeltaLog.md) to [update](../SnapshotManagement.md#update).

`updateAndCheckpoint` prints out the following INFO message to the logs:

```text
Committed delta #[attemptVersion] to [logPath]. Wrote [commitSize] actions.
```

In the end, `updateAndCheckpoint` requests the given [DeltaLog](../DeltaLog.md) to [checkpoint](../checkpoints/Checkpoints.md#checkpoint) the current snapshot.

#### <span id="updateAndCheckpoint-IllegalStateException"> IllegalStateException

`updateAndCheckpoint` throws an `IllegalStateException` if the version after update does not match the assumed `attemptVersion`:

```text
The committed version is [attemptVersion] but the current version is [currentSnapshot].
```

## Posting Metric Updates { #sendDriverMetrics }

```scala
sendDriverMetrics(
  spark: SparkSession,
  metrics: Map[String, SQLMetric]): Unit
```

??? warning "Procedure"
    `sendDriverMetrics` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`sendDriverMetrics` announces the updates to the given `SQLMetric`s ([Spark SQL]({{ book.spark_sql }}/SQLMetric/#postDriverMetricUpdates)).

---

`sendDriverMetrics` is used when:

* `DeleteCommand` is requested to [run](delete/DeleteCommand.md#run) and [performDelete](delete/DeleteCommand.md#performDelete)
* `MergeIntoCommand` is requested to [run merge](merge/MergeIntoCommand.md#runMerge)
* `UpdateCommand` is requested to [run](update/UpdateCommand.md#run) (and [performUpdate](update/UpdateCommand.md#performUpdate))

## Logging

`DeltaCommand` is an abstract class and logging is configured using the logger of the [implementations](#implementations).
