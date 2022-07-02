# ParquetTable

## <span id="ConvertTargetTable"> ConvertTargetTable

`ParquetTable` is a [ConvertTargetTable](ConvertTargetTable.md).

## Creating Instance

`ParquetTable` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="basePath"> Base Path
* <span id="partitionSchema"> Partition Schema (`Option[StructType]`)

`ParquetTable` is created when:

* `ConvertToDeltaCommand` is requested to [getTargetTable](ConvertToDeltaCommand.md#getTargetTable)

## <span id="numFiles"> numFiles

```scala
numFiles: Long
```

`numFiles` [inferSchema](#inferSchema) when [_numFiles](#_numFiles) registry is uninitialized.

In the end, `numFiles` returns the value of [_numFiles](#_numFiles) registry.

`numFiles` is part of the [ConvertTargetTable](ConvertTargetTable.md#numFiles) abstraction.

### <span id="_numFiles"> _numFiles

```scala
_numFiles: Option[Long]
```

`ParquetTable` defines `_numFiles` internal registry.

`_numFiles` is `None` (uninitialized) when `ParquetTable` is [created](#creating-instance).

`_numFiles` is initialized once when `ParquetTable` is requested for the [numFiles](#numFiles) (and [inferSchema](#inferSchema)).

`_numFiles` is used for the [numFiles](#numFiles).

## <span id="inferSchema"> inferSchema

```scala
inferSchema(): Unit
```

`inferSchema`...FIXME

`inferSchema` is used when:

* `ParquetTable` is requested for the [numFiles](#numFiles) and [tableSchema](#tableSchema)

### <span id="getSchemaForBatch"> getSchemaForBatch

```scala
getSchemaForBatch(
  spark: SparkSession,
  batch: Seq[SerializableFileStatus],
  serializedConf: SerializableConfiguration): StructType
```

`getSchemaForBatch`...FIXME

### <span id="mergeSchemasInParallel"> mergeSchemasInParallel

```scala
mergeSchemasInParallel(
  sparkSession: SparkSession,
  filesToTouch: Seq[FileStatus],
  serializedConf: SerializableConfiguration): Option[StructType]
```

`mergeSchemasInParallel`...FIXME
