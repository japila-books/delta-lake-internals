# AddCDCFile

`AddCDCFile` is a [FileAction](FileAction.md).

## Creating Instance

`AddCDCFile` takes the following to be created:

* <span id="path"> Path
* <span id="partitionValues"> Partition values (`Map[String, String]`)
* <span id="size"> Size (in bytes)
* <span id="tags"> Tags (default: `null`)

`AddCDCFile` does not seem to be created ever.

## <span id="dataChange"> dataChange

```scala
dataChange: Boolean
```

`dataChange` is part of the [FileAction](FileAction.md#dataChange) abstraction.

`dataChange` is always turned off (`false`).

## <span id="wrap"> Converting to SingleAction

```scala
wrap: SingleAction
```

`wrap` is part of the [Action](Action.md#wrap) abstraction.

`wrap` creates a new [SingleAction](SingleAction.md) with the `cdc` field set to this `AddCDCFile`.
