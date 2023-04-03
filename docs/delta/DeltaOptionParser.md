# DeltaOptionParser

`DeltaOptionParser` is an [abstraction](#contract) of [options](#implementations) for reading from and writing to delta tables.

## Contract

### <span id="sqlConf"> SQLConf

```scala
sqlConf: SQLConf
```

Used when:

* `DeltaWriteOptionsImpl` is requested for [canMergeSchema](DeltaWriteOptionsImpl.md#canMergeSchema)

### <span id="options"> Options

```scala
options: CaseInsensitiveMap[String]
```

## Implementations

* [DeltaReadOptions](DeltaReadOptions.md)
* [DeltaWriteOptions](DeltaWriteOptions.md)
* [DeltaWriteOptionsImpl](DeltaWriteOptionsImpl.md)
