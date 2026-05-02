# RemoveFile

`RemoveFile` is a [FileAction](FileAction.md) that represents an action of removing (_deleting_) a [file](#path) from a delta table.

## Creating Instance

`RemoveFile` takes the following to be created:

* <span id="path"> Path
* <span id="deletionTimestamp"> Deletion Timestamp (optional)
* [dataChange flag](#dataChange)
* <span id="extendedFileMetadata"> `extendedFileMetadata` flag (default: `false`)
* <span id="partitionValues"> Partition values (default: `null`)
* <span id="size"> Size (in bytes) (default: `0`)
* <span id="tags"> Tags (`Map[String, String]`) (default: `null`)
* <span id="deletionVector"> `DeletionVectorDescriptor`
* <span id="baseRowId"> Base Row ID
* <span id="defaultRowCommitVersion"> Default Row Commit Version

`RemoveFile` is created when:

* `AddFile` action is requested to [removeWithTimestamp](AddFile.md#removeWithTimestamp)

### dataChange { #dataChange }

??? note "FileAction"

    ```scala
    dataChange: Boolean
    ```

    `dataChange` is part of the [FileAction](FileAction.md#dataChange) abstraction.

!!! note "dataChange and OPTIMIZE command"
    `dataChange` flag is only `false` (disabled) for [OPTIMIZE](commands/optimize/index.md) command.

`RemoveFile` is given `dataChange` flag when [created](#creating-instance).

`dataChange` is enabled (`true`) by default.

`dataChange` can be specified when:

* `AddFile` is requested to [removeWithTimestamp](AddFile.md#removeWithTimestamp)
