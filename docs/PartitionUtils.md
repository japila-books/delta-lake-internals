# PartitionUtils

## createDeltaParquetReaderFactory { #createDeltaParquetReaderFactory }

```java
PartitionReaderFactory createDeltaParquetReaderFactory(
  Snapshot snapshot,
  StructType dataSchema,
  StructType partitionSchema,
  StructType readDataSchema,
  Filter[] dataFilters,
  scala.collection.immutable.Map<String, String> scalaOptions,
  Configuration hadoopConf,
  SQLConf sqlConf)
```

`createDeltaParquetReaderFactory`...FIXME

---

`createDeltaParquetReaderFactory` is used when:

* `SparkBatch` is requested to [create a PartitionReaderFactory](./spark-connector/SparkBatch.md#createReaderFactory)
* `SparkMicroBatchStream` is requested to [create a PartitionReaderFactory](./spark-connector/SparkMicroBatchStream.md#createReaderFactory)

### createDeltaParquetFileFormat { #createDeltaParquetFileFormat }

```java
DeltaParquetFileFormatV2 createDeltaParquetFileFormat(
  Snapshot snapshot,
  String tablePath,
  boolean optimizationsEnabled,
  Option<Boolean> useMetadataRowIndex)
```

`createDeltaParquetFileFormat` creates a [DeltaParquetFileFormatV2](DeltaParquetFileFormatV2.md) for the given [Snapshot](Snapshot.md) (that is expected to be a [SnapshotImpl](./kernel/SnapshotImpl.md) of [Delta Kernel](./kernel/index.md)) and the following:

DeltaParquetFileFormatV2 | Value
-|-
[nullableRowTrackingConstantFields](DeltaParquetFileFormatV2.md#nullableRowTrackingConstantFields) | `false`
[nullableRowTrackingGeneratedFields](DeltaParquetFileFormatV2.md#nullableRowTrackingGeneratedFields) | `false`
[optimizationsEnabled](DeltaParquetFileFormatV2.md#optimizationsEnabled) | Given `optimizationsEnabled`
[tablePath](DeltaParquetFileFormatV2.md#tablePath) | Given `tablePath`
[isCDCRead](DeltaParquetFileFormatV2.md#isCDCRead) | `false`
[useMetadataRowIndex](DeltaParquetFileFormatV2.md#useMetadataRowIndex) | Given `useMetadataRowIndex`
