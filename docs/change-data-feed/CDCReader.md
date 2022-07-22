# CDCReader

`CDCReader` is a utility to...FIXME

## <span id="getCDCRelation"> getCDCRelation

```scala
getCDCRelation(
  spark: SparkSession,
  deltaLog: DeltaLog,
  snapshotToUse: Snapshot,
  partitionFilters: Seq[Expression],
  conf: SQLConf,
  options: CaseInsensitiveStringMap): BaseRelation
```

!!! note
    `partitionFilters` argument is not used.

`getCDCRelation` [getVersionForCDC](#getVersionForCDC) (with the [startingVersion](../DeltaDataSource.md#CDC_START_VERSION_KEY) and [startingTimestamp](../DeltaDataSource.md#CDC_START_TIMESTAMP_KEY) for the version and timestamp keys, respectively).

`getCDCRelation`...FIXME

`getCDCRelation` is used when:

* `DeltaLog` is requested to [create a relation](../DeltaLog.md#createRelation)

### <span id="getVersionForCDC"> Resolving Version

```scala
getVersionForCDC(
  spark: SparkSession,
  deltaLog: DeltaLog,
  conf: SQLConf,
  options: CaseInsensitiveStringMap,
  versionKey: String,
  timestampKey: String): Option[Long]
```

`getVersionForCDC` uses the given `options` map to get the value of the given `versionKey` key, if available.

!!! note "When `versionKey` and `timestampKey` are specified"
    `versionKey` and `timestampKey` are specified in the given `options` argument that is passed down through [getCDCRelation](#getCDCRelation) unmodified when `DeltaLog` is requested to [create a relation](../DeltaLog.md#createRelation) with non-empty `cdcOptions`.

Otherwise, `getVersionForCDC` uses the given `options` map to get the value of the given `timestampKey` key, if available. `getVersionForCDC`...FIXME

If neither the given `versionKey` nor the `timestampKey` key is available in the `options` map, `getVersionForCDC` returns `None` (_undefined value_).

## <span id="CDC_TYPE_NOT_CDC"> CDC_TYPE_NOT_CDC

```scala
CDC_TYPE_NOT_CDC: String
```

`CDCReader` defines a `CDC_TYPE_NOT_CDC` value that is always `null`.

`CDC_TYPE_NOT_CDC` is used when:

* `DeleteCommand` is requested to [rewriteFiles](../commands/delete/DeleteCommand.md#rewriteFiles)
* `MergeIntoCommand` is requested to [writeAllChanges](../commands/merge/MergeIntoCommand.md#writeAllChanges) (to [matchedClauseOutput](../commands/merge/MergeIntoCommand.md#matchedClauseOutput) and [notMatchedClauseOutput](../commands/merge/MergeIntoCommand.md#notMatchedClauseOutput))
* `WriteIntoDelta` is requested to [write](../commands/WriteIntoDelta.md#write)
* `UpdateCommand` is requested to [withUpdatedColumns](../commands/update/UpdateCommand.md#withUpdatedColumns)

## <span id="isCDCRead"> CDC-Aware Table Scan (CDC Read)

```scala
isCDCRead(
  options: CaseInsensitiveStringMap): Boolean
```

`isCDCRead` is `true` when one of the following options is specified (in the given `options`):

1. [readChangeFeed](../DeltaDataSource.md#CDC_ENABLED_KEY) with `true` value
1. (legacy) [readChangeData](../DeltaDataSource.md#CDC_ENABLED_KEY_LEGACY) with `true` value

Otherwise, `isCDCRead` is `false`.

`isCDCRead` is used when:

* `DeltaRelation` utility is used to [fromV2Relation](../DeltaRelation.md#fromV2Relation)
* `DeltaTableV2` is requested to [withOptions](../DeltaTableV2.md#withOptions)
* `DeltaDataSource` is requested for the [streaming source schema](../DeltaDataSource.md#sourceSchema) and to [create a BaseRelation](../DeltaDataSource.md#RelationProvider-createRelation)
