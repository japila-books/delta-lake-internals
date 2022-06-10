# AlterTableReplaceColumnsDeltaCommand

`AlterTableReplaceColumnsDeltaCommand` is a [AlterDeltaTableCommand](AlterDeltaTableCommand.md).

!!! danger
    `AlterTableReplaceColumnsDeltaCommand` seems to be no longer used and obsolete by [AlterTableChangeColumnDeltaCommand](AlterTableChangeColumnDeltaCommand.md) that handles all `ColumnChange`s (incl. `RenameColumn`).

## Creating Instance

`AlterTableReplaceColumnsDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="columns"> Columns (as [StructField]({{ book.spark_sql }}/types/StructField)s)

## <span id="LeafRunnableCommand"> LeafRunnableCommand

`AlterTableReplaceColumnsDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)).

## <span id="IgnoreCachedData"> IgnoreCachedData

`AlterTableReplaceColumnsDeltaCommand` is a `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData)).
