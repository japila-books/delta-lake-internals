# DeltaMergeIntoUpdateClause

`DeltaMergeIntoUpdateClause` is a [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md) for the following:

* `UpdateAction` matched actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeMatchedActionBuilder.updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [DeltaMergeMatchedActionBuilder.update](DeltaMergeMatchedActionBuilder.md#update) and [DeltaMergeMatchedActionBuilder.updateExpr](DeltaMergeMatchedActionBuilder.md#updateExpr) operators

## Creating Instance

`DeltaMergeIntoUpdateClause` takes the following to be created:

* <span id="condition"> (optional) Condition `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="actions"> Action `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`DeltaMergeIntoUpdateClause` is created when:

* `DeltaMergeMatchedActionBuilder` is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll) and [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `UpdateAction` matched actions)
