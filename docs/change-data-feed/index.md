# Change Data Feed

**Change Data Feed (CDF)** (aka _Change Data Capture_ or _CDC_ in short) is a feature of Delta Lake that allows tracking row-level changes between versions of a delta table.

With so-called [CDC-Aware Table Scan (CDC Read)](CDCReader.md#isCDCRead), [loading a delta table](../DeltaDataSource.md#RelationProvider-createRelation) gives data changes (not the data of a particular version of the delta table).

As they put it (in [this comment](https://github.com/delta-io/delta/commit/d90f90b6656648e170835f92152b69f77346dfcf)), [CDCReader](CDCReader.md) is the key class used for Change Data Feed (with [DelayedCommitProtocol](../DelayedCommitProtocol.md) to handle it properly).

Change Data Feed is a new feature in Delta Lake 2.0.0 (that was tracked under [Support for Change Data Feed in Delta Lake #1105]({{ delta.issues }}/1105)).

## Enabling CDC for a Delta table

Enable CDC for a table using [delta.enableChangeDataFeed](#delta.enableChangeDataFeed) table property.

```sql
ALTER TABLE myDeltaTable
SET TBLPROPERTIES (delta.enableChangeDataFeed = true)
```

```sql
CREATE TABLE student (id INT, name STRING, age INT)
USING DELTA
TBLPROPERTIES (delta.enableChangeDataFeed = true)
```

Additionally, this property can be set for all new tables by default.

```sql
SET spark.databricks.delta.properties.defaults.enableChangeDataFeed = true;
```

## <span id="options"><span id="readChangeFeed"> Options

Change Data Feed is enabled in batch and streaming queries using [readChangeFeed](../DeltaDataSource.md#readChangeFeed) option.

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

* [startingVersion](../DeltaDataSource.md#CDC_START_VERSION_KEY)
* [startingTimestamp](../DeltaDataSource.md#CDC_START_TIMESTAMP_KEY)
* [endingVersion](../DeltaDataSource.md#CDC_END_VERSION_KEY)
* [endingTimestamp](../DeltaDataSource.md#CDC_END_TIMESTAMP_KEY)

## Minimum Required Protocol

Change Data Feed requires the [minimum protocol version to be 0 for readers and 4 for writers](../Protocol.md#requiredMinimumProtocol).

## Column Mapping Not Supported

Change data feed reads are currently not supported on tables with [column mapping](../column-mapping/index.md) enabled (and a [DeltaUnsupportedOperationException is thrown](CDCReader.md#changesToDF)).

## Learn More

1. [Delta Lake guide](https://docs.databricks.com/delta/delta-change-data-feed.html)
