# Change Data Feed

**Change Data Feed (CDF)** (aka _Change Data Capture_) is a feature of Delta Lake that allows tracking row-level changes between versions of a delta table.

With so-called [CDC-Aware Table Scan (CDC Read)](CDCReader.md#isCDCRead), [loading a delta table](../DeltaDataSource.md#RelationProvider-createRelation) gives data changes (not the data of a particular version of the delta table).

Change Data Feed is a new feature in Delta Lake 2.0.0rc1.

## <span id="options"><span id="readChangeFeed"> Options

Change Data Feed is enabled in batch and streaming queries using [readChangeFeed](../DeltaDataSource.md#readChangeFeed) option.

`readChangeFeed` is used alongside the other CDC options:

* [startingVersion](../DeltaDataSource.md#CDC_START_VERSION_KEY)
* [startingTimestamp](../DeltaDataSource.md#CDC_START_TIMESTAMP_KEY)
* [endingVersion](../DeltaDataSource.md#CDC_END_VERSION_KEY)
* [endingTimestamp](../DeltaDataSource.md#CDC_END_TIMESTAMP_KEY)

## Learn More

1. [Delta Lake guide](https://docs.databricks.com/delta/delta-change-data-feed.html)
