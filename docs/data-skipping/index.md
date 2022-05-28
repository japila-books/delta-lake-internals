---
hide:
  - toc
---

# Data Skipping

**Data Skipping** is a Delta Lake optimization to skip scanning parquet data files that do not match the filters in a query (and no filters effectively skips data skipping).

Data Skipping is enabled using [spark.databricks.delta.stats.skipping](../DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property.

Data Skipping is available as of Delta Lake 1.2.0.

## Demo

[Data Skipping](../demo/data-skipping.md)

## Learn More

1. [Delta Lake 1.2 - More Speed, Efficiency and Extensibility Than Ever](https://delta.io/blog/2022-05-05-delta-lake-1-2-released/)
