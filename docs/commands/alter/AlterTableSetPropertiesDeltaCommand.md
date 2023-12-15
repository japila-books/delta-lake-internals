# AlterTableSetPropertiesDeltaCommand

`AlterTableSetPropertiesDeltaCommand` is a transactional [AlterDeltaTableCommand](AlterDeltaTableCommand.md) for `SetProperty` table changes (when [altering a delta table](../../DeltaCatalog.md#alterTable)).

`AlterTableSetPropertiesDeltaCommand` represents `ALTER TABLE SET TBLPROPERTIES` SQL command.

## Creating Instance

`AlterTableSetPropertiesDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="configuration"> Configuration (`Map[String, String]`)

`AlterTableSetPropertiesDeltaCommand` is created when:

* `DeltaCatalog` is requested to [alterTable](../../DeltaCatalog.md#alterTable) (with `SetProperty` table changes)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

### <span id="run-startTransaction"> Begin Transaction

`run` [starts a transaction](AlterDeltaTableCommand.md#startTransaction).

### <span id="run-updateMetadata"> Update Metadata

`run` requests the transaction for the [table metadata](../../OptimisticTransactionImpl.md#metadata) and does sanity check to prevent illegal changes (on reserved properties):

* Throws `AnalysisException`s for the following:
    * `delta.constraints.`-prefixed properties (handled by [ALTER TABLE ADD CONSTRAINT](AlterTableAddConstraintDeltaCommand.md))
    * `location`
    * `provider`
* Filters out `comment` property changes (as it is used later for the [description](../../Metadata.md#description))

`run` creates a new [Metadata](../../Metadata.md) with the following:

* Overwrites [description](../../Metadata.md#description) with `comment` property if defined in the given [configuration](#configuration)
* Overwrites the current [configuration](../../Metadata.md#configuration) of the delta table with the property changes

`run` [updates the metadata](../../OptimisticTransactionImpl.md#updateMetadata) (of the transaction).

### <span id="run-commit"> Commit Transaction

`run` [commits](../../OptimisticTransactionImpl.md#commit) the transaction with `SET TBLPROPERTIES` operation (with the given [configuration](#configuration)) and no actions.

In the end, `run` returns an empty collection.

## <span id="RunnableCommand"> RunnableCommand

`AlterTableSetPropertiesDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) logical operator.

## <span id="IgnoreCachedData"> IgnoreCachedData

`AlterTableSetPropertiesDeltaCommand` is a `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData/)) logical operator.

## Demo

```scala
sql("""
DROP TABLE IF EXISTS delta_demo;
""")
```

```scala
sql("""
CREATE TABLE delta_demo (id INT)
USING delta;
""")
```

```scala
sql("""
DESC HISTORY delta_demo;
""")
  .select('version, 'operation, 'operationParameters)
  .show(truncate = false)
```

```text
+-------+------------+-----------------------------------------------------------------------------+
|version|operation   |operationParameters                                                          |
+-------+------------+-----------------------------------------------------------------------------+
|0      |CREATE TABLE|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|
+-------+------------+-----------------------------------------------------------------------------+
```

```scala
sql("""
ALTER TABLE delta_demo
SET TBLPROPERTIES (delta.enableChangeDataFeed = true);
""")
```

```scala
sql("""
DESC HISTORY delta_demo;
""")
  .select('version, 'operation, 'operationParameters)
  .show(truncate = false)
```

```text
+-------+-----------------+-----------------------------------------------------------------------------+
|version|operation        |operationParameters                                                          |
+-------+-----------------+-----------------------------------------------------------------------------+
|1      |SET TBLPROPERTIES|{properties -> {"delta.enableChangeDataFeed":"true"}}                        |
|0      |CREATE TABLE     |{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|
+-------+-----------------+-----------------------------------------------------------------------------+
```
