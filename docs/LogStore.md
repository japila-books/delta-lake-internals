# LogStore (io.delta.storage)

`LogStore` is an [abstraction](#contract) of transaction log stores (to read and write Delta log files).

`LogStore` is created for [LogStoreAdaptor](storage/LogStoreAdaptor.md).

## io.delta.storage

`LogStore` is part of `io.delta.storage` package meant for Delta Lake developers.

!!! note
    There is another internal [LogStore](storage/LogStore.md) in `org.apache.spark.sql.delta.storage` package.

## Contract

### <span id="isPartialWriteVisible"> isPartialWriteVisible

```java
Boolean isPartialWriteVisible(
  Path path,
  Configuration hadoopConf)
```

Used when:

* `LogStoreAdaptor` is requested to [isPartialWriteVisible](storage/LogStoreAdaptor.md#isPartialWriteVisible)

### <span id="listFrom"> listFrom

```java
Iterator<FileStatus> listFrom(
  Path path,
  Configuration hadoopConf) throws FileNotFoundException
```

Used when:

* `LogStoreAdaptor` is requested to [listFrom](storage/LogStoreAdaptor.md#listFrom)

### <span id="read"> read

```java
CloseableIterator<String> read(
  Path path,
  Configuration hadoopConf)
```

Used when:

* `LogStoreAdaptor` is requested to [read](storage/LogStoreAdaptor.md#read) and [readAsIterator](storage/LogStoreAdaptor.md#readAsIterator)

### <span id="resolvePathOnPhysicalStorage"> resolvePathOnPhysicalStorage

```java
Path resolvePathOnPhysicalStorage(
  Path path,
  Configuration hadoopConf)
```

Used when:

* `LogStoreAdaptor` is requested to [resolvePathOnPhysicalStorage](storage/LogStoreAdaptor.md#resolvePathOnPhysicalStorage)

### <span id="write"> write

```java
void write(
  Path path,
  Iterator<String> actions,
  Boolean overwrite,
  Configuration hadoopConf) throws FileAlreadyExistsException
```

Used when:

* `LogStoreAdaptor` is requested to [write](storage/LogStoreAdaptor.md#write)

## Creating Instance

`LogStore` takes the following to be created:

* <span id="initHadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))

??? note "Abstract Class"
    `LogStore` is an abstract class and cannot be created directly. It is created indirectly for the concrete LogStores.
