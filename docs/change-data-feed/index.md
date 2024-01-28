# Change Data Feed

**Change Data Feed (CDF)** (fka _Change Data Capture_ or _CDC_ in short) is a [table feature](ChangeDataFeedTableFeature.md) in Delta Lake that allows tracking row-level changes between versions of a delta table.

Change Data Feed can be enabled on a delta table using [delta.enableChangeDataFeed](#delta.enableChangeDataFeed) table property.

Change Data Feed can be enabled globally (on all new delta tables) using [spark.databricks.delta.properties.defaults.enableChangeDataFeed](../table-properties/DeltaConfigs.md#spark.databricks.delta.properties.defaults) system-wide configuration property.

CDF data changes are written out (by [DelayedCommitProtocol](../DelayedCommitProtocol.md)) to [_change_data](#_change_data) directory as `cdc-`-prefixed parquet-encoded change data files.

With [CDF-Aware Table Scan (CDF Read)](CDCReaderImpl.md#isCDCRead) (based on [readChangeFeed](../spark-connector/options.md#readChangeFeed) read option), [loading a delta table](../spark-connector/DeltaDataSource.md#RelationProvider-createRelation) gives data changes (not the data of a particular version of the delta table).

[CDCReader](CDCReader.md) is used to [build a DataFrame of the row-level changes](CDCReaderImpl.md#changesToDF) for all the possible structured query types (described using `DataFrame` API):

* [Batch queries](DeltaCDFRelation.md#buildScan) (Spark SQL)
* [Streaming queries](../spark-connector/DeltaSourceBase.md#createDataFrameBetweenOffsets) (Spark Structured Streaming)

Change Data Feed was released in Delta Lake 2.0.0 (that was tracked under [Support for Change Data Feed in Delta Lake]({{ delta.issues }}/1105)).

## delta.enableChangeDataFeed { #delta.enableChangeDataFeed }

Change Data Feed can be enabled on a delta table using [delta.enableChangeDataFeed](../table-properties/DeltaConfigs.md#enableChangeDataFeed) table property (through [ChangeDataFeedTableFeature](ChangeDataFeedTableFeature.md)).

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

Change Data Feed is enabled in batch and streaming queries using [readChangeFeed](../spark-connector/DeltaDataSource.md#readChangeFeed) option.

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

`readChangeFeed` is used alongside the other CDF options:

* [startingVersion](../spark-connector/DeltaDataSource.md#CDC_START_VERSION_KEY)
* [startingTimestamp](../spark-connector/DeltaDataSource.md#CDC_START_TIMESTAMP_KEY)
* [endingVersion](../spark-connector/DeltaDataSource.md#CDC_END_VERSION_KEY)
* [endingTimestamp](../spark-connector/DeltaDataSource.md#CDC_END_TIMESTAMP_KEY)

## CDF-Aware Read Schema

Change Data Feed uses the following metadata columns for [CDF-aware scans](CDCReaderImpl.md#cdcReadSchema) (beside the data schema):

Column Name | Data Type | Description
------------|-----------|------------
 [_change_type](CDCReader.md#CDC_TYPE_COLUMN_NAME) | `StringType` | The type of a data change
 [_commit_version](CDCReader.md#CDC_COMMIT_VERSION) | `LongType` |
 [_commit_timestamp](CDCReader.md#CDC_COMMIT_TIMESTAMP) | `TimestampType` |

![CDF-Aware Read Schema](../images/cdf-metadata-columns.png)

## Change Data Directory { #_change_data }

[_change_data](CDCReader.md#_change_data) is the name of the directory (under the top-level data directory) for change data files.

This directory may contain partition directories (i.e. `_change_data/part1=value1/...`) with changes to data with partition values.

`_change_data` is a [hidden directory](../DeltaTableUtils.md#isHiddenDirectory) and must not be considered in delta-related file operations (e.g., [VACUUM](../commands/vacuum/index.md) and `FSCK`).

## Change Type Column { #_change_type }

Change data files contain the additional [_change_type](CDCReader.md#_change_type) column that identifies the type of change event (beside the data columns).

 _change_type | Command | Description
--------------|---------|------------
 `delete` | [DELETE](../commands/delete/index.md) | The value has been deleted
 `insert` | |
 `update_postimage` | [UPDATE](../commands/update/index.md) | The value after [UPDATE](../commands/update/index.md)
 `update_preimage` | [UPDATE](../commands/update/index.md) | The value before [UPDATE](../commands/update/index.md)

When writing out changes to a delta table, `_change_type` column is used to partition rows with change events and write them out to [_change_data](#_change_data) directory (as [AddCDCFile](../AddCDCFile.md)s).

## Column Mapping Not Supported

Change data feed reads are currently not supported on tables with [column mapping](../column-mapping/index.md) enabled (and a [DeltaUnsupportedOperationException is thrown](CDCReaderImpl.md#changesToDF)).

## CDF Table-Valued Functions

[CDF Table-Valued Functions](../table-valued-functions/index.md) are provided to read the table changes of delta tables.

## File Indices

!!! note "FIXME What's the purpose of these indices?!"

* [CdcAddFileIndex](CdcAddFileIndex.md)
* [TahoeChangeFileIndex](TahoeChangeFileIndex.md)
* [TahoeRemoveFileIndex](TahoeRemoveFileIndex.md)

## Change Data Feed in Streaming and Batch Queries

`DataFrame` API-based Spark modules ([Spark SQL]({{ book.spark_sql }}) and [Spark Structured Streaming]({{ book.structured_streaming }}))...

!!! note "FIXME"
    Describe the following (move parts from the intro):

    1. The entry points (abstractions) of each query type (batch and streaming) for loading CDF changes (table scans)
    1. Writing data out

## Demo

[Change Data Feed](../demo/change-data-feed.md)

## Learn More

1. [Delta Lake guide]({{ delta.databricks }}/delta-change-data-feed.html)
