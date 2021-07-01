# Configuration Properties

## <span id="spark.delta.logStore.class"> spark.delta.logStore.class

The fully-qualified class name of a [LogStore](storage/LogStore.md)

Default: [HDFSLogStore](storage/HDFSLogStore.md)

Used when:

* `LogStoreProvider` is requested for a [LogStore](storage/LogStoreProvider.md#createLogStore)
