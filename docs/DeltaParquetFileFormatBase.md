# DeltaParquetFileFormatBase

`DeltaParquetFileFormatBase` is a base abstraction of the `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/parquet/ParquetFileFormat/)) abstraction for [delta file formats](#implementations).

## Implementations

* [DeltaParquetFileFormat](DeltaParquetFileFormat.md)
* [DeltaParquetFileFormatV2](DeltaParquetFileFormatV2.md)

## Creating Instance

`DeltaParquetFileFormatBase` takes the following to be created:

* <span id="protocolMetadataAdapter"> [ProtocolMetadataAdapter](ProtocolMetadataAdapter.md)
* <span id="nullableRowTrackingConstantFields"> `nullableRowTrackingConstantFields` flag (default: `false`)
* <span id="nullableRowTrackingGeneratedFields"> `nullableRowTrackingGeneratedFields` flag (default: `false`)
* <span id="optimizationsEnabled"> `optimizationsEnabled` flag (default: `true`)
* <span id="tablePath"> Optional Table Path (default: undefined)
* <span id="isCDCRead"> `isCDCRead` flag (default: `false`)
* <span id="useMetadataRowIndexOpt"> Optional `useMetadataRowIndexOpt` flag (default: undefined)

While being created, `DeltaParquetFileFormatBase` asserts the following:

1. With [hasTablePath](#hasTablePath) enabled and [useMetadataRowIndexOpt](#useMetadataRowIndexOpt) defined, [useMetadataRowIndexOpt](#useMetadataRowIndexOpt) equals [optimizationsEnabled](#optimizationsEnabled) for [deletion vectors](./deletion-vectors/index.md)-enabled read.
2. [delta table is readable](ProtocolMetadataAdapter.md#assertTableReadable).
3. Either [nullableRowTrackingConstantFields](#nullableRowTrackingConstantFields) is disabled or [nullableRowTrackingGeneratedFields](#nullableRowTrackingGeneratedFields) is enabled.
4. With [columnMappingMode](#columnMappingMode) as [IdMapping](./column-mapping/DeltaColumnMappingMode.md#IdMapping), ...FIXME

??? note "Abstract Class"
    `DeltaParquetFileFormatBase` is an abstract class and cannot be created directly.
    It is created indirectly for the [concrete DeltaParquetFileFormatBases](#implementations).
