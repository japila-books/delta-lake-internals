---
title: SchemaReadOptions
---

# SchemaReadOptions &mdash; Schema Validation Flags

`SchemaReadOptions` contains the schema validation flags (based on [configuration properties](../configuration-properties/index.md) in a `SparkSession`).

`SchemaReadOptions` is created for the following:

* [DeltaSourceBase](DeltaSourceBase.md#schemaReadOptions)
* [SparkMicroBatchStream](SparkMicroBatchStream.md#schemaReadOptions)

## allowUnsafeStreamingReadOnColumnMappingSchemaChanges { #allowUnsafeStreamingReadOnColumnMappingSchemaChanges }

[spark.databricks.delta.streaming.unsafeReadOnIncompatibleColumnMappingSchemaChanges.enabled](../configuration-properties/index.md#DELTA_STREAMING_UNSAFE_READ_ON_INCOMPATIBLE_COLUMN_MAPPING_SCHEMA_CHANGES)

## allowUnsafeStreamingReadOnPartitionColumnChanges { #allowUnsafeStreamingReadOnPartitionColumnChanges }

[spark.databricks.delta.streaming.unsafeReadOnPartitionColumnChanges.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_STREAMING_UNSAFE_READ_ON_PARTITION_COLUMN_CHANGE)

## forceEnableStreamingReadOnReadIncompatibleSchemaChangesDuringStreamStart { #forceEnableStreamingReadOnReadIncompatibleSchemaChangesDuringStreamStart }

[spark.databricks.delta.streaming.unsafeReadOnIncompatibleSchemaChangesDuringStreamStart.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_STREAMING_UNSAFE_READ_ON_INCOMPATIBLE_SCHEMA_CHANGES_DURING_STREAM_START)

## forceEnableUnsafeReadOnNullabilityChange { #forceEnableUnsafeReadOnNullabilityChange }

[spark.databricks.delta.streaming.unsafeReadOnNullabilityChange.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_STREAM_UNSAFE_READ_ON_NULLABILITY_CHANGE)

## isStreamingFromColumnMappingTable { #isStreamingFromColumnMappingTable }

[DeltaColumnMappingMode](../actions/Metadata.md#columnMappingMode) is anything but [NoMapping](../column-mapping/DeltaColumnMappingMode.md#NoMapping)

## typeWideningEnabled { #typeWideningEnabled }

[spark.databricks.delta.typeWidening.allowTypeChangeStreamingDeltaSource](../configuration-properties/DeltaSQLConf.md#DELTA_ALLOW_TYPE_WIDENING_STREAMING_SOURCE) and `TypeWidening.isSupported`

## enableSchemaTrackingForTypeWidening { #enableSchemaTrackingForTypeWidening }

[spark.databricks.delta.typeWidening.enableStreamingSchemaTracking](../configuration-properties/DeltaSQLConf.md#DELTA_TYPE_WIDENING_ENABLE_STREAMING_SCHEMA_TRACKING)
