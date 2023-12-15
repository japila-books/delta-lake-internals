---
hide:
  - toc
---

# Table Features

**Table Features** is based on [TableFeature](TableFeature.md) abstraction.

A table feature can be a [writer](WriterFeature.md), a reader or a [reader-writer](ReaderWriterFeature.md) feature.

There are [protocol- and metadata-enabled table features](../Protocol.md#extractAutomaticallyEnabledFeatures).

A table feature can have dependencies ([required features](TableFeature.md#requiredFeatures)) that have to be enabled in order for the feature to be enabled.

Table features can be examined using [DESCRIBE DETAIL](../commands/describe-detail/index.md).

Table features can be enabled on a delta table using `TBLPROPERTIES`.

```sql
CREATE TABLE tbl(a int)
USING delta
TBLPROPERTIES (
  'delta.enableRowTracking' = 'true'
)
```

## Supported Table Features

[TableFeature](TableFeature.md#allSupportedFeaturesMap) tracks all the supported table features:

* [AppendOnlyTableFeature](../append-only-tables/AppendOnlyTableFeature.md)
* [ChangeDataFeedTableFeature](../change-data-feed/ChangeDataFeedTableFeature.md)
* `CheckConstraintsTableFeature`
* `ColumnMappingTableFeature`
* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md)
* `DomainMetadataTableFeature`
* `GeneratedColumnsTableFeature`
* `IcebergCompatV1TableFeature`
* `InvariantsTableFeature`
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md)
* `TimestampNTZTableFeature`

## Legacy Table Features

[Legacy table features](TableFeature.md#isLegacyFeature) are [auto-update capable](FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables).

## Auto-Update Capable Table Features

Table features can be [auto-update capable](FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables).

## Learn More

* [Introducing Delta Lake Table Features](https://delta.io/blog/2023-07-27-delta-lake-table-features/)
