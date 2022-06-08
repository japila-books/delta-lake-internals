# Column Mapping

**Column Mapping** allows mapping columns names to their logical ones for reading and writing parquet data files.

Column Mapping uses the metadata of a `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField)) to  store logical column names (with no changes to their physical names).

Column Mapping is enabled for a delta table using [delta.columnMapping.mode](../DeltaConfigs.md#COLUMN_MAPPING_MODE) table property.

Data Skipping is available as of Delta Lake 1.2.0.

## Demo

[Demo: Column Mapping](../demo/column-mapping.md)

## Learn More

1. [Delta Lake 1.2 - More Speed, Efficiency and Extensibility Than Ever](https://delta.io/blog/2022-05-05-delta-lake-1-2-released/)
