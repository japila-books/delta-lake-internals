# WriteIntoDeltaLike

`WriteIntoDeltaLike` is an [abstraction](#contract) of [commands](#implementations) that can write data out into delta tables.

## Contract (Subset)

### writeAndReturnCommitData { #writeAndReturnCommitData }

```scala
writeAndReturnCommitData(
  txn: OptimisticTransaction,
  sparkSession: SparkSession,
  clusterBySpecOpt: Option[ClusterBySpec] = None,
  isTableReplace: Boolean = false): TaggedCommitData[Action]
```

Used when:

* `CreateDeltaTableCommand` is requested to [handleCreateTableAsSelect](create-table/CreateDeltaTableCommand.md#handleCreateTableAsSelect)
* `WriteIntoDelta` is [executed](WriteIntoDelta.md#run)
* `WriteIntoDeltaLike` is requested to [write data out](#write)

## Implementations

* [WriteIntoDelta](WriteIntoDelta.md)

## Write Data Out { #write }

```scala
write(
  txn: OptimisticTransaction,
  sparkSession: SparkSession,
  clusterBySpecOpt: Option[ClusterBySpec] = None,
  isTableReplace: Boolean = false): Seq[Action]
```

`write` [writeAndReturnCommitData](#writeAndReturnCommitData) and returns the [Action](../Action.md)s.
