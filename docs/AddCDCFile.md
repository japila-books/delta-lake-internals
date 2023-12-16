# AddCDCFile

`AddCDCFile` is a [FileAction](FileAction.md) for the change file with [Change Data Feed](change-data-feed/index.md) data of the version of a delta table.

`AddCDCFile` is [created](#creating-instance) when `DelayedCommitProtocol` is requested to [commit a task](DelayedCommitProtocol.md#commitTask).

CDF-aware readers are supposed to scan `AddCDCFile`s for the changes of a delta table.

## Creating Instance

`AddCDCFile` takes the following to be created:

* <span id="path"> Path
* <span id="partitionValues"> Partition values (`Map[String, String]`)
* <span id="size"> Size (in bytes)
* <span id="tags"> Tags (default: `null`)

`AddCDCFile` is created when:

* `DelayedCommitProtocol` is requested to [buildActionFromAddedFile](DelayedCommitProtocol.md#buildActionFromAddedFile)

## dataChange { #dataChange }

??? note "FileAction"

    ```scala
    dataChange: Boolean
    ```

    `dataChange` is part of the [FileAction](FileAction.md#dataChange) abstraction.

`dataChange` is always `false`.

## Converting to SingleAction { #wrap }

??? note "FileAction"

    ```scala
    wrap: Boolean
    ```

    `wrap` is part of the [FileAction](FileAction.md#wrap) abstraction.

`wrap` creates a new [SingleAction](SingleAction.md) with [cdc](SingleAction.md#cdc) property set to this `AddCDCFile`.
