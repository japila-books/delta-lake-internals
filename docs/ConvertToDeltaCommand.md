# ConvertToDeltaCommand

*ConvertToDeltaCommand* is a <<DeltaCommand.adoc#, Delta command>> that <<run, converts a parquet table into delta format>> (_imports_ it into Delta).

ConvertToDeltaCommand requires that the <<partitionSchema, partition schema>> matches the partitions of the <<tableIdentifier, parquet table>> (<<createAddFile-unexpectedNumPartitionColumnsFromFileNameException, or an AnalysisException is thrown>>)

[[ConvertToDeltaCommandBase]]
`ConvertToDeltaCommandBase` is the base of ConvertToDeltaCommand-like commands with the only known implementation being <<ConvertToDeltaCommand, ConvertToDeltaCommand>> itself.

== [[creating-instance]] Creating Instance

ConvertToDeltaCommand takes the following to be created:

* [[tableIdentifier]] Parquet table (`TableIdentifier`)
* [[partitionSchema]] Partition schema (`Option[StructType]`)
* [[deltaPath]] Path (`Option[String]`)

ConvertToDeltaCommand is created and <<run, executed>> using DeltaConvert.adoc[] utility.

== [[run]] Running Command -- `run` Method

[source, scala]
----
run(spark: SparkSession): Seq[Row]
----

NOTE: `run` is part of the `RunnableCommand` contract to...FIXME.

`run` <<getConvertProperties, creates a ConvertProperties>> from the <<tableIdentifier, TableIdentifier>> (with the given `SparkSession`).

`run` makes sure that the (data source) provider (the database part of the <<tableIdentifier, TableIdentifier>>) is either `delta` or `parquet`. For all other data source providers, `run` throws an `AnalysisException`:

```
CONVERT TO DELTA only supports parquet tables, but you are trying to convert a [sourceName] source: [ident]
```

For `delta` data source provider, `run` simply prints out the following message to standard output and returns.

```
The table you are trying to convert is already a delta table
```

For `parquet` data source provider, `run` uses `DeltaLog` utility to <<DeltaLog.adoc#forTable, create a DeltaLog>>. `run` then requests `DeltaLog` to <<DeltaLog.adoc#update, update>> and <<DeltaLog.adoc#startTransaction, start a new transaction>>. In the end, `run` <<performConvert, performConvert>>.

In case the <<OptimisticTransactionImpl.adoc#readVersion, readVersion>> of the new transaction is greater than `-1`, `run` simply prints out the following message to standard output and returns.

```
The table you are trying to convert is already a delta table
```

== [[performConvert]] performConvert Method

[source, scala]
----
performConvert(
  spark: SparkSession,
  txn: OptimisticTransaction,
  convertProperties: ConvertProperties): Seq[Row]
----

performConvert makes sure that the directory exists (from the given `ConvertProperties` which is the table part of the <<tableIdentifier, TableIdentifier>> of the command).

performConvert requests the `OptimisticTransaction` for the <<OptimisticTransaction.adoc#deltaLog, DeltaLog>> that is then requested to <<DeltaLog.adoc#ensureLogDirectoryExist, ensureLogDirectoryExist>>.

performConvert <<DeltaFileOperations.adoc#recursiveListDirs, creates a Dataset to recursively list directories and files>> in the directory and leaves only files (by filtering out directories using `WHERE` clause).

NOTE: performConvert uses `Dataset` API to build a distributed computation to query files.

[[performConvert-cache]]
performConvert caches the `Dataset` of file names.

[[performConvert-schemaBatchSize]]
performConvert uses <<DeltaSQLConf.adoc#import.batchSize.schemaInference, spark.databricks.delta.import.batchSize.schemaInference>> configuration property for the number of files per batch for schema inference. performConvert <<mergeSchemasInParallel, mergeSchemasInParallel>> for every batch of files and then <<SchemaUtils#mergeSchemas, mergeSchemas>>.

performConvert <<constructTableSchema, constructTableSchema>> using the inferred table schema and the <<partitionSchema, partitionSchema>> (if specified).

performConvert creates a new <<Metadata.adoc#, Metadata>> using the table schema and the <<partitionSchema, partitionSchema>> (if specified).

performConvert requests the `OptimisticTransaction` to <<OptimisticTransactionImpl.adoc.adoc#updateMetadata, update the metadata>>.

[[performConvert-statsBatchSize]]
performConvert uses <<DeltaSQLConf.adoc#import.batchSize.statsCollection, spark.databricks.delta.import.batchSize.statsCollection>> configuration property for the number of files per batch for stats collection. performConvert <<createAddFile, creates an AddFile>> (in the <<DeltaLog.adoc#dataPath, data path>> of the <<OptimisticTransaction.adoc#deltaLog, DeltaLog>> of the `OptimisticTransaction`) for every file in a batch.

[[performConvert-streamWrite]][[performConvert-unpersist]]
In the end, performConvert <<streamWrite, streamWrite>> (with the `OptimisticTransaction`, the ``AddFile``s, and Operation.adoc#Convert[Convert] operation) and unpersists the `Dataset` of file names.

performConvert is used when ConvertToDeltaCommand is requested to <<run, run>>.

== [[streamWrite]] streamWrite Method

[source, scala]
----
streamWrite(
  spark: SparkSession,
  txn: OptimisticTransaction,
  addFiles: Iterator[AddFile],
  op: DeltaOperations.Convert): Long
----

streamWrite...FIXME

streamWrite is used when ConvertToDeltaCommand is requested to <<performConvert, performConvert>>.

== [[createAddFile]] `createAddFile` Method

[source, scala]
----
createAddFile(
  file: SerializableFileStatus,
  basePath: Path,
  fs: FileSystem,
  resolver: Resolver): AddFile
----

`createAddFile` creates an <<AddFile.adoc#, AddFile>> action.

Internally, `createAddFile`...FIXME

[[createAddFile-unexpectedNumPartitionColumnsFromFileNameException]]
`createAddFile` throws an `AnalysisException` if the number of fields in the given <<partitionSchema, partition schema>> does not match the number of partitions found (at partition discovery phase):

```
Expecting [size] partition column(s): [expectedCols], but found [size] partition column(s): [parsedCols] from parsing the file name: [path]
```

NOTE: `createAddFile` is used exclusively when ConvertToDeltaCommand is requested to <<performConvert, performConvert>> (for every data file to import).

== [[mergeSchemasInParallel]] `mergeSchemasInParallel` Method

[source, scala]
----
mergeSchemasInParallel(
  sparkSession: SparkSession,
  filesToTouch: Seq[FileStatus]): Option[StructType]
----

`mergeSchemasInParallel`...FIXME

NOTE: `mergeSchemasInParallel` is used exclusively when ConvertToDeltaCommand is requested to <<performConvert, performConvert>>.

== [[constructTableSchema]] `constructTableSchema` Method

[source, scala]
----
constructTableSchema(
  spark: SparkSession,
  dataSchema: StructType,
  partitionFields: Seq[StructField]): StructType
----

`constructTableSchema`...FIXME

NOTE: `constructTableSchema` is used exclusively when ConvertToDeltaCommand is requested to <<performConvert, performConvert>>.

== [[getConvertProperties]] Creating ConvertProperties from TableIdentifier -- `getConvertProperties` Method

[source, scala]
----
getConvertProperties(
  spark: SparkSession,
  tableIdentifier: TableIdentifier): ConvertProperties
----

`getConvertProperties` simply creates a new `ConvertProperties` with the following:

* Undefined `CatalogTable` (`None`)
* Provider name as the database of the <<tableIdentifier, TableIdentifier>>
* Target directory as the table of the <<tableIdentifier, TableIdentifier>>
* No properties

NOTE: `getConvertProperties` is used exclusively when ConvertToDeltaCommand is requested to <<run, run>>.
