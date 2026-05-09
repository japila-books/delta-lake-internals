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

!!! warning
    `__delta_internal_row_index` column is only supported for delta tables with the following features disabled:

    * [File Splitting](#isSplittable)
    * [Predicate Pushdown](#disablePushDowns)

`__delta_internal_row_index` is used when:

* `DMLWithDeletionVectorsHelper` is requested to [replace a FileIndex](deletion-vectors/DMLWithDeletionVectorsHelper.md#replaceFileIndex) (in all the delta tables in a logical plan)
* `DeletionVectorBitmapGenerator` is requested to [buildRowIndexSetsForFilesMatchingCondition](deletion-vectors/DeletionVectorBitmapGenerator.md#buildRowIndexSetsForFilesMatchingCondition)
