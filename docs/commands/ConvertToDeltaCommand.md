# ConvertToDeltaCommand

**ConvertToDeltaCommand** is a [DeltaCommand](DeltaCommand.md) that [converts a parquet table into delta format](#run) (_imports_ it into Delta).

`ConvertToDeltaCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) and executed eagerly on the driver for side-effects.

`ConvertToDeltaCommand` requires that the [partition schema](#partitionSchema) matches the partitions of the [parquet table](#tableIdentifier) ([or an AnalysisException is thrown](#createAddFile-unexpectedNumPartitionColumnsFromFileNameException))

## Creating Instance

`ConvertToDeltaCommand` takes the following to be created:

* <span id="tableIdentifier"> Parquet table (`TableIdentifier`)
* <span id="partitionSchema"> Partition schema (`Option[StructType]`)
* <span id="deltaPath"> Delta Path (`Option[String]`)

`ConvertToDeltaCommand` is created when:

* [CONVERT TO DELTA](../sql/index.md#CONVERT-TO-DELTA) statement is used (and `DeltaSqlAstBuilder` is requested to [visitConvert](../sql/DeltaSqlAstBuilder.md#visitConvert))
* [DeltaTable.convertToDelta](../DeltaTable.md#convertToDelta) utility is used (and `DeltaConvert` utility is used to [executeConvert](../DeltaConvert.md#executeConvert))

## <span id="run"> Executing Command

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` contract.

`run` <<getConvertProperties, creates a ConvertProperties>> from the <<tableIdentifier, TableIdentifier>> (with the given `SparkSession`).

`run` makes sure that the (data source) provider (the database part of the <<tableIdentifier, TableIdentifier>>) is either `delta` or `parquet`. For all other data source providers, `run` throws an `AnalysisException`:

```text
CONVERT TO DELTA only supports parquet tables, but you are trying to convert a [sourceName] source: [ident]
```

For `delta` data source provider, `run` simply prints out the following message to standard output and returns.

```text
The table you are trying to convert is already a delta table
```

For `parquet` data source provider, `run` uses `DeltaLog` utility to <<DeltaLog.md#forTable, create a DeltaLog>>. `run` then requests `DeltaLog` to <<DeltaLog.md#update, update>> and <<DeltaLog.md#startTransaction, start a new transaction>>. In the end, `run` <<performConvert, performConvert>>.

In case the <<OptimisticTransactionImpl.md#readVersion, readVersion>> of the new transaction is greater than `-1`, `run` simply prints out the following message to standard output and returns.

```text
The table you are trying to convert is already a delta table
```

## Internal Helper Methods

### <span id="performConvert"> performConvert

```scala
performConvert(
  spark: SparkSession,
  txn: OptimisticTransaction,
  convertProperties: ConvertTarget): Seq[Row]
```

`performConvert` makes sure that the directory exists (from the given `ConvertProperties` which is the table part of the <<tableIdentifier, TableIdentifier>> of the command).

`performConvert` requests the `OptimisticTransaction` for the <<OptimisticTransaction.md#deltaLog, DeltaLog>> that is then requested to <<DeltaLog.md#ensureLogDirectoryExist, ensureLogDirectoryExist>>.

`performConvert` <<DeltaFileOperations.md#recursiveListDirs, creates a Dataset to recursively list directories and files>> in the directory and leaves only files (by filtering out directories using `WHERE` clause).

NOTE: `performConvert` uses `Dataset` API to build a distributed computation to query files.

[[performConvert-cache]]
`performConvert` caches the `Dataset` of file names.

[[performConvert-schemaBatchSize]]
`performConvert` uses <<DeltaSQLConf.md#import.batchSize.schemaInference, spark.databricks.delta.import.batchSize.schemaInference>> configuration property for the number of files per batch for schema inference. `performConvert` <<mergeSchemasInParallel, mergeSchemasInParallel>> for every batch of files and then <<SchemaUtils#mergeSchemas, mergeSchemas>>.

`performConvert` <<constructTableSchema, constructTableSchema>> using the inferred table schema and the <<partitionSchema, partitionSchema>> (if specified).

`performConvert` creates a new <<Metadata.md#, Metadata>> using the table schema and the <<partitionSchema, partitionSchema>> (if specified).

`performConvert` requests the `OptimisticTransaction` to <<OptimisticTransactionImpl.md.md#updateMetadata, update the metadata>>.

[[performConvert-statsBatchSize]]
`performConvert` uses <<DeltaSQLConf.md#import.batchSize.statsCollection, spark.databricks.delta.import.batchSize.statsCollection>> configuration property for the number of files per batch for stats collection. `performConvert` <<createAddFile, creates an AddFile>> (in the <<DeltaLog.md#dataPath, data path>> of the <<OptimisticTransaction.md#deltaLog, DeltaLog>> of the `OptimisticTransaction`) for every file in a batch.

[[performConvert-streamWrite]][[performConvert-unpersist]]
In the end, `performConvert` <<streamWrite, streamWrite>> (with the `OptimisticTransaction`, the ``AddFile``s, and Operation.md#Convert[Convert] operation) and unpersists the `Dataset` of file names.

### <span id="streamWrite"> streamWrite

```scala
streamWrite(
  spark: SparkSession,
  txn: OptimisticTransaction,
  addFiles: Iterator[AddFile],
  op: DeltaOperations.Operation,
  numFiles: Long): Long
```

`streamWrite`...FIXME

### <span id="createAddFile"> createAddFile

```scala
createAddFile(
  file: SerializableFileStatus,
  basePath: Path,
  fs: FileSystem,
  conf: SQLConf): AddFile
```

`createAddFile` creates an [AddFile](../AddFile.md) action.

Internally, `createAddFile`...FIXME

<span id="createAddFile-unexpectedNumPartitionColumnsFromFileNameException">
`createAddFile` throws an `AnalysisException` if the number of fields in the given <<partitionSchema, partition schema>> does not match the number of partitions found (at partition discovery phase):

```text
Expecting [size] partition column(s): [expectedCols], but found [size] partition column(s): [parsedCols] from parsing the file name: [path]
```

### <span id="mergeSchemasInParallel"> mergeSchemasInParallel

```scala
mergeSchemasInParallel(
  sparkSession: SparkSession,
  filesToTouch: Seq[FileStatus],
  serializedConf: SerializableConfiguration): Option[StructType]
```

`mergeSchemasInParallel`...FIXME

### <span id="constructTableSchema"> constructTableSchema

```scala
constructTableSchema(
  spark: SparkSession,
  dataSchema: StructType,
  partitionFields: Seq[StructField]): StructType
```

`constructTableSchema`...FIXME

## <span id="ConvertToDeltaCommandBase"> ConvertToDeltaCommandBase

`ConvertToDeltaCommandBase` is the base of `ConvertToDeltaCommand`-like commands with the only known implementation being `ConvertToDeltaCommand` itself.
