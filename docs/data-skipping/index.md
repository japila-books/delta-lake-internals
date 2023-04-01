# Data Skipping

**Data Skipping** is an optimization of queries with filter clauses that uses data skipping column statistics to find the set of parquet data files that need to be queried (and prune away files that do not match the filters and contain no rows the query cares about). That means that no filters effectively skips data skipping.

Data Skipping is enabled using [spark.databricks.delta.stats.skipping](../configuration-properties/DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property.

## LIMIT Pushdown

[LIMIT Pushdown](../limit-pushdown/index.md)

## Internals

Data Skipping uses [DataSkippingReaderBase](DataSkippingReaderBase.md) as the main abstraction for scanning parquet data files (with [getDataSkippedFiles](DataSkippingReaderBase.md#getDataSkippedFiles) being the crucial part).

## Demo

[Data Skipping](../demo/data-skipping.md)

## Learn More

1. [Delta Lake 1.2 - More Speed, Efficiency and Extensibility Than Ever](https://delta.io/blog/2022-05-05-delta-lake-1-2-released/)
