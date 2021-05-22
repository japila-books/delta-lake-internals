# DeltaFileFormat

`DeltaFileFormat` is an [abstraction](#contract) of [format metadata](#implementations) that [specify the file format of a delta table](#fileFormat).

## Contract

### <span id="fileFormat"> FileFormat

```scala
fileFormat: FileFormat
```

`FileFormat` ([Spark SQL]({{ book.spark_sql }}/datasources/FileFormat)) of a delta table

Default: `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/datasources/parquet/ParquetFileFormat))

Used when:

* `DeltaLog` is requested for a [relation](DeltaLog.md#createRelation) (in batch queries) and [DataFrame](DeltaLog.md#createDataFrame)
* `DeltaCommand` is requested for a [relation](commands/DeltaCommand.md#buildBaseRelation)
* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)

## Implementations

* [Snapshot](Snapshot.md)
