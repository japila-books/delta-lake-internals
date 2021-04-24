# Configuration Properties

## <span id="spark.delta.logStore.class"> spark.delta.logStore.class

The fully-qualified class name of a [LogStore](LogStore.md)

Default: [HDFSLogStore](HDFSLogStore.md)

Used when:

* `LogStoreProvider` is requested for a [LogStore](LogStoreProvider.md#createLogStore)
