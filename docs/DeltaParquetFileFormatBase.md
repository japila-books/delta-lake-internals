# DeltaParquetFileFormatBase

`DeltaParquetFileFormatBase` is a base abstraction of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/)) abstraction for [delta file formats](#implementations) (with data files in [parquet](https://parquet.apache.org/) file format).

## Deletion Vectors-Enabled Scans

`DeltaParquetFileFormatBase` makes a precondition/invariant check for delta table scans with [Deletion Vectors](./deletion-vectors/index.md) enabled.

When the [delta table is referenced by a path](#hasTablePath) (not a name or identifier) and [useMetadataRowIndexOpt](#useMetadataRowIndexOpt) is defined, the flag should match [optimizationsEnabled](#optimizationsEnabled).

If they differ, `DeltaParquetFileFormatBase` throws an `IllegalArgumentException`:

```text
Wrong arguments for Delta table scan with deletion vectors
```

## useMetadataRowIndexOpt Flag { #useMetadataRowIndexOpt }

`DeltaParquetFileFormatBase` can be given `useMetadataRowIndexOpt` flag when [created](#creating-instance) for row index source for [Deletion Vectors](./deletion-vectors/index.md) filtering.

`useMetadataRowIndexOpt` flag is undefined (`None`) by default.

`useMetadataRowIndexOpt` is configured using [spark.databricks.delta.deletionVectors.useMetadataRowIndex](./configuration-properties/index.md#DELETION_VECTORS_USE_METADATA_ROW_INDEX) configuration property (for [DeltaParquetFileFormat](DeltaParquetFileFormat.md)).

`useMetadataRowIndexOpt` is used for [buildReaderWithPartitionValues](#buildReaderWithPartitionValues), if defined, or defaults to [spark.databricks.delta.deletionVectors.useMetadataRowIndex](./configuration-properties/index.md#DELETION_VECTORS_USE_METADATA_ROW_INDEX) configuration property.

For [path-based delta tables](#hasTablePath) with `useMetadataRowIndexOpt` defined, the value must be exactly this [optimizationsEnabled](#optimizationsEnabled) (for [Deletion Vectors-Enabled Scans](#deletion-vectors-enabled-scans)).

## optimizationsEnabled Flag { #optimizationsEnabled }

`DeltaParquetFileFormatBase` can be given `optimizationsEnabled` flag when [created](#creating-instance) to enable scan optimizations (file splitting and predicate pushdown).

In other words, `optimizationsEnabled` flag is equivalent to using scan optimizations (file splitting and predicate pushdown).

`optimizationsEnabled` is enabled (`true`) by default.

`optimizationsEnabled` controls [isSplitable](#isSplitable) predicate.

`optimizationsEnabled` must be enabled when [buildReaderWithPartitionValues](#buildReaderWithPartitionValues) with this [useMetadataRowIndex](#useMetadataRowIndex) flag disabled.

When `optimizationsEnabled` is disabled, [prepareFiltersForRead](#prepareFiltersForRead) gives no filters.

`optimizationsEnabled` must be exactly this [useMetadataRowIndexOpt](#useMetadataRowIndexOpt) (when defined) for [path-based delta tables](#hasTablePath).

`optimizationsEnabled` is used when:

* `DeltaParquetFileFormatBase` is [created](#creating-instance) for [Deletion Vectors-Enabled Scans](#deletion-vectors-enabled-scans)
* `DMLWithDeletionVectorsHelper` is requested to [replaceFileIndex](./deletion-vectors/DMLWithDeletionVectorsHelper.md#replaceFileIndex) (where this flag is disabled)

## Implementations

* [DeltaParquetFileFormat](DeltaParquetFileFormat.md)
* [DeltaParquetFileFormatV2](DeltaParquetFileFormatV2.md)

## Creating Instance

`DeltaParquetFileFormatBase` takes the following to be created:

* <span id="protocolMetadataAdapter"> [ProtocolMetadataAdapter](ProtocolMetadataAdapter.md)
* <span id="nullableRowTrackingConstantFields"> `nullableRowTrackingConstantFields` flag (default: `false`)
* <span id="nullableRowTrackingGeneratedFields"> `nullableRowTrackingGeneratedFields` flag (default: `false`)
* [optimizationsEnabled](#optimizationsEnabled) flag
* <span id="tablePath"> Optional Table Path (default: undefined)
* <span id="isCDCRead"> `isCDCRead` flag (default: `false`)
* [useMetadataRowIndexOpt](#useMetadataRowIndexOpt) flag

While being created, `DeltaParquetFileFormatBase` asserts the following:

1. [Deletion Vectors-Enabled Scans](#deletion-vectors-enabled-scans)
2. [delta table is readable](ProtocolMetadataAdapter.md#assertTableReadable).
3. Either [nullableRowTrackingConstantFields](#nullableRowTrackingConstantFields) is disabled or [nullableRowTrackingGeneratedFields](#nullableRowTrackingGeneratedFields) is enabled.
4. With [columnMappingMode](#columnMappingMode) as [IdMapping](./column-mapping/DeltaColumnMappingMode.md#IdMapping), ...FIXME

??? note "Abstract Class"
    `DeltaParquetFileFormatBase` is an abstract class and cannot be created directly.
    It is created indirectly for the [concrete DeltaParquetFileFormatBases](#implementations).

## isSplitable { #isSplitable }

??? note "ParquetFileFormat"

    ```scala
    isSplitable(
      sparkSession: SparkSession,
      options: Map[String, String],
      path: Path): Boolean
    ```

    `isSplitable` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#isSplitable)) abstraction.

`isSplitable` returns this [optimizationsEnabled](#optimizationsEnabled).

## Build Data Reader (with Partition Values) { #buildReaderWithPartitionValues }

??? note "ParquetFileFormat"

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

    `buildReaderWithPartitionValues` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#buildReaderWithPartitionValues)) abstraction.

`buildReaderWithPartitionValues`...FIXME

### prepareSchemaForRead { #prepareSchemaForRead }

```scala
prepareSchemaForRead(
  inputSchema: StructType): StructType
```

`prepareSchemaForRead`...FIXME

### prepareFiltersForRead { #prepareFiltersForRead }

```scala
prepareFiltersForRead(
  filters: Seq[Filter]): Seq[Filter]
```

`prepareFiltersForRead`...FIXME

## hasTablePath { #hasTablePath }

```scala
hasTablePath: Boolean
```

`hasTablePath` is enabled (`true`) when this delta table is referenced by a [path](#tablePath) (not a name/identifier).

---

`hasTablePath` is used when:

* `DeltaParquetFileFormatBase` is [created](#creating-instance) and requested to [buildReaderWithPartitionValues](#buildReaderWithPartitionValues)

## supportFieldName { #supportFieldName }

??? note "FileFormat"

    ```scala
    supportFieldName(
      name: String): Boolean
    ```

    `supportFieldName` is part of the `FileFormat` ([Spark SQL]({{ book.spark_sql }}/files/FileFormat/#supportFieldName)) abstraction.

`supportFieldName` is enabled (`true`) when either holds true:

* [DeltaColumnMappingMode](#columnMappingMode) is not `NoMapping`
* The default (parent) `supportFieldName` ([Spark SQL]({{ book.spark_sql }}/files/FileFormat/#supportFieldName)) is enabled

## metadataSchemaFields { #metadataSchemaFields }

??? note "ParquetFileFormat"

    ```scala
    metadataSchemaFields: Seq[StructField]
    ```

    `metadataSchemaFields` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#metadataSchemaFields)) abstraction.

!!! note "Review Me"

Due to an issue in Spark SQL (to be reported), `metadataSchemaFields` removes `row_index` from the default `metadataSchemaFields` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#metadataSchemaFields)).

!!! note "ParquetFileFormat"
    All what `ParquetFileFormat` does (when requested for the `metadataSchemaFields`) is to add the `row_index`. In other words, `DeltaParquetFileFormat` reverts this column addition.

## prepareWrite { #prepareWrite }

??? note "ParquetFileFormat"

    ```scala
    prepareWrite(
       sparkSession: SparkSession,
       job: Job,
       options: Map[String, String],
       dataSchema: StructType): OutputWriterFactory
    ```

    `prepareWrite` is part of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/#prepareWrite)) abstraction.

`prepareWrite`...FIXME

## fileConstantMetadataExtractors { #fileConstantMetadataExtractors }

??? note "FileFormat"

    ```scala
    fileConstantMetadataExtractors: Map[String, PartitionedFile => Any]
    ```

    `fileConstantMetadataExtractors` is part of the `FileFormat` ([Spark SQL]({{ book.spark_sql }}/files/FileFormat/#fileConstantMetadataExtractors)) abstraction.

`fileConstantMetadataExtractors`...FIXME
