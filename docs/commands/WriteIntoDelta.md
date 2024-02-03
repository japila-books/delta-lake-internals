# WriteIntoDelta Command

`WriteIntoDelta` is a [delta command](DeltaCommand.md) that can write [data(frame)](#data) transactionally into a [delta table](#deltaLog).

`WriteIntoDelta` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) logical operator.

## Creating Instance

`WriteIntoDelta` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="mode"> `SaveMode`
* <span id="options"> [DeltaOptions](../spark-connector/DeltaOptions.md)
* <span id="partitionColumns"> Names of the partition columns
* [Configuration](#configuration)
* <span id="data"> Data (`DataFrame`)
* [schemaInCatalog](#schemaInCatalog)

`WriteIntoDelta` is created when:

* `DeltaDynamicPartitionOverwriteCommand` is executed
* `DeltaLog` is requested to [create an insertable HadoopFsRelation](../DeltaLog.md#createRelation) (when `DeltaDataSource` is requested to create a relation as a [CreatableRelationProvider](../spark-connector/DeltaDataSource.md#CreatableRelationProvider) or a [RelationProvider](../spark-connector/DeltaDataSource.md#RelationProvider))
* `DeltaCatalog` is requested to [create a delta table](../DeltaCatalog.md#createDeltaTable)
* `WriteIntoDeltaBuilder` is requested to [build a V1Write](../WriteIntoDeltaBuilder.md#build)
* [CreateDeltaTableCommand](create-table/CreateDeltaTableCommand.md) is executed
* `DeltaDataSource` is requested to [create a relation (for writing)](../spark-connector/DeltaDataSource.md#CreatableRelationProvider-createRelation) (as a [CreatableRelationProvider](../spark-connector/DeltaDataSource.md#CreatableRelationProvider))

### Configuration { #configuration }

`WriteIntoDelta` is given a `configuration` when [created](#creating-instance) as follows:

* Always empty for [DeltaLog](../DeltaLog.md#createRelation)
* Always empty for [DeltaDataSource](../spark-connector/DeltaDataSource.md#createRelation)
* Existing properties of a delta table in [DeltaCatalog](../DeltaCatalog.md#createDeltaTable) (with the `comment` key based on the value in the catalog)
* Existing [configuration](../Metadata.md#configuration) (of the [Metadata](../Snapshot.md#metadata) of the [Snapshot](../DeltaLog.md#snapshot) of the [DeltaLog](../WriteIntoDeltaBuilder.md#log)) for [WriteIntoDeltaBuilder](../WriteIntoDeltaBuilder.md#build)
* Existing properties of a delta table for [CreateDeltaTableCommand](create-table/CreateDeltaTableCommand.md) (with the `comment` key based on the value in the catalog)

### schemaInCatalog { #schemaInCatalog }

```scala
schemaInCatalog: Option[StructType] = None
```

`WriteIntoDelta` can be given a `StructType` ([Spark SQL]({{ book.spark_sql }}/types/StructType)) when [created](#creating-instance). Unless given, it is assumed undefined.

`schemaInCatalog` is only defined when `DeltaCatalog` is requested to [create a delta table](../DeltaCatalog.md#createDeltaTable) (yet it does not seem to be used at all).

## ImplicitMetadataOperation

`WriteIntoDelta` is an [operation that can update metadata (schema and partitioning)](../ImplicitMetadataOperation.md) of the [delta table](#deltaLog).

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` requests the [DeltaLog](#deltaLog) to [start a new transaction](../DeltaLog.md#withNewTransaction).

`run` [writes](#write) and requests the `OptimisticTransaction` to [commit](../OptimisticTransactionImpl.md#commit) (with `DeltaOperations.Write` operation with the [SaveMode](#mode), [partition columns](#partitionColumns), [replaceWhere](../spark-connector/options.md#replaceWhere) and [userMetadata](../spark-connector/options.md#userMetadata)).

## Writing Out Data { #write }

```scala
write(
  txn: OptimisticTransaction,
  sparkSession: SparkSession): Seq[Action]
```

`write` checks out whether the write operation is to a delta table that already exists. If so (i.e. the [readVersion](../OptimisticTransactionImpl.md#readVersion) of the transaction is above `-1`), `write` branches per the [SaveMode](#mode):

* For `ErrorIfExists`, `write` throws an `AnalysisException`.

    ```text
    [path] already exists.
    ```

* For `Ignore`, `write` does nothing and returns back with no [Action](../Action.md)s.

* For `Overwrite`, `write` requests the [DeltaLog](#deltaLog) to [assert being removable](../DeltaLog.md#assertRemovable)

`write` [updateMetadata](../ImplicitMetadataOperation.md#updateMetadata) (with [rearrangeOnly](../spark-connector/DeltaWriteOptionsImpl.md#rearrangeOnly) option).

`write`...FIXME

---

`write` is used the following commands are executed:

* [CreateDeltaTableCommand](create-table/CreateDeltaTableCommand.md)
* [WriteIntoDelta](#run)

### extractConstraints { #extractConstraints }

```scala
extractConstraints(
  sparkSession: SparkSession,
  expr: Seq[Expression]): Seq[Constraint]
```

For every `Expression` (in the given `expr`), `extractConstraints` checks out whether there is an `UnresolvedAttribute`. If there is one, `extractConstraints` creates a [Check](../constraints/Check.md) constraint with the following:

Property | Value
---------|------
 `name` | `EXPRESSION(expression)`
 `expression` | The `Expression` being handled

??? note "Noop with spark.databricks.delta.replaceWhere.constraintCheck.enabled disabled"
    `extractConstraints` returns no [Constraint](../constraints/Constraint.md)s for [spark.databricks.delta.replaceWhere.constraintCheck.enabled](../configuration-properties/index.md#replaceWhere.constraintCheck.enabled) disabled.

### removeFiles { #removeFiles }

```scala
removeFiles(
  spark: SparkSession,
  txn: OptimisticTransaction,
  condition: Seq[Expression]): Seq[Action]
```

`removeFiles`...FIXME

## Demo

```text
import org.apache.spark.sql.delta.commands.WriteIntoDelta
import org.apache.spark.sql.delta.DeltaLog
import org.apache.spark.sql.SaveMode
import org.apache.spark.sql.delta.DeltaOptions
val tableName = "/tmp/delta/t1"
val data = spark.range(5).toDF
val writeCmd = WriteIntoDelta(
  deltaLog = DeltaLog.forTable(spark, tableName),
  mode = SaveMode.Overwrite,
  options = new DeltaOptions(Map.empty[String, String], spark.sessionState.conf),
  partitionColumns = Seq.empty[String],
  configuration = Map.empty[String, String],
  data)

// Review web UI @ http://localhost:4040

writeCmd.run(spark)
```

## <span id="canOverwriteSchema"> canOverwriteSchema

??? note "ImplicitMetadataOperation"

    ```scala
    canOverwriteSchema: Boolean
    ```

    `canOverwriteSchema` is part of the [ImplicitMetadataOperation](../ImplicitMetadataOperation.md#canOverwriteSchema) abstraction.

`canOverwriteSchema` is `true` when all the following hold:

1. [canOverwriteSchema](../spark-connector/DeltaWriteOptionsImpl.md#canOverwriteSchema) is enabled (`true`) (in the [DeltaOptions](#options))
1. This `WriteIntoDelta` is [overwrite](#isOverwriteOperation) operation
1. [replaceWhere](../spark-connector/DeltaWriteOptions.md#replaceWhere) option is not defined (in the [DeltaOptions](#options))

## <span id="isOverwriteOperation"> isOverwriteOperation

```scala
isOverwriteOperation: Boolean
```

`isOverwriteOperation` is `true` for the [SaveMode](#mode) to be `SaveMode.Overwrite`.

`isOverwriteOperation` is used when:

* `WriteIntoDelta` is requested for the [canOverwriteSchema](#canOverwriteSchema) and to [write](#write)
