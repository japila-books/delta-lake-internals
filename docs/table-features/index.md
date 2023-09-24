---
hide:
  - toc
---

# Table Features

**Table Features** are based on [TableFeature](TableFeature.md) abstraction.

A table feature is a writer feature.

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

* `AppendOnlyTableFeature`
* `ChangeDataFeedTableFeature`
* `CheckConstraintsTableFeature`
* `DomainMetadataTableFeature`
* `GeneratedColumnsTableFeature`
* `InvariantsTableFeature`
* `ColumnMappingTableFeature`
* `TimestampNTZTableFeature`
* `IcebergCompatV1TableFeature`
* [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md)

## Learn More

* [Introducing Delta Lake Table Features](https://delta.io/blog/2023-07-27-delta-lake-table-features/)
