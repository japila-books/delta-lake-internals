# DeltaWriteOptionsImpl

`DeltaWriteOptionsImpl` is a [DeltaOptionParser](DeltaOptionParser.md).

## <span id="canMergeSchema"> canMergeSchema

```scala
canMergeSchema: Boolean
```

`canMergeSchema` is the value of [mergeSchema](DeltaOptions.md#MERGE_SCHEMA_OPTION) option (if defined) or [spark.databricks.delta.schema.autoMerge.enabled](DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property.

`canMergeSchema` is used when:

* `WriteIntoDelta` is [created](commands/WriteIntoDelta.md#canMergeSchema)
* `DeltaSink` is [created](DeltaSink.md#canMergeSchema)

## <span id="canOverwriteSchema"> canOverwriteSchema

```scala
canOverwriteSchema: Boolean
```

`canOverwriteSchema` is the value of [overwriteSchema](DeltaOptions.md#OVERWRITE_SCHEMA_OPTION) option.

`canOverwriteSchema` is used when:

* `CreateDeltaTableCommand` is requested to [replaceMetadataIfNecessary](commands/CreateDeltaTableCommand.md#replaceMetadataIfNecessary)
* `WriteIntoDelta` is [created](commands/WriteIntoDelta.md#canOverwriteSchema)
* `DeltaSink` is [created](DeltaSink.md#canOverwriteSchema)

## <span id="rearrangeOnly"> rearrangeOnly

```scala
rearrangeOnly: Boolean
```

`rearrangeOnly` is the value of [dataChange](DeltaOptions.md#DATA_CHANGE_OPTION) option.

`rearrangeOnly` is used when:

* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write)
