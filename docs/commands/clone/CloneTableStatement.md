# CloneTableStatement

`CloneTableStatement` is a `BinaryNode` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/#BinaryNode)) that represents [SHALLOW CLONE](../../sql/DeltaSqlAstBuilder.md#visitClone) clause in a logical query plan.

`CloneTableStatement` is resolved to [CreateDeltaTableCommand](../create-table/CreateDeltaTableCommand.md) (using [DeltaAnalysis](../../DeltaAnalysis.md#resolveCloneCommand) logical resolution rule).

## Creating Instance

`CloneTableStatement` takes the following to be created:

* <span id="source"> Source table (`LogicalPlan`)
* <span id="target"> Target table (`LogicalPlan`)
* <span id="ifNotExists"> `ifNotExists` flag
* <span id="isReplaceCommand"> `isReplaceCommand` flag
* <span id="isCreateCommand"> `isCreateCommand` flag
* <span id="tablePropertyOverrides"> Table property overrides
* <span id="targetLocation"> Target location

`CloneTableStatement` is created when:

* `DeltaSqlAstBuilder` is requested to [parse SHALLOW CLONE clause](../../sql/DeltaSqlAstBuilder.md#visitClone)
