# DeltaFileFormat

`DeltaFileFormat` is an [abstraction](#contract) of [format metadata](#implementations) that [specify the file format of a delta table](#fileFormat).

## Contract

### SparkSession { #spark }

```scala
spark: SparkSession
```

Current `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

See:

* [DeltaLog](DeltaLog.md#spark)

## Implementations

* [DeltaLog](DeltaLog.md)

## FileFormat { #fileFormat }

```scala
fileFormat(
  protocol: Protocol,
  metadata: Metadata): FileFormat
```

`fileFormat` creates a [DeltaParquetFileFormat](DeltaParquetFileFormat.md) for the given [Protocol](Protocol.md) and [Metadata](Metadata.md).

---

Used when:

* `DeltaLog` is requested to [build a HadoopFsRelation](DeltaLog.md#buildHadoopFsRelationWithFileIndex)
* `DeltaCommand` is requested to [build a HadoopFsRelation](commands/DeltaCommand.md#buildBaseRelation)
* `MergeIntoCommandBase` is requested to [buildTargetPlanWithIndex](commands/merge/MergeIntoCommandBase.md#buildTargetPlanWithIndex)
* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)
