# DeltaMergeAction

`DeltaMergeAction` is a `UnaryExpression` ([Spark SQL]({{ book.spark_sql }}/expressions/UnaryExpression)) that represents a single action in [MERGE](index.md) command.

## <span id="DeltaMergeIntoClause"> DeltaMergeIntoClause

`DeltaMergeAction`s are returned when `DeltaMergeIntoClause` is requested to [resolvedActions](DeltaMergeIntoClause.md#resolvedActions) (for [PreprocessTableMerge](../../PreprocessTableMerge.md) and [MergeIntoCommand](MergeIntoCommand.md)).

## <span id="Unevaluable"> Unevaluable

`DeltaMergeAction` is a `Unevaluable` expression that is resolved when `DeltaMergeInto` utility is used to [resolveReferencesAndSchema](DeltaMergeInto.md#resolveReferencesAndSchema).

## Creating Instance

`DeltaMergeAction` takes the following to be created:

* <span id="targetColNameParts"> Target Column Names (`Seq[String]`)
* <span id="expr"> `Expression`
* <span id="targetColNameResolved"> `targetColNameResolved` flag (default: `false`)

`DeltaMergeAction` is created when:

* `DeltaMergeIntoClause` utility is used to [toActions](DeltaMergeIntoClause.md#toActions)
* `DeltaMergeInto` utility is used to [resolveReferencesAndSchema](DeltaMergeInto.md#resolveReferencesAndSchema)
* `PreprocessTableMerge` logical resolution rule is [executed](../../PreprocessTableMerge.md#apply)
