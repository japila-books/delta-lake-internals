---
hide:

- toc
---

# OPTIMIZE Command

`OPTIMIZE` command compacts files together (that are smaller than [spark.databricks.delta.optimize.minFileSize](../../configuration-properties.md#spark.databricks.delta.optimize.minFileSize) to files of [spark.databricks.delta.optimize.maxFileSize](../../configuration-properties.md#spark.databricks.delta.optimize.maxFileSize) size).

`OPTIMIZE` command uses [spark.databricks.delta.optimize.maxThreads](../../configuration-properties.md#spark.databricks.delta.optimize.maxThreads) threads for compaction.

`OPTIMIZE` command can be executed using [OPTIMIZE](OptimizeTableCommand.md) SQL command.

!!! note "Delta Lake Documentation"
    From [Optimize performance with file management](https://docs.databricks.com/delta/optimizations/file-mgmt.html):

    > To improve query speed, Delta Lake on Databricks supports the ability to optimize the layout of data stored in cloud storage. Delta Lake on Databricks supports two layout algorithms: bin-packing and Z-Ordering.

    **bin-packing** is exactly this `OPTIMIZE` command.

## Demo

[Demo: Optimize](../../demo/optimize.md)
