# Change Data Feed

**Change Data Feed (CDF)** (fka _Change Data Capture_ or _CDC_ in short) is a [table feature](ChangeDataFeedTableFeature.md) in Delta Lake that allows tracking row-level changes between versions of a delta table.

Change Data Feed can be enabled on a delta table using [delta.enableChangeDataFeed](#delta.enableChangeDataFeed) table property.

With so-called [CDC-Aware Table Scan (CDC Read)](CDCReader.md#isCDCRead), [loading a delta table](../delta/DeltaDataSource.md#RelationProvider-createRelation) gives data changes (not the data of a particular version of the delta table).

As they put it (in [this comment](https://github.com/delta-io/delta/commit/d90f90b6656648e170835f92152b69f77346dfcf)), [CDCReader](CDCReader.md) is the key class used for Change Data Feed (with [DelayedCommitProtocol](../DelayedCommitProtocol.md) to handle it properly).

Non-CDC data is written out to the base directory of a delta table, while CDC data is written out to the [_change_data](CDCReader.md#CDC_LOCATION) special folder.

The heart of Change Data Feed table feature is [CDCReaderImpl](CDCReaderImpl.md#changesToDF) with the following entry points based on query type:

* [Batch queries](DeltaCDFRelation.md#buildScan)
* [Streaming queries](../delta/DeltaSourceBase.md#createDataFrameBetweenOffsets)

!!! note "New in Delta Lake 2.0.0"
    Change Data Feed was released in Delta Lake 2.0.0 (that was tracked under [Support for Change Data Feed in Delta Lake]({{ delta.issues }}/1105)).

## delta.enableChangeDataFeed { #delta.enableChangeDataFeed }

Change Data Feed can be enabled on a delta table using [delta.enableChangeDataFeed](../DeltaConfigs.md#enableChangeDataFeed) table property (through [ChangeDataFeedTableFeature](ChangeDataFeedTableFeature.md) that is a [FeatureAutomaticallyEnabledByMetadata](../table-features/FeatureAutomaticallyEnabledByMetadata.md) and uses this table property).

```sql
ALTER TABLE delta_demo
SET TBLPROPERTIES (delta.enableChangeDataFeed = true)
```

```sql
CREATE TABLE delta_demo (id INT, name STRING, age INT)
USING delta
TBLPROPERTIES (delta.enableChangeDataFeed = true)
```

Additionally, this property can be set for all new tables by default.

```sql
SET spark.databricks.delta.properties.defaults.enableChangeDataFeed = true;
```

## <span id="readChangeFeed"> Options { #options }

Change Data Feed is enabled in batch and streaming queries using [readChangeFeed](../delta/DeltaDataSource.md#readChangeFeed) option.

=== "Batch Query"

    ```scala
    spark
      .read
      .format("delta")
      .option("readChangeFeed", "true")
      .option("startingVersion", startingVersion)
      .option("endingVersion", endingVersion)
      .table("source")
    ```

=== "Streaming Query"

    ```scala
    spark
      .readStream
      .format("delta")
      .option("readChangeFeed", "true")
      .option("startingVersion", startingVersion)
      .table("source")
    ```

`readChangeFeed` is used alongside the other CDC options:

* [startingVersion](../delta/DeltaDataSource.md#CDC_START_VERSION_KEY)
* [startingTimestamp](../delta/DeltaDataSource.md#CDC_START_TIMESTAMP_KEY)
* [endingVersion](../delta/DeltaDataSource.md#CDC_END_VERSION_KEY)
* [endingTimestamp](../delta/DeltaDataSource.md#CDC_END_TIMESTAMP_KEY)

## _change_type Column { #_change_type }

[_change_type](CDCReader.md#_change_type) column represents a change type.

 _change_type | Command
--------------|---------
 `delete` | [DeleteCommand](../commands/delete/DeleteCommand.md#performDelete)
 FIXME |

## Protocol

Change Data Feed requires the [minimum protocol version to be 0 for readers and 4 for writers](../Protocol.md#requiredMinimumProtocol).

## Column Mapping Not Supported

Change data feed reads are currently not supported on tables with [column mapping](../column-mapping/index.md) enabled (and a [DeltaUnsupportedOperationException is thrown](CDCReader.md#changesToDF)).

## Demo

[Change Data Feed](../demo/change-data-feed.md)

## Learn More

1. [Delta Lake guide](https://docs.databricks.com/delta/delta-change-data-feed.html)
