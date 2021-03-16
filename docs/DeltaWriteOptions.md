# DeltaWriteOptions

`DeltaWriteOptions` is a type-safe abstraction of the write-related [DeltaOptions](DeltaOptions.md).

`DeltaWriteOptions` is `DeltaWriteOptionsImpl` and `DeltaOptionParser`.

## <span id="replaceWhere"> replaceWhere

```scala
replaceWhere: Option[String]
```

`replaceWhere` is the value of [replaceWhere](DeltaOptions.md#REPLACE_WHERE_OPTION) option.

`replaceWhere` is used when:

* `CreateDeltaTableCommand` command is requested to [getOperation](commands/CreateDeltaTableCommand.md#getOperation)
* `WriteIntoDelta` command is [created](commands/WriteIntoDelta.md#canOverwriteSchema), [executed](commands/WriteIntoDelta.md#run), and requested to [write](commands/WriteIntoDelta.md#write)

## <span id="userMetadata"> userMetadata

```scala
userMetadata: Option[String]
```

`userMetadata` is the value of [userMetadata](DeltaOptions.md#USER_METADATA_OPTION) option.

## <span id="optimizeWrite"> optimizeWrite

```scala
optimizeWrite: Option[Boolean]
```

`optimizeWrite` is the value of [optimizeWrite](DeltaOptions.md#OPTIMIZE_WRITE_OPTION) option.
