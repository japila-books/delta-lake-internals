# AddFile

`AddFile` is a [FileAction](FileAction.md) that represents an action of adding a new [file](#path) to a delta table.

## Creating Instance

`AddFile` takes the following to be created:

* <span id="path"> File Path
* <span id="partitionValues"> Partition values (`Map[String, String]`)
* <span id="size"> Size (in bytes)
* <span id="modificationTime"> Modification time
* [dataChange flag](#dataChange)
* [JSON-encoded File Statistics](#stats)
* <span id="tags"> Tags
* <span id="deletionVector"> [DeletionVectorDescriptor](deletion-vectors/DeletionVectorDescriptor.md)
* <span id="baseRowId"> Base Row ID
* <span id="defaultRowCommitVersion"> Default Row Commit Version

`AddFile` is created when:

* `ConvertUtilsBase` is requested to `createAddFile`
* `DelayedCommitProtocol` is requested to [buildActionFromAddedFile](DelayedCommitProtocol.md#buildActionFromAddedFile)
* `TahoeChangeFileIndex` is requested to `matchingFiles`
* `TahoeRemoveFileIndex` is requested to [matchingFiles](change-data-feed/TahoeRemoveFileIndex.md#matchingFiles)
* `DeltaSource` is requested to [filterAndGetIndexedFiles](spark-connector/DeltaSource.md#filterAndGetIndexedFiles) (for a sentinel)

### dataChange { #dataChange }

??? note "FileAction"

    ```scala
    dataChange: Boolean
    ```

    `dataChange` is part of the [FileAction](FileAction.md#dataChange) abstraction.

`AddFile` is given `dataChange` flag when [created](#creating-instance).

`dataChange` is enabled (`true`) when:

* `ConvertUtilsBase` is requested to `createAddFile`
* `DelayedCommitProtocol` is requested to [buildActionFromAddedFile](DelayedCommitProtocol.md#buildActionFromAddedFile)

`dataChange` is disabled (`false`) when:

* `TahoeChangeFileIndex` is requested to [matchingFiles](change-data-feed/TahoeChangeFileIndex.md#matchingFiles)
* `DeltaSource` is requested to [filterAndGetIndexedFiles](spark-connector/DeltaSource.md#filterAndGetIndexedFiles) (for a sentinel)

`dataChange` can also be specified when:

* `TahoeRemoveFileIndex` is requested to [matchingFiles](change-data-feed/TahoeRemoveFileIndex.md#matchingFiles)

### File Statistics { #stats }

```scala
stats: String
```

`AddFile` can be given a JSON-encoded file statistics when [created](#creating-instance).

The statistics are undefined (`null`) by default.

The statistics can be defined when:

* `ConvertToDeltaCommandUtils` is requested to [computeStats](commands/convert/ConvertToDeltaCommandUtils.md#computeStats)
* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles) (and [spark.databricks.delta.stats.collect](configuration-properties/DeltaSQLConf.md#DELTA_COLLECT_STATS) configuration property is enabled)
* `StatisticsCollection` is requested to [recompute statistics for a delta table](StatisticsCollection.md#recompute) (_seems_ to be used for testing only)

`stats` is used when:

* `AddFile` is requested for [parsedStatsFields](#parsedStatsFields)

## numLogicalRecords { #numLogicalRecords }

??? note "Signature"

    ```scala
    numLogicalRecords: Option[Long]
    ```

    `numLogicalRecords` is part of the [FileAction](FileAction.md#numLogicalRecords) abstraction.

`numLogicalRecords` is `numLogicalRecords` from the [parsedStatsFields](#parsedStatsFields), if available.

??? note "Lazy Value"
    `numLogicalRecords` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

### parsedStatsFields { #parsedStatsFields }

```scala
parsedStatsFields: Option[ParsedStatsFields]
```

`parsedStatsFields` takes the value of `numRecords` in the [stats](#stats), if available, minus the [numDeletedRecords](#numDeletedRecords).

??? note "Lazy Value"
    `parsedStatsFields` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## <span id="wrap"> Converting to SingleAction

```scala
wrap: SingleAction
```

`wrap` is part of the [Action](Action.md#wrap) abstraction.

`wrap` creates a new [SingleAction](SingleAction.md) with the `add` field set to this `AddFile`.

## <span id="remove"> Converting to RemoveFile with Defaults

```scala
remove: RemoveFile
```

`remove` [creates a RemoveFile](#removeWithTimestamp) for the [path](#path) (with the current time and `dataChange` flag enabled).

`remove` is used when:

* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed
* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write) (with `Overwrite` mode)
* `DeltaSink` is requested to [add a streaming micro-batch](spark-connector/DeltaSink.md#addBatch) (with `Complete` output mode)

## Converting to RemoveFile { #removeWithTimestamp }

```scala
removeWithTimestamp(
  timestamp: Long = System.currentTimeMillis(),
  dataChange: Boolean = true): RemoveFile
```

`remove` creates a new [RemoveFile](RemoveFile.md) action for the [path](#path) with the given `timestamp` and `dataChange` flag.

??? note "`dataChange` Flag is Disabled for OptimizeTableCommand"
    `dataChange` is `true` (enabled) by default.

    `dataChange` can only be changed (to `false`) when:

    * `AddFile` is requested to [removeRows](#removeRows) (that does not change `dataChange` flag though)
    * `OptimizeExecutor` is requested to [runOptimizeBinJob](commands/optimize/OptimizeExecutor.md#runOptimizeBinJob)

    It is only [OptimizeTableCommand](commands/optimize/OptimizeTableCommand.md) that explicitly turns `dataChange` off (`false`).

`removeWithTimestamp` is used when:

* `AddFile` is requested to [create a RemoveFile action with the defaults](#remove), [removeRows](#removeRows)
* [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md), [DeleteCommand](commands/delete/DeleteCommand.md), [OptimizeTableCommand](commands/optimize/OptimizeTableCommand.md), [RestoreTableCommand](commands/restore/RestoreTableCommand.md) and [UpdateCommand](commands/update/UpdateCommand.md) commands are executed
* `DMLWithDeletionVectorsHelper` is requested to [processUnmodifiedData](deletion-vectors/DMLWithDeletionVectorsHelper.md#processUnmodifiedData)
* `DeltaCommand` is requested to [removeFilesFromPaths](commands/DeltaCommand.md#removeFilesFromPaths)

## removeRows { #removeRows }

```scala
removeRows(
  deletionVector: DeletionVectorDescriptor,
  updateStats: Boolean,
  dataChange: Boolean = true): (AddFile, RemoveFile)
```

`removeRows`...FIXME

---

`removeRows` is used when:

* `DMLWithDeletionVectorsHelper` is requested to [processUnmodifiedData](deletion-vectors/DMLWithDeletionVectorsHelper.md#processUnmodifiedData)

## tag { #tag }

```scala
tag(
  tag: AddFile.Tags.KeyType): Option[String]
```

`tag` [gets the value of the given tag](FileAction.md#getTag).

---

`tag` is used when:

* `AddFile` is requested for an [insertionTime](#insertionTime) (that does not seem to be used anywhere)

## <span id="numLogicalRecords"> numLogicalRecords

??? note "Signature"

    ```scala
    numLogicalRecords: Option[Long]
    ```

    `numLogicalRecords` is part of the [FileAction](FileAction.md#numLogicalRecords) abstraction.

??? note "Lazy Value"
    `numLogicalRecords` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`numLogicalRecords` is [parsedStatsFields](#parsedStatsFields).

---

`numLogicalRecords` is used when:

* `DeleteCommandMetrics` is requested to [getDeletedRowsFromAddFilesAndUpdateMetrics](commands/delete/DeleteCommandMetrics.md#getDeletedRowsFromAddFilesAndUpdateMetrics)
* `MergeIntoCommand` is requested to [writeInsertsOnlyWhenNoMatchedClauses](commands/merge/MergeIntoCommand.md#writeInsertsOnlyWhenNoMatchedClauses)
* `TransactionalWrite` is requested to [writeFiles](TransactionalWrite.md#writeFiles)
* `WriteIntoDelta` is requested to [registerReplaceWhereMetrics](commands/WriteIntoDelta.md#registerReplaceWhereMetrics)
