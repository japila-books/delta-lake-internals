# OptimizeMetadataOnlyDeltaQuery

`OptimizeMetadataOnlyDeltaQuery` is an [abstraction](#contract) of [metadata-only PrepareDeltaScans](#implementations).

## Contract

### <span id="getDeltaScanGenerator"> getDeltaScanGenerator

```scala
getDeltaScanGenerator(
  index: TahoeLogFileIndex): DeltaScanGenerator
```

[DeltaScanGenerator](DeltaScanGenerator.md) for the given [TahoeLogFileIndex](../TahoeLogFileIndex.md)

See:

* [PrepareDeltaScanBase](PrepareDeltaScanBase.md#getDeltaScanGenerator)

Used when:

* `CountStarDeltaTable` is requested to [extractGlobalCount](CountStarDeltaTable.md#extractGlobalCount)

## Implementations

* [PrepareDeltaScanBase](PrepareDeltaScanBase.md)
