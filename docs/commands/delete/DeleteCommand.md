# DeleteCommand

`DeleteCommand` is a [DeltaCommand](../DeltaCommand.md) that represents [DeltaDelete](DeltaDelete.md) logical command at execution.

`DeleteCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand/)) logical operator.

## Creating Instance

`DeleteCommand` takes the following to be created:

* <span id="tahoeFileIndex"> [TahoeFileIndex](../../TahoeFileIndex.md)
* <span id="target"> Target Data ([LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="condition"> Condition ([Expression]({{ book.spark_sql }}/expressions/Expression/))

`DeleteCommand` is created (also using [apply](#apply) factory utility) when:

* [PreprocessTableDelete](../../PreprocessTableDelete.md) logical resolution rule is executed (and resolves a [DeltaDelete](DeltaDelete.md) logical command)

## Performance Metrics { #metrics }

??? note "Signature"

    ```scala
    metrics: Map[String, SQLMetric]
    ```

    `metrics` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#metrics)) abstraction.

`metrics` [creates the performance metrics](DeleteCommandMetrics.md#createMetrics).

## <span id="run"> Executing Command

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run` requests the [TahoeFileIndex](#tahoeFileIndex) for the [DeltaLog](../../TahoeFileIndex.md#deltaLog) (and [asserts that the table is removable](../../DeltaLog.md#assertRemovable)).

`run` requests the `DeltaLog` to [start a new transaction](../../DeltaLog.md#withNewTransaction) for [performDelete](#performDelete).

In the end, `run` re-caches all cached plans (incl. this relation itself) by requesting the `CacheManager` ([Spark SQL]({{ book.spark_sql }}/CacheManager)) to recache the [target](#target).

## performDelete { #performDelete }

```scala
performDelete(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
```

`performDelete` is used when:

* [DeleteCommand](DeleteCommand.md) is executed
* `WriteIntoDelta` is requested to [removeFiles](../WriteIntoDelta.md#removeFiles)

### <span id="performDelete-numFilesTotal"> Number of Table Files

`performDelete` requests the given [DeltaLog](../../DeltaLog.md) for the [current Snapshot](../../DeltaLog.md#snapshot) that is in turn requested for the [number of files](../../Snapshot.md#numOfFiles) in the delta table.

### <span id="performDelete-deleteActions"> Finding Delete Actions

`performDelete` branches off based on the optional [condition](#condition):

1. [No condition](#performDelete-deleteActions-condition-undefined) to delete the whole table
1. [Condition defined on metadata only](#performDelete-deleteActions-condition-metadata-only)
1. [Other conditions](#performDelete-deleteActions-condition-others)

### <span id="performDelete-deleteActions-condition-undefined"> Delete Condition Undefined

`performDelete`...FIXME

### <span id="performDelete-deleteActions-condition-metadata-only"> Metadata-Only Delete Condition

`performDelete`...FIXME

### <span id="performDelete-deleteActions-condition-others"> Other Delete Conditions

`performDelete`...FIXME

### <span id="performDelete-deleteActions-nonEmpty"> Delete Actions Available

`performDelete`...FIXME

### <span id="rewriteFiles"> rewriteFiles

```scala
rewriteFiles(
  txn: OptimisticTransaction,
  baseData: DataFrame,
  filterCondition: Expression,
  numFilesToRewrite: Long): Seq[FileAction]
```

`rewriteFiles` reads the [delta.enableChangeDataFeed](../../table-properties/DeltaConfigs.md#CHANGE_DATA_FEED) table property of the delta table (from the [Metadata](../../OptimisticTransactionImpl.md#metadata) of the given [OptimisticTransaction](../../OptimisticTransaction.md)).

`rewriteFiles` creates a `numTouchedRows` metric and a `numTouchedRowsUdf` UDF to count the number of rows that have been _touched_.

`rewriteFiles` creates a `DataFrame` to write (with the `numTouchedRowsUdf` UDF and the `filterCondition` column). The `DataFrame` can also include [_change_type](../../change-data-feed/CDCReader.md#CDC_TYPE_COLUMN_NAME) column (with `null` or `delete` values based on the `filterCondition`).

In the end, `rewriteFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [write the DataFrame](../../TransactionalWrite.md#writeFiles).

### shouldWritePersistentDeletionVectors { #shouldWritePersistentDeletionVectors }

```scala
shouldWritePersistentDeletionVectors(
  spark: SparkSession,
  txn: OptimisticTransaction): Boolean
```

`shouldWritePersistentDeletionVectors` is enabled (`true`) when the following all hold:

1. [spark.databricks.delta.delete.deletionVectors.persistent](../../configuration-properties/DeltaSQLConf.md#DELETE_USE_PERSISTENT_DELETION_VECTORS) configuration property is enabled (`true`)
1. [Protocol and table configuration support deletion vectors feature](../../deletion-vectors/DeletionVectorUtils.md#deletionVectorsWritable)

## <span id="apply"> Creating DeleteCommand

```scala
apply(
  delete: DeltaDelete): DeleteCommand
```

`apply` creates a [DeleteCommand](DeleteCommand.md).
