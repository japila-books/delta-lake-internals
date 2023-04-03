# DeltaLogFileIndex

`DeltaLogFileIndex` is a `FileIndex` ([Spark SQL]({{ book.spark_sql }}/FileIndex)) for [Snapshot](Snapshot.md) (for the [commit](Snapshot.md#deltaFileIndexOpt) and [checkpoint](Snapshot.md#checkpointFileIndexOpt) files).

## Creating Instance

`DeltaLogFileIndex` takes the following to be created:

* [FileFormat](#format)
* <span id="files"> Files (as Hadoop [FileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)es)

While being created, `DeltaLogFileIndex` prints out the following INFO message to the logs:

```text
Created [this]
```

`DeltaLogFileIndex` is created (indirectly using [apply](#apply) utility) when `Snapshot` is requested for `DeltaLogFileIndex` for [commit](Snapshot.md#deltaFileIndexOpt) or [checkpoint](Snapshot.md#checkpointFileIndexOpt) files.

## <span id="format"> FileFormat

`DeltaLogFileIndex` is given a `FileFormat` ([Spark SQL]({{ book.spark_sql }}/FileFormat/)) when [created](#creating-instance):

* `JsonFileFormat` ([Spark SQL]({{ book.spark_sql }}/spark-sql-JsonFileFormat/)) for commit files
* `ParquetFileFormat` ([Spark SQL]({{ book.spark_sql }}/spark-sql-ParquetFileFormat/)) for checkpoint files

## <span id="toString"> Text Representation

```scala
toString: String
```

`toString` returns the following (using the given [FileFormat](#format), the number of [files](#files) and their estimated size):

```text
DeltaLogFileIndex([format], numFilesInSegment: [files], totalFileSize: [sizeInBytes])
```

## <span id="apply"> Creating DeltaLogFileIndex

```scala
apply(
  format: FileFormat,
  files: Seq[FileStatus]): Option[DeltaLogFileIndex]
```

`apply` creates a new `DeltaLogFileIndex` (for a non-empty collection of files).

`apply` is used when `Snapshot` is requested for `DeltaLogFileIndex` for [commit](Snapshot.md#deltaFileIndexOpt) or [checkpoint](Snapshot.md#checkpointFileIndexOpt) files.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.DeltaLogFileIndex` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.DeltaLogFileIndex=ALL
```

Refer to [Logging](logging.md).
