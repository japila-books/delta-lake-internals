# DeltaMergeInto Logical Command

`DeltaMergeInto` is a logical `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command/)).

## Creating Instance

`DeltaMergeInto` takes the following to be created:

* <span id="target"> Target Table ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="source"> Source Table or Subquery ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="condition"> Condition Expression
* <span id="matchedClauses"> [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)s
* <span id="notMatchedClause"> Non-Matched [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md)s
* [migrateSchema](#migrateSchema) flag

When created, `DeltaMergeInto` [verifies the actions](DeltaMergeIntoClause.md#verifyActions) in the [matchedClauses](#matchedClauses) and [notMatchedClauses](#notMatchedClauses) clauses.

`DeltaMergeInto` is created (using [apply](#apply) and [resolveReferences](#resolveReferences) utilities) when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed

## Logical Resolution

`DeltaMergeInto` is resolved to [MergeIntoCommand](MergeIntoCommand.md) by [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule.

## <span id="migrateSchema"> migrateSchema Flag

`DeltaMergeInto` is given `migrateSchema` flag when [created](#creating-instance):

* [apply](#apply) uses `false` always
* [resolveReferences](#resolveReferences) is `true` only with the [spark.databricks.delta.schema.autoMerge.enabled](../../DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property enabled and `*`s only (in matched and not-matched clauses)

`migrateSchema` is used when:

* [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule is executed

## <span id="SupportsSubquery"> SupportsSubquery

`DeltaMergeInto` is a `SupportsSubquery` ([Spark SQL]({{ book.spark_sql }}/logical-operators/SupportsSubquery/))

## <span id="apply"> Creating DeltaMergeInto

```scala
apply(
  target: LogicalPlan,
  source: LogicalPlan,
  condition: Expression,
  whenClauses: Seq[DeltaMergeIntoClause]): DeltaMergeInto
```

`apply` collects [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md)s and [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)s from the given `whenClauses` and creates a `DeltaMergeInto` command (with [migrateSchema](#migrateSchema) flag off).

`apply` is used when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute) (when [mergePlan](DeltaMergeBuilder.md#mergePlan))
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (and resolves `MergeIntoTable` logical command)

### <span id="apply-AnalysisException"> AnalysisExceptions

`apply` throws an `AnalysisException` for the `whenClauses` empty:

```text
There must be at least one WHEN clause in a MERGE statement
```

`apply` throws an `AnalysisException` if there is a matched clause with no condition (except the last matched clause):

```text
When there are more than one MATCHED clauses in a MERGE statement,
only the last MATCHED clause can omit the condition.
```

`apply` throws an `AnalysisException` if there is an insert clause with no condition (except the last matched clause):

```text
When there are more than one NOT MATCHED clauses in a MERGE statement,
only the last NOT MATCHED clause can omit the condition.
```

## <span id="resolveReferencesAndSchema"> resolveReferencesAndSchema

```scala
resolveReferencesAndSchema(
  merge: DeltaMergeInto,
  conf: SQLConf)(
  resolveExpr: (Expression, LogicalPlan) => Expression): DeltaMergeInto
```

`resolveReferencesAndSchema`...FIXME

`resolveReferencesAndSchema` is used when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (to resolve `MergeIntoTable` logical command)
