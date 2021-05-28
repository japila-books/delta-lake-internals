# DeltaMergeIntoInsertClause

`DeltaMergeIntoInsertClause` is a [DeltaMergeIntoClause](DeltaMergeIntoClause.md) for the following:

* `InsertAction` not-matched actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeNotMatchedActionBuilder.insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll), [DeltaMergeNotMatchedActionBuilder.insert](DeltaMergeNotMatchedActionBuilder.md#insert) and [DeltaMergeNotMatchedActionBuilder.insertExpr](DeltaMergeNotMatchedActionBuilder.md#insertExpr) operators

## Creating Instance

`DeltaMergeIntoInsertClause` takes the following to be created:

* <span id="condition"> (optional) Condition `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="actions"> Action `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`DeltaMergeIntoInsertClause` is created when:

* `DeltaMergeNotMatchedActionBuilder` is requested to [insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeNotMatchedActionBuilder.md#addInsertClause)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `InsertAction` not-matched actions)
