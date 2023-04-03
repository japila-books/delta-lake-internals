# DeltaWriteOptions

`DeltaWriteOptions` is a type-safe abstraction of the write-related [DeltaOptions](DeltaOptions.md).

`DeltaWriteOptions` is [DeltaWriteOptionsImpl](DeltaWriteOptionsImpl.md) and [DeltaOptionParser](DeltaOptionParser.md).

## <span id="replaceWhere"> replaceWhere

```scala
replaceWhere: Option[String]
```

`replaceWhere` is the value of [replaceWhere](options.md#REPLACE_WHERE_OPTION) option.

`replaceWhere` is used when:

* `WriteIntoDelta` command is [created](../commands/WriteIntoDelta.md#canOverwriteSchema) and [executed](../commands/WriteIntoDelta.md#run)
* `CreateDeltaTableCommand` command is requested for a [Delta Operation](../commands/CreateDeltaTableCommand.md#getOperation) (for history purposes)

## <span id="userMetadata"> userMetadata

```scala
userMetadata: Option[String]
```

`userMetadata` is the value of [userMetadata](options.md#USER_METADATA_OPTION) option.

## <span id="optimizeWrite"> optimizeWrite

```scala
optimizeWrite: Option[Boolean]
```

`optimizeWrite` is the value of [optimizeWrite](options.md#OPTIMIZE_WRITE_OPTION) option.
