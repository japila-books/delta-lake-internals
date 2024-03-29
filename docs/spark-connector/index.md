---
title: Delta Connector
subtitle: Delta Lake on Spark SQL
---

# Delta Connector (Spark Connector for Delta Lake)

**Delta Connector** (_Spark Connector for Delta Lake_) is an extension of Spark SQL (based on [Connector API]({{ book.spark_sql }}/connector)) to support batch and streaming queries over delta tables.

```scala
val rawDeltaTable = spark
  .read
  .format("delta")
  .load("raw_delta_table")
```

```scala
myDeltaTable
  .write
  .format("delta")
  .save("bronze_delta_table")
```

## Options

Delta Connector defines [options](options.md) for [reading](DeltaReadOptions.md) and [writing](DeltaWriteOptionsImpl.md) delta tables.

The options can be defined using `option` method of the following:

* For batch queries, `DataFrameReader` ([Spark SQL]({{ book.spark_sql }}/DataFrameReader)) and `DataFrameWriter` ([Spark SQL]({{ book.spark_sql }}/DataFrameWriter))
* For streaming queries, `DataStreamReader` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamReader)) and `DataStreamWriter` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamWriter))
* SQL queries

The options are available at runtime as [DeltaOptions](DeltaOptions.md).
