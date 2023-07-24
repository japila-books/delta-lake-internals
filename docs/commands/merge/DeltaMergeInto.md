---
title: DeltaMergeInto
---

# DeltaMergeInto Logical Command

`DeltaMergeInto` is a logical `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command/)).

## Creating Instance

`DeltaMergeInto` takes the following to be created:

* <span id="target"> Target Table ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="source"> Source Table or Subquery ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="condition"> Condition Expression
* <span id="matchedClauses"> [DeltaMergeIntoMatchedClause](DeltaMergeIntoMatchedClause.md)s
* <span id="notMatchedClauses"> [DeltaMergeIntoNotMatchedClause](DeltaMergeIntoNotMatchedClause.md)s
* <span id="notMatchedBySourceClauses"> [DeltaMergeIntoNotMatchedBySourceClause](DeltaMergeIntoNotMatchedBySourceClause.md)s
* [migrateSchema](#migrateSchema) flag
* <span id="finalSchema"> Final schema (`StructType`)

When created, `DeltaMergeInto` [verifies the actions](DeltaMergeIntoClause.md#verifyActions) in the [matchedClauses](#matchedClauses) and [notMatchedClauses](#notMatchedClauses) clauses.

`DeltaMergeInto` is created (using [apply](#apply) and [resolveReferences](#resolveReferences) utilities) when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed

## Logical Resolution

`DeltaMergeInto` is resolved to [MergeIntoCommand](MergeIntoCommand.md) by [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule.

## migrateSchema Flag { #migrateSchema }

`DeltaMergeInto` is given `migrateSchema` flag when [created](#creating-instance):

* [apply](#apply) uses `false` always
* [resolveReferences](#resolveReferences) is `true` only with the [spark.databricks.delta.schema.autoMerge.enabled](../../configuration-properties/DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property enabled and `*`s only (in matched and not-matched clauses)

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

## resolveReferencesAndSchema { #resolveReferencesAndSchema }

```scala
resolveReferencesAndSchema(
  merge: DeltaMergeInto,
  conf: SQLConf)(
  resolveExpr: (Expression, LogicalPlan) => Expression): DeltaMergeInto
```

`resolveReferencesAndSchema` destructures the given [DeltaMergeInto](DeltaMergeInto.md) (skipping the [migrateSchema](DeltaMergeInto.md#migrateSchema) and [finalSchema](DeltaMergeInto.md#finalSchema) parts).

`resolveReferencesAndSchema` creates two artificial (_dummy_) logical plans for the [target](DeltaMergeInto.md#target) and [source](DeltaMergeInto.md#source) plans of the [DeltaMergeInto](DeltaMergeInto.md) (for expression resolution of merge clauses).

`resolveReferencesAndSchema` checks whether [Schema Merging](../../configuration-properties/index.md#schema.autoMerge.enabled) is enabled (to add new columns or nested fields that are assigned to in merge actions and not already part of the target schema).

`resolveReferencesAndSchema`...FIXME

---

`resolveReferencesAndSchema` is used when:

* `DeltaMergeBuilder` is requested to [execute](DeltaMergeBuilder.md#execute)
* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (to resolve `MergeIntoTable` logical command)

### Resolving Single Clause { #resolveClause }

```scala
resolveClause[T <: DeltaMergeIntoClause](
  clause: T,
  planToResolveAction: LogicalPlan): T
```

`resolveClause` resolves the [actions](DeltaMergeIntoClause.md#actions) of the given [DeltaMergeIntoClause](DeltaMergeIntoClause.md) (`UnresolvedStar` or [DeltaMergeAction](DeltaMergeAction.md)):

* With [Schema Merging](../../configuration-properties/index.md#schema.autoMerge.enabled) disabled, `resolveClause` expands `*`s (`UnresolvedStar`s) to the target columns with source columns resolved against the _fake_ source plan. There will be a new [DeltaMergeAction](DeltaMergeAction.md) for every column in the target plan (with [targetColNameResolved](DeltaMergeAction.md#targetColNameResolved) flag enabled)

* With [Schema Merging](../../configuration-properties/index.md#schema.autoMerge.enabled) enabled, `resolveClause` expands `*`s (`UnresolvedStar`s) differently for [WHEN NOT MATCHED THEN INSERT](DeltaMergeIntoNotMatchedInsertClause.md) and [WHEN MATCHED UPDATE](DeltaMergeIntoMatchedUpdateClause.md) clauses

* For [DeltaMergeAction](DeltaMergeAction.md)s, `resolveClause` resolves the [targetColNameParts](DeltaMergeAction.md#targetColNameParts) against the _fake_ target plan and, if failed yet [Schema Merging](../../configuration-properties/index.md#schema.autoMerge.enabled) is enabled, uses the _fake_ source plan

In the end, `resolveClause` resolves the [condition](DeltaMergeIntoClause.md#condition) of the [DeltaMergeIntoClause](DeltaMergeIntoClause.md).
