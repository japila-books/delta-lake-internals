---
title: DeltaMergeIntoMatchedUpdateClause
subtitle: WHEN MATCHED THEN UPDATE Clause
---

# DeltaMergeIntoMatchedUpdateClause &mdash; WHEN MATCHED THEN UPDATE Clause

`DeltaMergeIntoMatchedUpdateClause` is a [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md) that represents `WHEN MATCHED THEN UPDATE` clauses in the following:

* `UpdateAction` and `UpdateStarAction` matched actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeMatchedActionBuilder.updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [DeltaMergeMatchedActionBuilder.update](DeltaMergeMatchedActionBuilder.md#update) and [DeltaMergeMatchedActionBuilder.updateExpr](DeltaMergeMatchedActionBuilder.md#updateExpr) operators

## Creating Instance

`DeltaMergeIntoMatchedUpdateClause` takes the following to be created:

* [Condition](#condition)
* [Actions](#actions)

`DeltaMergeIntoMatchedUpdateClause` is created when:

* `DeltaMergeMatchedActionBuilder` is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll) and [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `UpdateAction` and `UpdateStarAction` matched actions)

### Actions

??? note "DeltaMergeIntoClause"

    ```scala
    actions: Seq[Expression]
    ```

    `actions` is part of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md#actions) abstraction.

`DeltaMergeIntoMatchedUpdateClause` is given `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) for the actions when [created](#creating-instance).

### Condition

??? note "DeltaMergeIntoClause"

    ```scala
    condition: Option[Expression]
    ```

    `condition` is part of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md#condition) abstraction.

`DeltaMergeIntoMatchedUpdateClause` can be given `Expression`s ([Spark SQL]({{ book.spark_sql }}/expressions/Expression)) for the condition when [created](#creating-instance).

## Clause Type { #clauseType }

??? note "DeltaMergeIntoClause"

    ```scala
    clauseType: String
    ```

    `clauseType` is part of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md#clauseType) abstraction.

`clauseType` is the following text:

```text
Update
```
