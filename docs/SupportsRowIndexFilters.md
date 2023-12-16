# SupportsRowIndexFilters

`SupportsRowIndexFilters` is an [abstraction](#contract) of [file indices](#implementations) that can support [row index filters](#rowIndexFilters).

!!! note "Appears Change Data Feed Only"
    The only implementation of `SupportsRowIndexFilters` is [TahoeFileIndex](TahoeFileIndex.md) yet [rowIndexFilters](#rowIndexFilters) is only used to create [CdcAddFileIndex](change-data-feed/CdcAddFileIndex.md#rowIndexFilters) and [TahoeRemoveFileIndex](change-data-feed/TahoeRemoveFileIndex.md#rowIndexFilters) for [Change Data Feed](change-data-feed/index.md) for [CDCReaderImpl](change-data-feed/CDCReaderImpl.md#processDeletionVectorActions).

## Contract

### Row Index Filters { #rowIndexFilters }

```scala
rowIndexFilters: Option[Map[String, RowIndexFilterType]] = None
```

A mapping of `URI`-encoded file paths to a row index filter type.

Used when:

* `CDCReaderImpl` is requested to [processDeletionVectorActions](change-data-feed/CDCReaderImpl.md#processDeletionVectorActions) (to create a [CdcAddFileIndex](change-data-feed/CdcAddFileIndex.md#rowIndexFilters) and a [TahoeRemoveFileIndex](change-data-feed/TahoeRemoveFileIndex.md#rowIndexFilters))

## Implementations

* [TahoeFileIndex](TahoeFileIndex.md)
