# AlterTableChangeColumnDeltaCommand

`AlterTableChangeColumnDeltaCommand` is an [AlterDeltaTableCommand](AlterDeltaTableCommand.md) to change (_alter_) the name, the comment, the nullability, the position and the data type of a [column](#columnName) (of a [DeltaTableV2](#table)).

`AlterTableChangeColumnDeltaCommand` is used when [DeltaCatalog.alterTable](../../DeltaCatalog.md#alterTable) is requested to execute the following `TableChange`s (that are all `ColumnChange`s).

ColumnChange | SQL
-------------|----------
 `RenameColumn` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableChange/#RenameColumn)) | `ALTER TABLE RENAME COLUMN` ([Spark SQL]({{ book.spark_sql }}/sql/AstBuilder#visitRenameTableColumn))
 `UpdateColumnComment` |
 `UpdateColumnNullability` |
 `UpdateColumnPosition` |
 `UpdateColumnType` |

## Creating Instance

`AlterTableChangeColumnDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="columnPath"> Column Path
* <span id="columnName"> Column Name
* <span id="newColumn"> New Column (as [StructField]({{ book.spark_sql }}/types/StructField))
* <span id="colPosition"> `ColumnPosition` (optional)
* <span id="syncIdentity"> (_unused_) `syncIdentity` flag

`AlterTableChangeColumnDeltaCommand` is created when:

* `DeltaCatalog` is requested to [alter a table](../../DeltaCatalog.md#alterTable)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` [starts a transaction](AlterDeltaTableCommand.md#startTransaction).

`run`...FIXME

`run` requests the `OptimisticTransaction` to [update the Metadata](../../OptimisticTransactionImpl.md#updateMetadata) (with the new `newMetadata`).

In the end, `run` requests the `OptimisticTransaction` to [commit](../../OptimisticTransactionImpl.md#commit) (with no [Action](../../Action.md)s and [ChangeColumn](../../Operation.md#ChangeColumn) operation).

---

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

## <span id="LeafRunnableCommand"> LeafRunnableCommand

`AlterTableChangeColumnDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)).

## <span id="IgnoreCachedData"> IgnoreCachedData

`AlterTableChangeColumnDeltaCommand` is a `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData)).
