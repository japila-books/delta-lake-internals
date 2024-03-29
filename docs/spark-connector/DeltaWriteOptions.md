# DeltaWriteOptions

`DeltaWriteOptions` is a type-safe abstraction of the write-related [DeltaOptions](DeltaOptions.md).

`DeltaWriteOptions` is [DeltaWriteOptionsImpl](DeltaWriteOptionsImpl.md) and [DeltaOptionParser](DeltaOptionParser.md).

## replaceWhere { #replaceWhere }

```scala
replaceWhere: Option[String]
```

`replaceWhere` is the value of [replaceWhere](options.md#REPLACE_WHERE_OPTION) option.

---

`replaceWhere` is used when:

* `CreateDeltaTableCommand` command is requested for a [Delta Operation](../commands/create-table/CreateDeltaTableCommand.md#getOperation) (for history purposes)
* `WriteIntoDelta` command is [created](../commands/WriteIntoDelta.md#canOverwriteSchema), [executed](../commands/WriteIntoDelta.md#run) and requested to [write](../commands/WriteIntoDelta.md#write)

## userMetadata { #userMetadata }

```scala
userMetadata: Option[String]
```

`userMetadata` is the value of [userMetadata](options.md#USER_METADATA_OPTION) option.

## optimizeWrite { #optimizeWrite }

```scala
optimizeWrite: Option[Boolean]
```

`optimizeWrite` is the value of [optimizeWrite](options.md#OPTIMIZE_WRITE_OPTION) option.
