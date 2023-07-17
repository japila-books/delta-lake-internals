---
title: DeltaMergeIntoNotMatchedInsertClause
subtitle: WHEN NOT MATCHED THEN INSERT Clause
---

# DeltaMergeIntoNotMatchedInsertClause &mdash; WHEN NOT MATCHED THEN INSERT Clause

`DeltaMergeIntoNotMatchedInsertClause` is a [DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md) that represents `WHEN NOT MATCHED THEN INSERT` clauses in the following:

* `InsertAction` and `InsertStarAction` not-matched actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeNotMatchedActionBuilder.insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll), [DeltaMergeNotMatchedActionBuilder.insert](DeltaMergeNotMatchedActionBuilder.md#insert) and [DeltaMergeNotMatchedActionBuilder.insertExpr](DeltaMergeNotMatchedActionBuilder.md#insertExpr) operators

## Creating Instance

`DeltaMergeIntoNotMatchedInsertClause` takes the following to be created:

* <span id="condition"> (optional) Condition `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="actions"> Action `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`DeltaMergeIntoNotMatchedInsertClause` is created when:

* `DeltaMergeNotMatchedActionBuilder` is requested to [insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeNotMatchedActionBuilder.md#addInsertClause)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `InsertAction` and `InsertStarAction` not-matched actions)
