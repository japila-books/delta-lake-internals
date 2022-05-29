# DeltaFileFormat

`DeltaFileFormat` is an [abstraction](#contract) of [format metadata](#implementations) that [specify the file format of a delta table](#fileFormat).

## Contract

### <span id="fileFormat"> FileFormat

```scala
fileFormat: FileFormat
```

`FileFormat` ([Spark SQL]({{ book.spark_sql }}/datasources/FileFormat)) of this delta table

Default: [DeltaParquetFileFormat](DeltaParquetFileFormat.md) (with the [columnMappingMode](Metadata.md#columnMappingMode) and the [schema](Metadata.md#schema) of the given [Metadata](Metadata.md))

Used when:

* `DeltaLog` is requested for a [relation](DeltaLog.md#createRelation) (in batch queries) and a [DataFrame](DeltaLog.md#createDataFrame)
* `DeltaCommand` is requested for a [relation](commands/DeltaCommand.md#buildBaseRelation)
* `MergeIntoCommand` is requested to [buildTargetPlanWithFiles](commands/merge/MergeIntoCommand.md#buildTargetPlanWithFiles)
* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

Current [Metadata](Metadata.md)

Used when:

* `DeltaFileFormat` is requested for the [FileFormat](#fileFormat)

### <span id="spark"> SparkSession

```scala
spark: SparkSession
```

Current `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

## Implementations

* [DeltaLog](DeltaLog.md)
