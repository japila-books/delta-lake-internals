# DeltaParquetFileFormatV2

`DeltaParquetFileFormatV2` is a V2 implementation of [DeltaParquetFileFormatBase](DeltaParquetFileFormatBase.md) using [Delta Kernel](./kernel/index.md)'s [Protocol](#protocol) and [Metadata](#metadata).

## Creating Instance

`DeltaParquetFileFormatV2` takes the following to be created:

* <span id="protocol"> [Protocol](actions/Protocol.md)
* <span id="metadata"> [Metadata](./actions/Metadata.md)
* <span id="nullableRowTrackingConstantFields"> [nullableRowTrackingConstantFields](DeltaParquetFileFormatBase.md#nullableRowTrackingConstantFields)
* <span id="nullableRowTrackingGeneratedFields"> [nullableRowTrackingGeneratedFields](DeltaParquetFileFormatBase.md#nullableRowTrackingGeneratedFields)
* <span id="optimizationsEnabled"> [optimizationsEnabled](DeltaParquetFileFormatBase.md#optimizationsEnabled)
* <span id="tablePath"> [tablePath](DeltaParquetFileFormatBase.md#tablePath)
* <span id="isCDCRead"> [isCDCRead](DeltaParquetFileFormatBase.md#isCDCRead)
* <span id="useMetadataRowIndex"> [useMetadataRowIndex](DeltaParquetFileFormatBase.md#useMetadataRowIndex)

While being created, `DeltaParquetFileFormatV2` creates a [ProtocolMetadataAdapterV2](ProtocolMetadataAdapterV2.md) for the given [Protocol](#protocol) and [Metadata](#metadata).

`DeltaParquetFileFormatV2` is created when:

* `PartitionUtils` is requested to [createDeltaParquetFileFormat](PartitionUtils.md#createDeltaParquetFileFormat)
