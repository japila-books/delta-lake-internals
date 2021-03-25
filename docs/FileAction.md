# FileAction

`FileAction` is an [extension](#contract) of the [Action](Action.md) abstraction for [actions](#implementations) that can add or remove files.

## Contract

### <span id="path"> Path

```scala
path: String
```

### <span id="dataChange"> dataChange

```scala
dataChange: Boolean
```

`dataChange` is used when:

* `InMemoryLogReplay` is requested to [append](InMemoryLogReplay.md#append)
* FIXME

## Implementations

* [AddCDCFile](AddCDCFile.md)
* [AddFile](AddFile.md)
* [RemoveFile](RemoveFile.md)

??? note "Sealed Trait"
    `FileAction` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
