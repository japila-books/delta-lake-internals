# RowIndexFilter

`RowIndexFilter` is an [abstraction](#contract) of [row_index filters](#implementations).

## Contract (Subset)

### materializeIntoVector { #materializeIntoVector }

```java
void materializeIntoVector(
  long start,
  long end,
  WritableColumnVector batch)
```

See:

* [RowIndexMarkingFilters](RowIndexMarkingFilters.md#materializeIntoVector)

Used when:

* `DeltaParquetFileFormat` is requested to [iteratorWithAdditionalMetadataColumns](../DeltaParquetFileFormat.md#iteratorWithAdditionalMetadataColumns)

## Implementations

* `DropAllRowsFilter`
* `KeepAllRowsFilter`
* [RowIndexMarkingFilters](RowIndexMarkingFilters.md)
