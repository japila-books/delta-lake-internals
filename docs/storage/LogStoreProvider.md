# LogStoreProvider

`LogStoreProvider` is an abstraction of [providers](#implementations) of [LogStores](#createLogStore).

## <span id="logStoreClassConfKey"><span id="defaultLogStoreClass"><span id="spark.delta.logStore.class"> spark.delta.logStore.class

`LogStoreProvider` uses the [spark.delta.logStore.class](../configuration-properties.md#spark.delta.logStore.class) configuration property for the [LogStore](LogStore.md) to [create](#createLogStore) (for a [../DeltaLog](../DeltaLog.md), a [DeltaHistoryManager](../DeltaHistoryManager.md), and [DeltaFileOperations](../DeltaFileOperations.md)).

## <span id="createLogStore"> Creating LogStore

```scala
createLogStore(
  spark: SparkSession): LogStore
createLogStore(
  sparkConf: SparkConf,
  hadoopConf: Configuration): LogStore
```

`createLogStore`...FIXME

`createLogStore` is used when:

* [DeltaLog](../DeltaLog.md#store) is created

* [LogStore.apply](LogStore#apply) utility is used
