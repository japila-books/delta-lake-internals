# WriteIntoDelta Command

`WriteIntoDelta` is a [Delta command](DeltaCommand.md) that can write [data(frame)](#data) transactionally into a [delta table](#deltaLog).

`WriteIntoDelta` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)).

## Creating Instance

`WriteIntoDelta` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="mode"> `SaveMode`
* <span id="options"> [DeltaOptions](../DeltaOptions.md)
* <span id="partitionColumns"> Names of the partition columns
* <span id="configuration"> Configuration
* <span id="data"> Data (`DataFrame`)

`WriteIntoDelta` is created when:

* `DeltaLog` is requested to [create an insertable HadoopFsRelation](../DeltaLog.md#createRelation) (when `DeltaDataSource` is requested to create a relation as a [CreatableRelationProvider](../DeltaDataSource.md#CreatableRelationProvider) or a [RelationProvider](../DeltaDataSource.md#RelationProvider))
* `DeltaCatalog` is requested to [createDeltaTable](../DeltaCatalog.md#createDeltaTable)
* `WriteIntoDeltaBuilder` is requested to [buildForV1Write](../WriteIntoDeltaBuilder.md#buildForV1Write)
* `CreateDeltaTableCommand` command is [executed](CreateDeltaTableCommand.md#run)
* `DeltaDataSource` is requested to [create a relation (for writing)](../DeltaDataSource.md#CreatableRelationProvider-createRelation) (as a [CreatableRelationProvider](../DeltaDataSource.md#CreatableRelationProvider))

## ImplicitMetadataOperation

`WriteIntoDelta` is an [operation that can update metadata (schema and partitioning)](../ImplicitMetadataOperation.md) of the [delta table](#deltaLog).

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` requests the [DeltaLog](#deltaLog) to [start a new transaction](../DeltaLog.md#withNewTransaction).

`run` [writes](#write) and requests the `OptimisticTransaction` to [commit](../OptimisticTransactionImpl.md#commit) (with `DeltaOperations.Write` operation with the [SaveMode](#mode), [partition columns](#partitionColumns), [replaceWhere](../DeltaOptions.md#replaceWhere) and [userMetadata](../DeltaOptions.md#userMetadata)).

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

* `CreateDeltaTableCommand` is [executed](CreateDeltaTableCommand.md#run)
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
