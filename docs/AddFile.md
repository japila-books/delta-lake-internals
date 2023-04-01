# AddFile

`AddFile` is a [FileAction](FileAction.md) that represents an action of adding a [file](#path) to a delta table.

## Creating Instance

`AddFile` takes the following to be created:

* <span id="path"> Path
* <span id="partitionValues"> Partition values (`Map[String, String]`)
* <span id="size"> Size (in bytes)
* <span id="modificationTime"> Modification time
* <span id="dataChange"> `dataChange` flag
* [File Statistics](#stats)
* <span id="tags"> Tags (`Map[String, String]`) (default: `null`)

`AddFile` is created when:

* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed (for [every data file to import](commands/convert/ConvertToDeltaCommand.md#createAddFile))

* `DelayedCommitProtocol` is requested to [commit a task (after successful write)](DelayedCommitProtocol.md#commitTask) (for [optimistic transactional writers](TransactionalWrite.md))

### <span id="stats"> File Statistics

`AddFile` can be given a JSON-encoded file statistics when [created](#creating-instance).

The statistics are undefined (`null`) by default.

The statistics can be defined when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles) (and [spark.databricks.delta.stats.collect](configuration-properties/DeltaSQLConf.md#DELTA_COLLECT_STATS) configuration property is enabled)
* `StatisticsCollection` utility is used to [recompute statistics for a delta table](StatisticsCollection.md#recompute) (that _seems_ unused though)

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
* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch) (with `Complete` output mode)

## <span id="removeWithTimestamp"> Converting to RemoveFile

```scala
removeWithTimestamp(
  timestamp: Long = System.currentTimeMillis(),
  dataChange: Boolean = true): RemoveFile
```

`remove` creates a new [RemoveFile](RemoveFile.md) action for the [path](#path) with the given `timestamp` and `dataChange` flag.

`removeWithTimestamp` is used when:

* `AddFile` is requested to [create a RemoveFile action with the defaults](#remove)
* [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md), [DeleteCommand](commands/delete/DeleteCommand.md) and [UpdateCommand](commands/update/UpdateCommand.md) commands are executed
* `DeltaCommand` is requested to [removeFilesFromPaths](commands/DeltaCommand.md#removeFilesFromPaths)

## <span id="tag"> tag

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
