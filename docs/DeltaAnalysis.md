# DeltaAnalysis Logical Resolution Rule

`DeltaAnalysis` is a logical resolution rule ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)).

## Creating Instance

`DeltaAnalysis` takes the following to be created:

* <span id="session"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="conf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf))

`DeltaAnalysis` is created when:

* `DeltaSparkSessionExtension` is requested to [register Delta extensions](DeltaSparkSessionExtension.md)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/#apply)) abstraction.

---

`apply` resolves the following logical operators.

### <span id="AlterTableAddConstraintStatement"> AlterTableAddConstraintStatement

`apply` creates an `AlterTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTable)) logical command with an [AddConstraint](constraints/AddConstraint.md) table change.

### <span id="AlterTableDropConstraintStatement"> AlterTableDropConstraintStatement

`apply` creates an `AlterTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTable)) logical command with an [DropConstraint](constraints/DropConstraint.md) table change.

### <span id="AppendDelta"><span id="AppendData"> AppendData

For `AppendData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AppendData)), `apply` tries to [destructure it](AppendDelta.md#unapply) to a pair of `DataSourceV2Relation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/DataSourceV2Relation)) and a [DeltaTableV2](DeltaTableV2.md).

`apply` proceeds for `AppendData` operators that are not `isByName`.

`apply`...FIXME

### <span id="DataSourceV2Relation"> DataSourceV2Relation

### <span id="DeleteFromTable"> DeleteFromTable

### <span id="DeltaTable"> DeltaTable

### <span id="MergeIntoTable"> MergeIntoTable

```scala
MergeIntoTable(target, source, condition, matched, notMatched)
```

`apply` resolves `MergeIntoTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/MergeIntoTable)) logical command into a [DeltaMergeInto](commands/merge/DeltaMergeInto.md).

`apply` creates the following for the `matched` actions:

* [DeltaMergeIntoDeleteClause](commands/merge/DeltaMergeIntoDeleteClause.md)s for `DeleteAction`s
* [DeltaMergeIntoUpdateClause](commands/merge/DeltaMergeIntoUpdateClause.md)s for `UpdateAction`s

`apply` throws an `AnalysisException` for `InsertAction`s:

```text
Insert clauses cannot be part of the WHEN MATCHED clause in MERGE INTO.
```

`apply` creates the following for the `notMatched` actions:

* [DeltaMergeIntoInsertClause](commands/merge/DeltaMergeIntoInsertClause.md)s for `InsertAction`s

`apply` throws an `AnalysisException` for the other actions:

```text
[name] clauses cannot be part of the WHEN NOT MATCHED clause in MERGE INTO.
```

In the end, `apply` creates a [DeltaMergeInto](commands/merge/DeltaMergeInto.md#apply) logical command (with the matched and not-matched actions).

### <span id="OverwriteDelta"> OverwriteDelta

### <span id="UpdateTable"> UpdateTable
