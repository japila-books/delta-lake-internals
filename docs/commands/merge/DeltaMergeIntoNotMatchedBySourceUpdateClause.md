---
title: DeltaMergeIntoNotMatchedBySourceUpdateClause
subtitle: WHEN NOT MATCHED BY SOURCE THEN UPDATE Clause
---

# DeltaMergeIntoNotMatchedBySourceUpdateClause &mdash; WHEN NOT MATCHED BY SOURCE THEN UPDATE Clause

`DeltaMergeIntoNotMatchedBySourceUpdateClause` is a [DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md) that represents `WHEN NOT MATCHED BY SOURCE THEN UPDATE` clauses in the following:

* `UpdateAction` not-matched-by-source actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeMatchedActionBuilder.update](DeltaMergeMatchedActionBuilder.md#update) operator

## Creating Instance

`DeltaMergeIntoNotMatchedBySourceUpdateClause` takes the following to be created:

* [Condition](#condition)
* [Actions](#actions)

`DeltaMergeIntoNotMatchedBySourceUpdateClause` is created when:

* `DeltaMergeNotMatchedBySourceActionBuilder` is requested to [addUpdateClause](DeltaMergeNotMatchedBySourceActionBuilder.md#addUpdateClause)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `UpdateAction` not-matched-by-source actions)
