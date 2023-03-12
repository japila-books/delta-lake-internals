# UsesMetadataFields

`UsesMetadataFields` is an [abstraction](#contract) of [components](#implementations) that use metadata fields (from a delta table's transaction log).

## Contract

### <span id="MAX"><span id="maxValues"> maxValues

The largest (possibly truncated) value for a column

Used when:

* `DataSkippingReaderBase` is requested to [verifyStatsForFilter](DataSkippingReaderBase.md#verifyStatsForFilter) and [getStatsColumnOpt](DataSkippingReaderBase.md#getStatsColumnOpt)
* `ColumnPredicateBuilder` is requested to [equalTo](ColumnPredicateBuilder.md#equalTo), [notEqualTo](ColumnPredicateBuilder.md#notEqualTo), [greaterThan](ColumnPredicateBuilder.md#greaterThan), [greaterThanOrEqual](ColumnPredicateBuilder.md#greaterThanOrEqual)
* `DataFiltersBuilder` is requested to [constructDataFilters](DataFiltersBuilder.md#constructDataFilters)
* `StatisticsCollection` is requested to [statsCollector](../StatisticsCollection.md#statsCollector) and [statsSchema](../StatisticsCollection.md#statsSchema)

### <span id="MIN"><span id="minValues"> minValues

The smallest (possibly truncated) value for a column

### <span id="NULL_COUNT"><span id="nullCount"> nullCount

The number of null values present for a column

### <span id="NUM_RECORDS"><span id="numRecords"> numRecords

The total number of records in the file

## Implementations

* [ColumnPredicateBuilder](ColumnPredicateBuilder.md)
* [ReadsMetadataFields](ReadsMetadataFields.md)
* [StatisticsCollection](../StatisticsCollection.md)
