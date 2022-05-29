# Data Skipping

**Data Skipping** is an optimization of queries with filter clauses that uses data skipping column statistics to prune away files that contain no rows the query cares about (and thus skips scanning parquet data files that do not match the filters). That means that no filters effectively skips data skipping.

Data Skipping is enabled using [spark.databricks.delta.stats.skipping](../DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property.

Data Skipping is available as of Delta Lake 1.2.0.

## Limitations

Data Skipping supports _flat filters_ only (i.e., filters with no `SubqueryExpression`s ([Spark SQL]({{ book.spark_sql }}/expressions/SubqueryExpression))).

## Internals

Data Skipping uses [DataSkippingReaderBase](DataSkippingReaderBase.md) as the main abstraction for scanning parquet data files (with [getDataSkippedFiles](DataSkippingReaderBase.md#getDataSkippedFiles) being the crucial part).

## Demo

[Data Skipping](../demo/data-skipping.md)

## Learn More

1. [Delta Lake 1.2 - More Speed, Efficiency and Extensibility Than Ever](https://delta.io/blog/2022-05-05-delta-lake-1-2-released/)
