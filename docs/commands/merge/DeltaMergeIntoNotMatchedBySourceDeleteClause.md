---
title: DeltaMergeIntoNotMatchedBySourceDeleteClause
subtitle: WHEN NOT MATCHED BY SOURCE THEN DELETE Clause
---

# DeltaMergeIntoNotMatchedBySourceDeleteClause &mdash; WHEN NOT MATCHED BY SOURCE THEN DELETE Clause

`DeltaMergeIntoNotMatchedBySourceDeleteClause` is a [DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md) that represents `WHEN NOT MATCHED BY SOURCE THEN DELETE` clauses in the following:

* `DeleteAction` not-matched-by-source actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeMatchedActionBuilder.delete](DeltaMergeMatchedActionBuilder.md#delete) operator

## Creating Instance

`DeltaMergeIntoNotMatchedBySourceDeleteClause` takes the following to be created:

* [Condition](#condition)

`DeltaMergeIntoNotMatchedBySourceDeleteClause` is created when:

* `DeltaMergeNotMatchedBySourceActionBuilder` is requested to [delete](DeltaMergeNotMatchedBySourceActionBuilder.md#delete)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `DeleteAction` not-matched-by-source actions)
