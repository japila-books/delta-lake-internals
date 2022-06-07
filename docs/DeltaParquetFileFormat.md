# DeltaParquetFileFormat

`DeltaParquetFileFormat` is a `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/datasources/parquet/ParquetFileFormat)) to support [no restrictions on columns names](#prepareSchema).

## Creating Instance

`DeltaParquetFileFormat` takes the following to be created:

* <span id="columnMappingMode"> [DeltaColumnMappingMode](column-mapping/DeltaColumnMappingMode.md)
* <span id="referenceSchema"> Reference schema ([StructType]({{ book.spark_sql }}/types/StructType))

`DeltaParquetFileFormat` is created when:

* `DeltaFileFormat` is requested for the [fileFormat](DeltaFileFormat.md#fileFormat)

## <span id="buildReaderWithPartitionValues"> Building Data Reader With Partition Values

```scala
buildReaderWithPartitionValues(
  sparkSession: SparkSession,
  dataSchema: StructType,
  partitionSchema: StructType,
  requiredSchema: StructType,
  filters: Seq[Filter],
  options: Map[String, String],
  hadoopConf: Configuration): PartitionedFile => Iterator[InternalRow]
```

`buildReaderWithPartitionValues` [prepares](#prepareSchema) the given schemas (e.g., `dataSchema`, `partitionSchema` and `requiredSchema`) before requesting the parent `ParquetFileFormat` to `buildReaderWithPartitionValues`.

`buildReaderWithPartitionValues` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/datasources/parquet/ParquetFileFormat#buildReaderWithPartitionValues)) abstraction.

### <span id="prepareSchema"> Preparing Schema

```scala
prepareSchema(
  inputSchema: StructType): StructType
```

`prepareSchema` [creates a physical schema](column-mapping/DeltaColumnMappingBase.md#createPhysicalSchema) (for the `inputSchema`, the [referenceSchema](#referenceSchema) and the [DeltaColumnMappingMode](#columnMappingMode)).

## <span id="supportFieldName"> supportFieldName

```scala
supportFieldName(
  name: String): Boolean
```

`supportFieldName` is enabled (`true`) when the [columnMappingMode](#columnMappingMode) is not `NoMapping` or requests the parent `ParquetFileFormat` to `supportFieldName`.

`supportFieldName` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/datasources/parquet/ParquetFileFormat#supportFieldName)) abstraction.
