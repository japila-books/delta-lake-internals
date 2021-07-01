# DelegatingLogStore

`DelegatingLogStore` is the default [LogStore](LogStore.md).

## Creating Instance

`DelegatingLogStore` takes the following to be created:

* <span id="hadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))

`DelegatingLogStore` is created when:

* `LogStore` utility is used to [createLogStoreWithClassName](LogStore.md#createLogStoreWithClassName)

## <span id="defaultLogStore"> defaultLogStore

`DelegatingLogStore` [creates a LogStore](#createLogStore) (lazily) that is used when requested to [schemeBasedLogStore](#schemeBasedLogStore).

??? note "Lazy Value"
    `defaultLogStore` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

## <span id="getDelegate"> Looking Up LogStore Delegate by Path

```scala
getDelegate(
  path: Path): LogStore
```

`getDelegate` is a mere alias of [schemeBasedLogStore](#schemeBasedLogStore).

### <span id="schemeBasedLogStore"> schemeBasedLogStore

```scala
schemeBasedLogStore(
  path: Path): LogStore
```

`schemeBasedLogStore`...FIXME

## <span id="createLogStore"> createLogStore

```scala
createLogStore(
  className: String): LogStore
```

`createLogStore`...FIXME

`createLogStore` is used when:

* `DelegatingLogStore` is requested to [schemeBasedLogStore](#schemeBasedLogStore) and [defaultLogStore](#defaultLogStore)
