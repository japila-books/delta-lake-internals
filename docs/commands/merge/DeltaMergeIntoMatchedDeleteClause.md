# DeltaMergeIntoMatchedDeleteClause

`DeltaMergeIntoMatchedDeleteClause` is a [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md) for the following:

* `DeleteAction` matched actions in `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command
* [DeltaMergeMatchedActionBuilder.delete](DeltaMergeMatchedActionBuilder.md#delete) operator

## Creating Instance

`DeltaMergeIntoMatchedDeleteClause` takes the following to be created:

* <span id="condition"> (optional) Condition `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`DeltaMergeIntoMatchedDeleteClause` is created when:

* `DeltaMergeMatchedActionBuilder` is requested to [delete](DeltaMergeMatchedActionBuilder.md#delete)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command with `DeleteAction` matched actions)
* `MergeIntoCommandBase` is requested to [isOnlyOneUnconditionalDelete](MergeIntoCommandBase.md#isOnlyOneUnconditionalDelete)

## actions

??? note "DeltaMergeIntoClause"

    ```scala
    actions: Seq[Expression]
    ```

    `actions` is part of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md#actions) abstraction.

`actions` is always an empty collection.

## clauseType { #clauseType }

??? note "DeltaMergeIntoClause"

    ```scala
    clauseType: String
    ```

    `clauseType` is part of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md#clauseType) abstraction.

`clauseType` is the following text:

```text
Delete
```
