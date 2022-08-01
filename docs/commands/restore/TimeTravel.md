# TimeTravel

`TimeTravel` is a leaf logical operator ([LeafNode]({{ book.spark_sql }}/logical-operators/LeafNode)) for [RESTORE](index.md) command to time travel the [child relation](#relation) to the given [timestamp](#timestamp) or [version](#version).

## Creating Instance

`TimeTravel` takes the following to be created:

* <span id="relation"> Relation (as a [LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="timestamp"> Timestamp ([Expression]({{ book.spark_sql }}/expressions/Expression))
* <span id="version"> Version
* [Creation Source ID](#creationSource)

`TimeTravel` is created when:

* `DeltaSqlAstBuilder` is requested to [parse RESTORE command](../../sql/DeltaSqlAstBuilder.md#maybeTimeTravelChild)
* `DeltaTableOperations` is requested to [executeRestore](../../DeltaTableOperations.md#executeRestore)
* `PreprocessTableRestore` is requested to [resolve RestoreTableStatement logical operators](../../PreprocessTableRestore.md#executeRestore)

## <span id="creationSource"> Creation Source ID

`TimeTravel` is given a **Creation Source ID** when [created](#creating-instance).

The Creation Source ID indicates the API used to time travel:

* `sql` when `DeltaSqlAstBuilder` is requested to [parse RESTORE command](../../sql/DeltaSqlAstBuilder.md#maybeTimeTravelChild)
* `deltaTable` when `DeltaTableOperations` is requested to [executeRestore](../../DeltaTableOperations.md#executeRestore)

## Analysis Phase

`TimeTravel` is resolved to [DeltaTimeTravelSpec](../../time-travel/DeltaTimeTravelSpec.md) when [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is resolving [RestoreTableStatement](RestoreTableStatement.md) unary logical operator.
