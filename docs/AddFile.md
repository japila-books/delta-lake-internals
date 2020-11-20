# AddFile

`AddFile` is a [FileAction](FileAction.md) that represents an action of adding a [file](#path) to a [delta table](DeltaLog.md).

## Creating Instance

`AddFile` takes the following to be created:

* <span id="path"> Path
* <span id="partitionValues"> Partition values (`Map[String, String]`)
* <span id="size"> Size (in bytes)
* <span id="modificationTime"> Modification time
* <span id="dataChange"> `dataChange` flag
* <span id="stats"> Stats (default: `null`)
* <span id="tags"> Tags (`Map[String, String]`) (default: `null`)

`AddFile` is created when:

* [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) is executed (for [every data file to import](commands/ConvertToDeltaCommand.md#createAddFile))

* `DelayedCommitProtocol` is requested to [commit a task (after successful write)](DelayedCommitProtocol.md#commitTask) (for [optimistic transactional writers](TransactionalWrite.md))

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

`remove` simply [creates a RemoveFile](#removeWithTimestamp) for the [path](#path) (with the current time and `dataChange` flag enabled).

`remove` is used when:

* [MergeIntoCommand](commands/MergeIntoCommand.md) is executed

* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write) (with `Overwrite` mode)

* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch) (for `Complete` output mode)

## <span id="removeWithTimestamp"> Converting to RemoveFile

```scala
removeWithTimestamp(
  timestamp: Long = System.currentTimeMillis(),
  dataChange: Boolean = true): RemoveFile
```

`remove` creates a new [RemoveFile](RemoveFile.md) for the [path](#path) with the given `timestamp` and `dataChange` flag.

`removeWithTimestamp` is used when:

* `AddFile` is requested to [create a RemoveFile action with the defaults](#remove)
* [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md), [DeleteCommand](commands/DeleteCommand.md) and [UpdateCommand](commands/UpdateCommand.md) commands are executed
* `DeltaCommand` is requested to [removeFilesFromPaths](commands/DeltaCommand.md#removeFilesFromPaths)
