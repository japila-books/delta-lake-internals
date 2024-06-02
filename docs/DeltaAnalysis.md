---
title: DeltaAnalysis
---

# DeltaAnalysis Logical Resolution Rule

`DeltaAnalysis` is a logical resolution rule ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)).

## Creating Instance

`DeltaAnalysis` takes the following to be created:

* <span id="session"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`DeltaAnalysis` is created when:

* `DeltaSparkSessionExtension` is requested to [register Delta Lake-specific session extensions](DeltaSparkSessionExtension.md)

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/#apply)) abstraction.

`apply` resolves the following logical operators.

### <span id="AppendDelta"> AppendData { #AppendData }

For `AppendData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AppendData)), `apply` tries to [destructure it](AppendDelta.md#unapply) to a pair of `DataSourceV2Relation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/DataSourceV2Relation)) and a [DeltaTableV2](DeltaTableV2.md).

`apply` proceeds for `AppendData` operators that are not `isByName`.

`apply`...FIXME

### CloneTableStatement { #CloneTableStatement }

#### resolveCloneCommand { #resolveCloneCommand }

```scala
resolveCloneCommand(
  targetPlan: LogicalPlan,
  sourceTbl: CloneSource,
  statement: CloneTableStatement): LogicalPlan
```

`resolveCloneCommand` determines the `SaveMode` (in the following order):

* `Overwrite` for [isReplaceCommand](commands/clone/CloneTableStatement.md#isReplaceCommand)
* `Ignore` for [ifNotExists](commands/clone/CloneTableStatement.md#ifNotExists)
* `ErrorIfExists` for all other cases

In the end, `resolveCloneCommand` creates a [CreateDeltaTableCommand](commands/create-table/CreateDeltaTableCommand.md) logical operator.

### CreateTableLikeCommand { #CreateTableLikeCommand }

### DataSourceV2Relation { #DataSourceV2Relation }

### DeleteFromTable { #DeleteFromTable }

### DeltaMergeInto { #DeltaMergeInto }

### DeltaReorgTable { #DeltaReorgTable }

### DeltaTable { #DeltaTable }

### DeltaTableValueFunction { #DeltaTableValueFunction }

### MergeIntoTable { #MergeIntoTable }

`apply` resolves `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command into a [DeltaMergeInto](commands/merge/DeltaMergeInto.md).

`apply` creates the following for the `WHEN MATCHED` actions:

* [DeltaMergeIntoMatchedDeleteClause](commands/merge/DeltaMergeIntoMatchedDeleteClause.md)s for `DeleteAction`s
* [DeltaMergeIntoMatchedUpdateClause](commands/merge/DeltaMergeIntoMatchedUpdateClause.md)s for `UpdateAction`s and `UpdateStarAction`s

`apply` throws an `AnalysisException` for other actions:

```text
[name] clauses cannot be part of the WHEN MATCHED clause in MERGE INTO.
```

`apply` creates the following for the `WHEN NOT MATCHED` actions:

* [DeltaMergeIntoNotMatchedInsertClause](commands/merge/DeltaMergeIntoNotMatchedInsertClause.md)s for `InsertAction`s and `InsertStarAction`s

`apply` throws an `AnalysisException` for other actions:

```text
[name] clauses cannot be part of the WHEN NOT MATCHED clause in MERGE INTO.
```

`apply` creates the following for the `WHEN NOT MATCHED BY SOURCE` clauses:

* [DeltaMergeIntoNotMatchedBySourceDeleteClause](commands/merge/DeltaMergeIntoNotMatchedBySourceDeleteClause.md)s for `DeleteAction`s
* [DeltaMergeIntoNotMatchedBySourceUpdateClause](commands/merge/DeltaMergeIntoNotMatchedBySourceUpdateClause.md)s for `UpdateAction`s

`apply` throws an `AnalysisException` for other actions:

```text
[name] clauses cannot be part of the WHEN NOT MATCHED BY SOURCE clause in MERGE INTO.
```

In the end, `apply` creates a [DeltaMergeInto](commands/merge/DeltaMergeInto.md#apply) logical command (with the matched and not-matched actions).

### <span id="OverwriteDelta"> OverwriteByExpression { #OverwriteByExpression }

### <span id="DynamicPartitionOverwriteDelta"> OverwritePartitionsDynamic { #OverwritePartitionsDynamic }

### RestoreTableStatement { #RestoreTableStatement }

### UnresolvedPathBasedDeltaTable { #UnresolvedPathBasedDeltaTable }

### UpdateTable { #UpdateTable }

### WriteToStream { #WriteToStream }
