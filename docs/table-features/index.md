---
hide:
  - toc
---

# Table Features

**Table Features** is based on [TableFeature](TableFeature.md) abstraction.

A table feature can be a [writer](WriterFeature.md), a reader or a [reader-writer](ReaderWriterFeature.md) feature.

There are [protocol- and metadata-enabled table features](../Protocol.md#extractAutomaticallyEnabledFeatures).

Table features can be enabled using the following:

* Selectively, per delta table, using table properties with [delta.feature](TableFeatureProtocolUtils.md#FEATURE_PROP_PREFIX) prefix (with the only supported value [supported](TableFeatureProtocolUtils.md#FEATURE_PROP_SUPPORTED)).
* Globally, for all the delta tables in a `SparkSession`, using configuration properties with [spark.databricks.delta.properties.defaults.feature](TableFeatureProtocolUtils.md#DEFAULT_FEATURE_PROP_PREFIX) prefix.

A table feature can have dependencies ([required features](TableFeature.md#requiredFeatures)) that have to be enabled in order for the feature to be enabled.

Table features can be examined using [DESCRIBE DETAIL](../commands/describe-detail/index.md).

Table features can be enabled on delta tables using `TBLPROPERTIES` clause of [CREATE TABLE](../commands/create-table/index.md) or [ALTER TABLE SET TBLPROPERTIES](../commands/alter/AlterTableSetPropertiesDeltaCommand.md) commands (new or existing one, respectively).

=== "SQL"

    ```sql
    CREATE TABLE tbl(a int)
    USING delta
    TBLPROPERTIES (
      'delta.enableRowTracking' = 'true'
    )
    ```

=== "Scala"

    ```scala
    (spark.range(1)
      .writeTo("uc_delta")
      .using("delta")
      .tableProperty("delta.feature.catalogManaged", "supported")
      .create()
    )
    ```

## Supported Table Features

[TableFeature](TableFeature.md#allSupportedFeaturesMap) keeps track of all the supported table features, featuring:

* [AppendOnlyTableFeature](../append-only-tables/AppendOnlyTableFeature.md)
* [ChangeDataFeedTableFeature](../change-data-feed/ChangeDataFeedTableFeature.md)
* [ClusteringTableFeature](../liquid-clustering/ClusteringTableFeature.md)
* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md)
* [DomainMetadataTableFeature](DomainMetadataTableFeature.md)
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md)

## Legacy Table Features

[Legacy table features](TableFeature.md#isLegacyFeature) are [auto-update capable](FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables).

## Auto-Update Capable Table Features

Table features can be [auto-update capable](FeatureAutomaticallyEnabledByMetadata.md#automaticallyUpdateProtocolOfExistingTables).

## Learn More

* [Introducing Delta Lake Table Features]({{ delta.blog }}/2023-07-27-delta-lake-table-features/)
