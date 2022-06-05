# TimeTravel

`TimeTravel` is a leaf logical operator ([LeafNode]({{ book.spark_sql }}/logical-operators/LeafNode)) to time travel the [child relation](#relation) to the given [timestamp](#timestamp) or [version](#version) (for [RESTORE](index.md) command).

## Creating Instance

`TimeTravel` takes the following to be created:

* <span id="relation"> Relation (as a [LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="timestamp"> Timestamp ([Expression]({{ book.spark_sql }}/expressions/Expression))
* <span id="version"> Version
* <span id="creationSource"> Creation Source ID

`TimeTravel` is created when:

* `DeltaSqlAstBuilder` is requested to [parse RESTORE command](../../sql/DeltaSqlAstBuilder.md#maybeTimeTravelChild)
* `DeltaTableOperations` is requested to [executeRestore](../../DeltaTableOperations.md#executeRestore)
* `PreprocessTableRestore` is requested to [resolve RestoreTableStatement logical operators](../../PreprocessTableRestore.md#executeRestore)
