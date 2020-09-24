== [[LogStoreProvider]] LogStoreProvider

`LogStoreProvider` is an abstraction of <<implementations, providers>> of <<createLogStore, LogStores>>.

[[logStoreClassConfKey]][[defaultLogStoreClass]][[spark.delta.logStore.class]]
`LogStoreProvider` uses the *spark.delta.logStore.class* configuration property (default: <<HDFSLogStore.md#, HDFSLogStore>>) for the fully-qualified class name of the <<LogStore.md#, LogStore>> to <<createLogStore, create>> (for a <<DeltaLog.md#, DeltaLog>>, a <<DeltaHistoryManager.md#, DeltaHistoryManager>>, and <<DeltaFileOperations.md#, DeltaFileOperations>>).

== [[createLogStore]] Creating LogStore -- `createLogStore` Method

[source, scala]
----
createLogStore(
  spark: SparkSession): LogStore
createLogStore(
  sparkConf: SparkConf,
  hadoopConf: Configuration): LogStore
----

`createLogStore`...FIXME

[NOTE]
====
`createLogStore` is used when:

* <<DeltaLog.md#store, DeltaLog>> is created

* <<LogStore#apply, LogStore.apply>> utility is used (to create a <<LogStore.md#, LogStore>>)
====
