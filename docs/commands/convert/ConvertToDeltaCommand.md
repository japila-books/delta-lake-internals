# ConvertToDeltaCommand (ConvertToDeltaCommandBase)

`ConvertToDeltaCommand` is a [DeltaCommand](../DeltaCommand.md) that [converts a parquet table to delta format](#run).

`ConvertToDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand/)).

`ConvertToDeltaCommand` requires that the [partition schema](#partitionSchema) matches the partitions of the [parquet table](#tableIdentifier) ([or an AnalysisException is thrown](#createAddFile-unexpectedNumPartitionColumnsFromFileNameException)).

`ConvertToDeltaCommand` saves `collectStats` in a [Convert](../../Operation.md#Convert) operation to indicate whether [collectStats](#collectStats) and [spark.databricks.delta.stats.collect](#statsEnabled) flags were both enabled.

## Creating Instance

`ConvertToDeltaCommand` takes the following to be created:

* <span id="tableIdentifier"> Table Identifier
* <span id="partitionSchema"> Partition schema (optional)
* [collectStats](#collectStats) flag
* <span id="deltaPath"> Path of the delta table (optional)

`ConvertToDeltaCommand` is created when:

* [CONVERT TO DELTA](../../sql/index.md#CONVERT-TO-DELTA) statement is used (and `DeltaSqlAstBuilder` is requested to [parse CONVERT TO DELTA statement](../../sql/DeltaSqlAstBuilder.md#visitConvert))
* [DeltaTable.convertToDelta](../../DeltaTable.md#convertToDelta) utility is used (and `DeltaConvert` is requested to [executeConvert](DeltaConvert.md#executeConvert))

### collectStats { #collectStats }

`ConvertToDeltaCommand` is given `collectStats` flag when [created](#creating-instance):

* Always `true` for [DeltaTable.convertToDelta](../../DeltaTable.md#convertToDelta) utility
* Always `true` for [CONVERT TO DELTA](../../sql/index.md#CONVERT-TO-DELTA) statement unless `NO STATISTICS` clause is used

## <span id="run"> Executing Command

??? note "Signature"

    ```scala
    run(
      spark: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) contract.

`run` [creates a ConvertProperties](#getConvertProperties) from the [TableIdentifier](#tableIdentifier) (with the given `SparkSession`).

`run` makes sure that the (data source) provider (the database part of the [TableIdentifier](#tableIdentifier)) is either `delta` or `parquet`. For all other data source providers, `run` throws an `AnalysisException`:

```text
CONVERT TO DELTA only supports parquet tables, but you are trying to convert a [sourceName] source: [ident]
```

For `delta` data source provider, `run` simply prints out the following message to standard output and returns.

```text
The table you are trying to convert is already a delta table
```

For `parquet` data source provider, `run` uses `DeltaLog` utility to [create a DeltaLog](../../DeltaLog.md#forTable). `run` then requests `DeltaLog` to [update](../../DeltaLog.md#update) and [start a new transaction](../../DeltaLog.md#startTransaction). In the end, `run` [performConvert](#performConvert).

In case the [readVersion](../../OptimisticTransactionImpl.md#readVersion) of the new transaction is greater than `-1`, `run` simply prints out the following message to standard output and returns.

```text
The table you are trying to convert is already a delta table
```

### <span id="performConvert"> performConvert

```scala
performConvert(
  spark: SparkSession,
  txn: OptimisticTransaction,
  convertProperties: ConvertTarget): Seq[Row]
```

`performConvert` makes sure that the directory exists (from the given `ConvertProperties` which is the table part of the [TableIdentifier](#tableIdentifier) of the command).

`performConvert` requests the `OptimisticTransaction` for the [DeltaLog](../../OptimisticTransaction.md#deltaLog) that is then requested to [ensureLogDirectoryExist](../../DeltaLog.md#ensureLogDirectoryExist).

`performConvert` [creates a Dataset to recursively list directories and files](../../DeltaFileOperations.md#recursiveListDirs) in the directory and leaves only files (by filtering out directories using `WHERE` clause).

!!! note
    `performConvert` uses `Dataset` API to build a distributed computation to query files.

<span id="performConvert-cache">
`performConvert` caches the `Dataset` of file names.

<span id="performConvert-schemaBatchSize">
`performConvert` uses [spark.databricks.delta.import.batchSize.schemaInference](../../configuration-properties/DeltaSQLConf.md#import.batchSize.schemaInference) configuration property for the number of files per batch for schema inference. `performConvert` [mergeSchemasInParallel](#mergeSchemasInParallel) for every batch of files and then [mergeSchemas](SchemaUtils#mergeSchemas).

`performConvert` [constructTableSchema](#constructTableSchema) using the inferred table schema and the [partitionSchema](#partitionSchema) (if specified).

`performConvert` creates a new [Metadata](../../Metadata.md) using the table schema and the [partitionSchema](#partitionSchema) (if specified).

`performConvert` requests the `OptimisticTransaction` to [update the metadata](../../OptimisticTransactionImpl.md#updateMetadata).

<span id="performConvert-statsBatchSize">
`performConvert` uses [spark.databricks.delta.import.batchSize.statsCollection](../../configuration-properties/DeltaSQLConf.md#import.batchSize.statsCollection) configuration property for the number of files per batch for stats collection. `performConvert` [creates an AddFile](#createAddFile) (in the [data path](../../DeltaLog.md#dataPath) of the [DeltaLog](../../OptimisticTransaction.md#deltaLog) of the `OptimisticTransaction`) for every file in a batch.

<span id="performConvert-streamWrite"><span id="performConvert-unpersist">
In the end, `performConvert` [streamWrite](#streamWrite) (with the `OptimisticTransaction`, the `AddFile`s, and [Convert](../../Operation.md#Convert) operation) and unpersists the `Dataset` of file names.

### <span id="checkColumnMapping"> checkColumnMapping

```scala
checkColumnMapping(
  txnMetadata: Metadata,
  convertTargetTable: ConvertTargetTable): Unit
```

`checkColumnMapping` throws a [DeltaColumnMappingUnsupportedException](../../DeltaErrors.md#convertToDeltaWithColumnMappingNotSupported) when the [requiredColumnMappingMode](ConvertTargetTable.md#requiredColumnMappingMode) of the given [ConvertTargetTable](ConvertTargetTable.md) is not [DeltaColumnMappingMode](../../Metadata.md#columnMappingMode) of the given [Metadata](../../Metadata.md).

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

`createAddFile` creates an [AddFile](../../AddFile.md) action.

Internally, `createAddFile`...FIXME

<span id="createAddFile-unexpectedNumPartitionColumnsFromFileNameException">
`createAddFile` throws an `AnalysisException` if the number of fields in the given [partition schema](#partitionSchema) does not match the number of partitions found (at partition discovery phase):

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

### createDeltaActions { #createDeltaActions }

```scala
createDeltaActions(
  spark: SparkSession,
  manifest: ConvertTargetFileManifest,
  partitionSchema: StructType,
  txn: OptimisticTransaction,
  fs: FileSystem): Iterator[AddFile]
```

`createDeltaActions`...FIXME

### getOperation { #getOperation }

```scala
getOperation(
  numFilesConverted: Long,
  convertProperties: ConvertTarget,
  sourceFormat: String): DeltaOperations.Operation
```

`getOperation` creates a [Convert](../../Operation.md#Convert) operation.

Property | Value
---------|------
 `numFiles` | [number of files in the target table](ConvertTargetTable.md#numFiles)
 `partitionBy` | [partitionSchema](#partitionSchema)
 `collectStats` | [collectStats](#collectStats) AND [spark.databricks.delta.stats.collect](#statsEnabled)
 `catalogTable` | `CatalogTable` of the given `ConvertTarget` (if defined)
 `sourceFormat` | The given `sourceFormat`

## <span id="ConvertToDeltaCommandBase"> ConvertToDeltaCommandBase

`ConvertToDeltaCommandBase` is the base of `ConvertToDeltaCommand`-like commands with the only known implementation being `ConvertToDeltaCommand` itself.

## <span id="isCatalogTable"> isCatalogTable

??? note "Signature"

    ```scala
    isCatalogTable(
      analyzer: Analyzer,
      tableIdent: TableIdentifier): Boolean
    ```

    `isCatalogTable` is part of the [DeltaCommand](../DeltaCommand.md#isCatalogTable) abstraction.

`isCatalogTable`...FIXME

## <span id="getTargetTable"> getTargetTable

```scala
getTargetTable(
  spark: SparkSession,
  target: ConvertTarget): ConvertTargetTable
```

`getTargetTable`...FIXME

---

`getTargetTable` is used when:

* `ConvertToDeltaCommandBase` is [executed](#run)

## <span id="statsEnabled"> spark.databricks.delta.stats.collect { #spark.databricks.delta.stats.collect }

```scala
statsEnabled: Boolean
```

`statsEnabled` is the value of [spark.databricks.delta.stats.collect](../../configuration-properties/index.md#DELTA_COLLECT_STATS) configuration property.

??? note "Lazy Value"
    `statsEnabled` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

---

`statsEnabled` is used when:

* `ConvertToDeltaCommandBase` is requested to [createDeltaActions](#createDeltaActions) and [getOperation](#getOperation)
