# OPTIMIZE Command

From [Optimize performance with file management](https://docs.databricks.com/delta/optimizations/file-mgmt.html):

> To improve query speed, Delta Lake on Databricks supports the ability to optimize the layout of data stored in cloud storage. Delta Lake on Databricks supports two layout algorithms: [bin-packing](#bin-packing) and [Z-Ordering](#z-ordering).

As of Delta Lake 2.0.0, the above quote applies to the open source version, too.

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

## Learning More

There seems so many articles and academic papers about [space filling curve based clustering algorithms](google.com/search?q=space+filling+curve+based+clustering+algorithms). I'm hoping that one day I'll have read enough to develop my own intuition about z-order multi-dimensional optimization. If you know good articles about this space (_pun intended_), let me know. I'll collect them here for future reference (for others to learn along).

Thank you! 🙏

1. [Z-order curve](https://en.wikipedia.org/wiki/Z-order_curve)
