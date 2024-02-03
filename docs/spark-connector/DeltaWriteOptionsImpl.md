# DeltaWriteOptionsImpl

`DeltaWriteOptionsImpl` is an [extension](#contract) of the [DeltaOptionParser](DeltaOptionParser.md) abstraction.

!!! note "Fun Fact"
    Despite the suffix (`Impl`), `DeltaWriteOptionsImpl` is a trait not an implementation (_class_).

## Auto Schema Merging { #canMergeSchema }

```scala
canMergeSchema: Boolean
```

`canMergeSchema` flag controls **Auto Schema Merging** based on [mergeSchema](options.md#MERGE_SCHEMA_OPTION) option, if defined, or [schema.autoMerge.enabled](../configuration-properties/index.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property.

---

`canMergeSchema` is used when:

* `MergeIntoCommandBase` is requested for [canMergeSchema](../commands/merge/MergeIntoCommandBase.md#canMergeSchema) (while [running a merge](../commands/merge/MergeIntoCommand.md#runMerge))
* `WriteIntoDelta` is [created](../commands/WriteIntoDelta.md#canMergeSchema)
* `DeltaSink` is [created](DeltaSink.md#canMergeSchema)

## canOverwriteSchema { #canOverwriteSchema }

```scala
canOverwriteSchema: Boolean
```

`canOverwriteSchema` is the value of [overwriteSchema](options.md#OVERWRITE_SCHEMA_OPTION) option (in the [options](DeltaOptionParser.md#options)).

`canOverwriteSchema` is used when:

* `CreateDeltaTableCommand` is [executed](../commands/create-table/CreateDeltaTableCommand.md) (and [replaceMetadataIfNecessary](../commands/create-table/CreateDeltaTableCommand.md#replaceMetadataIfNecessary))
* `WriteIntoDelta` is [created](../commands/WriteIntoDelta.md#canOverwriteSchema)
* `DeltaSink` is [created](DeltaSink.md#canOverwriteSchema)

## rearrangeOnly { #rearrangeOnly }

```scala
rearrangeOnly: Boolean
```

`rearrangeOnly` is the negation of the value of [dataChange](options.md#DATA_CHANGE_OPTION) option.

---

`rearrangeOnly` is used when:

* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)

## isDynamicPartitionOverwriteMode { #isDynamicPartitionOverwriteMode }

```scala
isDynamicPartitionOverwriteMode: Boolean
```

`isDynamicPartitionOverwriteMode`...FIXME

---

`isDynamicPartitionOverwriteMode` is used when:

* `WriteIntoDelta` is requested to [write data out](../commands/WriteIntoDelta.md#write)
