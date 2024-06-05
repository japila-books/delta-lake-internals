# DeltaParquetFileFormat

`DeltaParquetFileFormat` is a `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat)) to support [no restrictions on columns names](#prepareSchema).

## Creating Instance

`DeltaParquetFileFormat` takes the following to be created:

* <span id="protocol"> [Protocol](Protocol.md)
* <span id="metadata"> [Metadata](Metadata.md)
* <span id="nullableRowTrackingFields"> `nullableRowTrackingFields` flag (default: `false`)
* <span id="optimizationsEnabled"> `optimizationsEnabled` flag (default: `true`)
* <span id="tablePath"> Optional Table Path (default: `None` (unspecified))
* <span id="isCDCRead"> `isCDCRead` flag (default: `false`)

`DeltaParquetFileFormat` is created when:

* `DeltaFileFormat` is requested for the [file format](DeltaFileFormat.md#fileFormat)
* `CDCReaderImpl` is requested for the [scanIndex](change-data-feed/CDCReaderImpl.md#scanIndex)

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

## Building Data Reader (with Partition Values) { #buildReaderWithPartitionValues }

??? note "FileFormat"

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

    `buildReaderWithPartitionValues` is part of the `FileFormat` ([Spark SQL]({{ book.spark_sql }}/files/FileFormat#buildReaderWithPartitionValues)) abstraction.

With neither [__delta_internal_is_row_deleted](#IS_ROW_DELETED_COLUMN_NAME) nor `row_index` columns found in the given`requiredSchema`,`buildReaderWithPartitionValues` uses the default `buildReaderWithPartitionValues` (from `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#buildReaderWithPartitionValues))).

??? note "row_index Column Name"
    `buildReaderWithPartitionValues` uses [spark.databricks.delta.deletionVectors.useMetadataRowIndex](configuration-properties/index.md#deletionVectors.useMetadataRowIndex) to determine the `row_index` column name (straight from `ParquetFileFormat` or [__delta_internal_row_index](#ROW_INDEX_COLUMN_NAME)).

!!! note "FIXME Other assertions"

In the end, `buildReaderWithPartitionValues` [builds a parquet data reader with additional metadata columns](#iteratorWithAdditionalMetadataColumns).

### iteratorWithAdditionalMetadataColumns { #iteratorWithAdditionalMetadataColumns }

```scala
iteratorWithAdditionalMetadataColumns(
  partitionedFile: PartitionedFile,
  iterator: Iterator[Object],
  isRowDeletedColumnOpt: Option[ColumnMetadata],
  rowIndexColumnOpt: Option[ColumnMetadata],
  useOffHeapBuffers: Boolean,
  serializableHadoopConf: SerializableConfiguration,
  useMetadataRowIndex: Boolean): Iterator[Object]
```

`iteratorWithAdditionalMetadataColumns`...FIXME

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
