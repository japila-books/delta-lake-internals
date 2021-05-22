# DeltaGenerateCommand

`DeltaGenerateCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) to [execute](#run) a [generate function](#modeName) on a [delta table](#tableId).

`DeltaGenerateCommand` is used for the following:

* [GENERATE](../../sql/index.md#GENERATE) SQL command
* [DeltaTable.generate](../../DeltaTable.md#generate) operation

`DeltaGenerateCommand` supports [symlink_format_manifest](#symlink_format_manifest) mode name only.

## Demo

```text
val path = "/tmp/delta/d01"
val tid = s"delta.`$path`"
val q = s"GENERATE symlink_format_manifest FOR TABLE $tid"
sql(q).collect
```

## Creating Instance

`DeltaGenerateCommand` takes the following to be created:

* [Mode Name](#modeName)
* <span id="tableId"> `TableIdentifier` (Spark SQL)

`DeltaGenerateCommand` is created for:

* [GENERATE](../../sql/index.md#GENERATE) SQL command (that uses `DeltaSqlAstBuilder` to [parse GENERATE SQL command](../../sql/DeltaSqlAstBuilder.md#visitGenerate))
* [DeltaTable.generate](../../DeltaTable.md#generate) operator (that uses `DeltaTableOperations` to [executeGenerate](../../DeltaTableOperations.md#executeGenerate))

## <span id="modeNameToGenerationFunc"><span id="modeName"><span id="symlink_format_manifest"> Generate Mode Name

`DeltaGenerateCommand` is given a mode name when [created](#creating-instance).

`DeltaGenerateCommand` uses a lookup table of the supported generation functions by mode name (yet supports just `symlink_format_manifest`).

Mode Name | Generation Function
--------- |----------
 `symlink_format_manifest` | [generateFullManifest](../../GenerateSymlinkManifest.md#generateFullManifest)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` creates a Hadoop `Path` to (the location of) the delta table (based on [DeltaTableIdentifier](../../DeltaTableIdentifier.md)).

`run` creates a [DeltaLog](../../DeltaLog.md#forTable) for the delta table.

`run` executes the generation function for the [mode name](#modeName).

`run` returns no rows (an empty collection).

### <span id="run-IllegalArgumentException"> IllegalArgumentException

`run` throws an `IllegalArgumentException` when executed with an unsupported [mode name](#modeName):

```text
Specified mode '[modeName]' is not supported. Supported modes are: [supportedModes]
```

### <span id="run-AnalysisException"> AnalysisException

`run` throws an `AnalysisException` when executed for a non-delta table:

```text
GENERATE is only supported for Delta tables.
```
