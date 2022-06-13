# Column Mapping

**Column Mapping** allows mapping physical columns names to their logical ones for reading and writing parquet data files.

Column Mapping is enabled for a delta table using [delta.columnMapping.mode](../DeltaConfigs.md#COLUMN_MAPPING_MODE) table property.

Column Mapping turns [ALTER TABLE RENAME COLUMN](../commands/alter/AlterTableChangeColumnDeltaCommand.md) and [ALTER TABLE CHANGE COLUMN](../commands/alter/AlterTableChangeColumnDeltaCommand.md) commands into logical changes at metadata level (leading to no changes to the physical column names in parquet files and a mere [transactional metadata update](../commands/alter/AlterTableChangeColumnDeltaCommand.md#run-update) in a transaction log).

Column Mapping uses the metadata of a `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField)) to  store the logical column name under the `delta.columnMapping.physicalName` metadata key.

Column Mapping is available as of Delta Lake 1.2.0.

## Demo

[Demo: Column Mapping](../demo/column-mapping.md)

## Learn More

1. [Delta Lake 1.2 - More Speed, Efficiency and Extensibility Than Ever](https://delta.io/blog/2022-05-05-delta-lake-1-2-released/)
