# OPTIMIZE Command

From [Optimize performance with file management](https://docs.databricks.com/delta/optimizations/file-mgmt.html):

> To improve query speed, Delta Lake on Databricks supports the ability to optimize the layout of data stored in cloud storage. Delta Lake on Databricks supports two layout algorithms: [bin-packing](#bin-packing) and [Z-Ordering](#z-ordering).

As of Delta Lake 2.0.0rc1, the above quote applies to the open source version, too.

`OPTIMIZE` command can be executed using the following:

* [OPTIMIZE](OptimizeTableCommand.md) SQL command
* [DeltaTable.optimize](../../DeltaTable.md#optimize) operator

## bin-packing

In `bin-packing` (aka. _file compaction_) mode, `OPTIMIZE` command compacts files together (that are smaller than [spark.databricks.delta.optimize.minFileSize](../../configuration-properties.md#spark.databricks.delta.optimize.minFileSize) to files of [spark.databricks.delta.optimize.maxFileSize](../../configuration-properties.md#spark.databricks.delta.optimize.maxFileSize) size).

## Z-Ordering

`OPTIMIZE` can specify `ZORDER BY` columns for [multi-dimensional clustering](MultiDimClustering.md#cluster).

## optimize.maxThreads

`OPTIMIZE` command uses [spark.databricks.delta.optimize.maxThreads](../../configuration-properties.md#spark.databricks.delta.optimize.maxThreads) threads for compaction.

## Demo

[Demo: Optimize](../../demo/optimize.md)
