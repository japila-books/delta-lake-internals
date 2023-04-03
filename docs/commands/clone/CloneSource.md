# CloneSource

`CloneSource` is an [abstraction](#contract) of [source tables](#implementations) of the [CLONE](index.md) command.

## Contract (Subset)

### <span id="allFiles"> allFiles

```scala
allFiles: Dataset[AddFile]
```

All of the files in the source table (`Dataset` of [AddFile](../../AddFile.md)s)

See:

* [CloneDeltaSource](CloneDeltaSource.md#allFiles)
* [CloneParquetSource](CloneParquetSource.md#allFiles)

Used when:

* `CloneTableBase` is requested to [runInternal](CloneTableBase.md#runInternal)

## Implementations

* [CloneDeltaSource](CloneDeltaSource.md)
* [CloneParquetSource](CloneParquetSource.md)
