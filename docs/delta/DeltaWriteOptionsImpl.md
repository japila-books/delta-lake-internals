# DeltaWriteOptionsImpl

`DeltaWriteOptionsImpl` is an [extension](#contract) of the [DeltaOptionParser](DeltaOptionParser.md) abstraction.

!!! note "Fun Fact"
    Despite the suffix (`Impl`), `DeltaWriteOptionsImpl` is not an implementation (_class_) but a trait.

## <span id="canMergeSchema"> canMergeSchema

```scala
canMergeSchema: Boolean
```

`canMergeSchema` is the value of [mergeSchema](options.md#MERGE_SCHEMA_OPTION) option (if defined) or [spark.databricks.delta.schema.autoMerge.enabled](../configuration-properties/DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property.

`canMergeSchema` is used when:

* `WriteIntoDelta` is [created](../commands/WriteIntoDelta.md#canMergeSchema)
* `DeltaSink` is [created](DeltaSink.md#canMergeSchema)

## <span id="canOverwriteSchema"> canOverwriteSchema

```scala
canOverwriteSchema: Boolean
```

`canOverwriteSchema` is the value of [overwriteSchema](options.md#OVERWRITE_SCHEMA_OPTION) option (in the [options](DeltaOptionParser.md#options)).

`canOverwriteSchema` is used when:

* `CreateDeltaTableCommand` is [executed](../commands/CreateDeltaTableCommand.md) (and [replaceMetadataIfNecessary](../commands/CreateDeltaTableCommand.md#replaceMetadataIfNecessary))
* `WriteIntoDelta` is [created](../commands/WriteIntoDelta.md#canOverwriteSchema)
* `DeltaSink` is [created](DeltaSink.md#canOverwriteSchema)

## <span id="rearrangeOnly"> rearrangeOnly

```scala
rearrangeOnly: Boolean
```

`rearrangeOnly` is the value of [dataChange](options.md#DATA_CHANGE_OPTION) option.

`rearrangeOnly` is used when:

* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)
