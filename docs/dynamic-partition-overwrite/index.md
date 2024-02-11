---
hide:
  - toc
---

# Dynamic Partition Overwrite

**Dynamic Partition Overwrite** is a `DataFrameWriter` ([Spark SQL]({{ book.spark_sql }}/DataFrameWriter)) feature that allows to only overwrite partitions (of a partitioned delta table) that have data written into it.

Dynamic Partition Overwrite can be enabled system-wide using [spark.databricks.delta.dynamicPartitionOverwrite.enabled](../configuration-properties/index.md#dynamicPartitionOverwrite.enabled) configuration property.

??? note "DeltaIllegalArgumentException"
    It is a [DeltaIllegalArgumentException](../spark-connector/DeltaWriteOptionsImpl.md#isDynamicPartitionOverwriteMode) for [spark.databricks.delta.dynamicPartitionOverwrite.enabled](../configuration-properties/index.md#dynamicPartitionOverwrite.enabled) configuration property disabled yet the Dynamic Partition Overwrite Mode is [dynamic](../spark-connector/DeltaOptions.md#DYNAMIC).

!!! note "Conflicts with `replaceWhere`"
    Dynamic Partition Overwrite cannot be used with [replaceWhere](../spark-connector/options.md#replaceWhere) option as they both specify which data to overwrite.

## Partition Overwrite Mode

**Partition Overwrite Mode** can be one of the following values (case-insensitive):

* [dynamic](../spark-connector/DeltaOptions.md#DYNAMIC)
* [static](../spark-connector/DeltaOptions.md#STATIC)
