# DeltaParquetFileFormat

`DeltaParquetFileFormat` is a `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat)) to support [no restrictions on columns names](#prepareSchema).

## Creating Instance

`DeltaParquetFileFormat` takes the following to be created:

* <span id="protocol"> [Protocol](Protocol.md)
* <span id="metadata"> [Metadata](Metadata.md)
* [isSplittable Flag](#isSplittable)
* [disablePushDowns Flag](#disablePushDowns)
* <span id="tablePath"> Optional Table Path (default: `None` (unspecified))
* <span id="broadcastDvMap"> Optional Broadcast variable with `DeletionVectorDescriptorWithFilterType`s per `URI` (default: `None` (unspecified))
* <span id="broadcastHadoopConf"> Optional Broadcast variable with Hadoop Configuration (default: `None` (unspecified))

`DeltaParquetFileFormat` is created when:

* `DeltaFileFormat` is requested for the [fileFormat](DeltaFileFormat.md#fileFormat)
* `CDCReaderImpl` is requested for the [scanIndex](change-data-feed/CDCReaderImpl.md#scanIndex)

### isSplittable Flag { #isSplittable }

`DeltaParquetFileFormat` can be given `isSplittable` flag when [created](#creating-instance).

!!! note "FileFormat"
    `isSplittable` is part of the `FileFormat` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormat/#isSplittable)) abstraction to indicate whether this delta table is splittable or not.

Unless given, `isSplittable` flag is enabled by default (to match the base `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#isSplittable))).

`isSplittable` is disabled (`false`) when:

* `DeltaParquetFileFormat` is requested to [copyWithDVInfo](#copyWithDVInfo) and created with [deletion vectors](#hasDeletionVectorMap) enabled
* `DMLWithDeletionVectorsHelper` is requested to [replace a FileIndex](deletion-vectors/DMLWithDeletionVectorsHelper.md#replaceFileIndex)

!!! note
    `DeltaParquetFileFormat` is either splittable or supports [deletion vectors](#hasDeletionVectorMap).

`isSplittable` is also used to [buildReaderWithPartitionValues](#buildReaderWithPartitionValues) (to assert the configuration of this delta table).

### disablePushDowns { #disablePushDowns }

`DeltaParquetFileFormat` can be given `disablePushDowns` flag when [created](#creating-instance).

`disablePushDowns` flag indicates whether this delta table supports predicate pushdown optimization or not for [buildReaderWithPartitionValues](#buildReaderWithPartitionValues) to pass the filters down to the parquet data reader or not.

Unless given, `disablePushDowns` flag is disabled (`false`) by default.

`disablePushDowns` is enabled (`true`) when:

* `DeltaParquetFileFormat` is requested to [copyWithDVInfo](#copyWithDVInfo) and created with [deletion vectors](#hasDeletionVectorMap) enabled
* `DMLWithDeletionVectorsHelper` is requested to [replace a FileIndex](deletion-vectors/DMLWithDeletionVectorsHelper.md#replaceFileIndex)

!!! note
    `DeltaParquetFileFormat` supports either the predicate pushdown optimization (`disablePushDowns` is disabled) or [deletion vectors](#hasDeletionVectorMap).

## \_\_delta_internal_row_index Internal Metadata Column { #ROW_INDEX_COLUMN_NAME }

`DeltaParquetFileFormat` defines `__delta_internal_row_index` name for the metadata column name with the index of a row within a file.

`__delta_internal_row_index` is an [internal column](column-mapping/DeltaColumnMappingBase.md#DELTA_INTERNAL_COLUMNS).

When defined in the schema (of a delta table), [DeltaParquetFileFormat](#buildReaderWithPartitionValues) creates an [iteratorWithAdditionalMetadataColumns](#iteratorWithAdditionalMetadataColumns).

!!! warning
    `__delta_internal_row_index` column is only supported for delta tables with the following features disabled:

    * [File Splitting](#isSplittable)
    * [Predicate Pushdown](#disablePushDowns)

`__delta_internal_row_index` is used when:

* `DMLWithDeletionVectorsHelper` is requested to [replace a FileIndex](deletion-vectors/DMLWithDeletionVectorsHelper.md#replaceFileIndex) (in all the delta tables in a logical plan)
* `DeletionVectorBitmapGenerator` is requested to [buildRowIndexSetsForFilesMatchingCondition](deletion-vectors/DeletionVectorBitmapGenerator.md#buildRowIndexSetsForFilesMatchingCondition)

## Building Data Reader (With Partition Values) { #buildReaderWithPartitionValues }

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

`buildReaderWithPartitionValues` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat#buildReaderWithPartitionValues)) abstraction.

### <span id="prepareSchema"> Preparing Schema

```scala
prepareSchema(
  inputSchema: StructType): StructType
```

`prepareSchema` [creates a physical schema](column-mapping/DeltaColumnMappingBase.md#createPhysicalSchema) (for the `inputSchema`, the [referenceSchema](#referenceSchema) and the [DeltaColumnMappingMode](#columnMappingMode)).

## supportFieldName { #supportFieldName }

??? note "FileFormat"

    ```scala
    supportFieldName(
      name: String): Boolean
    ```

    `supportFieldName` is part of the `FileFormat` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormat#supportFieldName)) abstraction.

`supportFieldName` is enabled (`true`) when either holds true:

* The [DeltaColumnMappingMode](#columnMappingMode) is not `NoMapping`
* The default (parent) `supportFieldName` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormat#supportFieldName))

## metadataSchemaFields { #metadataSchemaFields }

??? note "FileFormat"

    ```scala
    metadataSchemaFields: Seq[StructField]
    ```

    `metadataSchemaFields` is part of the `FileFormat` ([Spark SQL]({{ book.spark_sql }}/connectors/FileFormat/#metadataSchemaFields)) abstraction.

!!! note "Review Me"

Due to an issue in Spark SQL (to be reported), `metadataSchemaFields` removes `row_index` from the default `metadataSchemaFields` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#metadataSchemaFields)).

!!! note "ParquetFileFormat"
    All what `ParquetFileFormat` does (when requested for the `metadataSchemaFields`) is to add the `row_index`. In other words, `DeltaParquetFileFormat` reverts this column addition.
