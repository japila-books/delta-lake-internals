# DelegatingLogStore

`DelegatingLogStore` is the default [LogStore](LogStore.md).

## Creating Instance

`DelegatingLogStore` takes the following to be created:

* <span id="hadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))

`DelegatingLogStore` is created when:

* `LogStore` utility is used to [createLogStoreWithClassName](LogStore.md#createLogStoreWithClassName)

## <span id="defaultLogStore"> Default LogStore

```scala
defaultLogStore: LogStore
```

`DelegatingLogStore` [creates a LogStore](#createLogStore) (_lazily_) that is used when requested to [schemeBasedLogStore](#schemeBasedLogStore).

??? note "Lazy Value"
    `defaultLogStore` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

## <span id="schemeToLogStoreMap"> LogStore by Scheme Lookup Table

```scala
schemeToLogStoreMap: Map[String, LogStore]
```

`DelegatingLogStore` uses an internal registry of [LogStore](LogStore.md)s by scheme for [looking them up once created](#schemeBasedLogStore).

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

`schemeBasedLogStore` takes the scheme component (of the URI) of the given path.

If undefined, `schemeBasedLogStore` gives the [defaultLogStore](#defaultLogStore).

For a scheme defined, `schemeBasedLogStore` looks it up in the [schemeToLogStoreMap](#schemeToLogStoreMap) registry and returns it when found.

Otherwise, `schemeBasedLogStore` [creates a LogStore](#createLogStore) based on the following (in the order):

1. [Scheme-specific configuration key](LogStore.md#logStoreSchemeConfKey) to look up the class name of the `LogStore` in the `SparkConf`
1. [Default LogStore class name](#getDefaultLogStoreClassName) for the scheme
1. Uses the [defaultLogStore](#defaultLogStore)

`schemeBasedLogStore` registers the `LogStore` in the [schemeToLogStoreMap](#schemeToLogStoreMap) registry for future lookups.

`schemeBasedLogStore` prints out the following INFO message to the logs:

```text
LogStore [className] is used for scheme [scheme]
```

### <span id="getDefaultLogStoreClassName"> Default LogStore (Class Name) for Scheme

```scala
getDefaultLogStoreClassName(
  scheme: String): Option[String]
```

`getDefaultLogStoreClassName` returns the class name of the [LogStore](LogStore.md) for a given `scheme` or `None` (undefined).

Schemes  | Class Name
---------|---------
 `s3`, `s3a`, `s3n` | [S3SingleDriverLogStore](S3SingleDriverLogStore.md)
 `abfs`, `abfss`, `adl`, `wasb`, `wasbs` | `AzureLogStore`

## <span id="createLogStore"> Creating LogStore

```scala
createLogStore(
  className: String): LogStore
```

`createLogStore` [creates a LogStore](LogStore.md#createLogStoreWithClassName) for the given class name.

`createLogStore` is used when:

* `DelegatingLogStore` is requested to [schemeBasedLogStore](#schemeBasedLogStore) and [defaultLogStore](#defaultLogStore)
