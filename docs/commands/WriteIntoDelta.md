# WriteIntoDelta Command

`WriteIntoDelta` is a [Delta command](DeltaCommand.md) that can write [data(frame)](#data) transactionally into a [delta table](#deltaLog).

`WriteIntoDelta` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) logical operator.

## Creating Instance

`WriteIntoDelta` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="mode"> `SaveMode`
* <span id="options"> [DeltaOptions](../DeltaOptions.md)
* <span id="partitionColumns"> Names of the partition columns
* [Configuration](#configuration)
* <span id="data"> Data (`DataFrame`)

`WriteIntoDelta` is created when:

* `DeltaLog` is requested to [create an insertable HadoopFsRelation](../DeltaLog.md#createRelation) (when `DeltaDataSource` is requested to create a relation as a [CreatableRelationProvider](../DeltaDataSource.md#CreatableRelationProvider) or a [RelationProvider](../DeltaDataSource.md#RelationProvider))
* `DeltaCatalog` is requested to [createDeltaTable](../DeltaCatalog.md#createDeltaTable)
* `WriteIntoDeltaBuilder` is requested to [buildForV1Write](../WriteIntoDeltaBuilder.md#buildForV1Write)
* `CreateDeltaTableCommand` command is [executed](CreateDeltaTableCommand.md#run)
* `DeltaDataSource` is requested to [create a relation (for writing)](../DeltaDataSource.md#CreatableRelationProvider-createRelation) (as a [CreatableRelationProvider](../DeltaDataSource.md#CreatableRelationProvider))

### <span id="configuration"> Configuration

`WriteIntoDelta` is given a `configuration` when [created](#creating-instance) as follows:

* Always empty for [DeltaLog](../DeltaLog.md#createRelation)
* Always empty for [DeltaDataSource](../DeltaDataSource.md#createRelation)
* Existing properties of a delta table in [DeltaCatalog](../DeltaCatalog.md#createDeltaTable) (with the `comment` key based on the value in the catalog)
* Existing [configuration](../Metadata.md#configuration) (of the [Metadata](../Snapshot.md#metadata) of the [Snapshot](../DeltaLog.md#snapshot) of the [DeltaLog](../WriteIntoDeltaBuilder.md#log)) for [WriteIntoDeltaBuilder](../WriteIntoDeltaBuilder.md#build)
* Existing properties of a delta table for [CreateDeltaTableCommand](CreateDeltaTableCommand.md) (with the `comment` key based on the value in the catalog)

## ImplicitMetadataOperation

`WriteIntoDelta` is an [operation that can update metadata (schema and partitioning)](../ImplicitMetadataOperation.md) of the [delta table](#deltaLog).

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` requests the [DeltaLog](#deltaLog) to [start a new transaction](../DeltaLog.md#withNewTransaction).

`run` [writes](#write) and requests the `OptimisticTransaction` to [commit](../OptimisticTransactionImpl.md#commit) (with `DeltaOperations.Write` operation with the [SaveMode](#mode), [partition columns](#partitionColumns), [replaceWhere](../options.md#replaceWhere) and [userMetadata](../options.md#userMetadata)).

## <span id="write"> write

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

`write` [updateMetadata](../ImplicitMetadataOperation.md#updateMetadata) (with [rearrangeOnly](../DeltaWriteOptionsImpl.md#rearrangeOnly) option).

`write`...FIXME

`write` is used when:

* [CreateDeltaTableCommand](CreateDeltaTableCommand.md) is executed
* `WriteIntoDelta` is [executed](#run)

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

```scala
canOverwriteSchema: Boolean
```

`canOverwriteSchema` is part of the [ImplicitMetadataOperation](../ImplicitMetadataOperation.md#canOverwriteSchema) abstraction.

---

`canOverwriteSchema` is `true` when all the following hold:

1. [canOverwriteSchema](../DeltaWriteOptionsImpl.md#canOverwriteSchema) is enabled (`true`) (in the [DeltaOptions](#options))
1. This `WriteIntoDelta` is [overwrite](#isOverwriteOperation) operation
1. [replaceWhere](../DeltaWriteOptions.md#replaceWhere) option is undefined (in the [DeltaOptions](#options))

## <span id="isOverwriteOperation"> isOverwriteOperation

```scala
isOverwriteOperation: Boolean
```

`isOverwriteOperation` is `true` for the [SaveMode](#mode) to be `SaveMode.Overwrite`.

* `WriteIntoDelta` is requested for the [canOverwriteSchema](#canOverwriteSchema) and to [write](#write)
