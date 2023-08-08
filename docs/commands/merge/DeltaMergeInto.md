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

## Creating DeltaMergeInto { #apply }

```scala
apply(
  target: LogicalPlan,
  source: LogicalPlan,
  condition: Expression,
  whenClauses: Seq[DeltaMergeIntoClause]): DeltaMergeInto
```

`apply`...FIXME

---

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

## Resolving Merge (incl. Schema Evolution) { #resolveReferencesAndSchema }

```scala
resolveReferencesAndSchema(
  merge: DeltaMergeInto,
  conf: SQLConf)(
  resolveExpr: (Expression, LogicalPlan) => Expression): DeltaMergeInto
```

`resolveReferencesAndSchema` creates a new `DeltaMergeInto` with the following changes (compared to the given `DeltaMergeInto`):

1. The [condition](#condition), [matched](#matchedClauses), [notMatched](#notMatchedClauses) and [notMatchedBySource](#notMatchedBySourceClauses) clauses resolved
* The [migrateSchema](#migrateSchema) flag reflects [schema.autoMerge.enabled](../../configuration-properties/index.md#DELTA_SCHEMA_AUTO_MIGRATE)
* The [final schema](#finalSchema) assigned

---

`resolveReferencesAndSchema` destructures the given [DeltaMergeInto]() (skipping the [migrateSchema](#migrateSchema) and [finalSchema](#finalSchema) parts).

`resolveReferencesAndSchema` creates two artificial (_dummy_) logical plans for the [target](#target) and [source](#source) plans of the [DeltaMergeInto]() (for expression resolution of merge clauses).

`resolveReferencesAndSchema` [resolves all merge expressions](#resolveClause):

1. [condition](#condition)
1. [matchedClauses](#matchedClauses)
1. [notMatchedClauses](#notMatchedClauses) (against the `fakeSourcePlan`)
1. [notMatchedBySourceClauses](#notMatchedBySourceClauses) (against the `fakeTargetPlan`)

`resolveReferencesAndSchema` builds the [final schema](#finalSchema) (taking [schema.autoMerge.enabled](../../configuration-properties/index.md#DELTA_SCHEMA_AUTO_MIGRATE) into account).

With [schema.autoMerge.enabled](../../configuration-properties/index.md#DELTA_SCHEMA_AUTO_MIGRATE) disabled, `resolveReferencesAndSchema` uses the schema of the [target](#target) table as the [final schema](#finalSchema).

With [schema.autoMerge.enabled](../../configuration-properties/index.md#DELTA_SCHEMA_AUTO_MIGRATE) enabled, `resolveReferencesAndSchema` does the following:

1. Collects `assignments` to be the [targetColNameParts](DeltaMergeAction.md#targetColNameParts) of the [DeltaMergeAction](DeltaMergeAction.md)s (among the [actions](DeltaMergeIntoClause.md#actions)) of the [matchedClauses](#matchedClauses) and [notMatchedClauses](#notMatchedClauses)
1. Checks if there are any `UnresolvedStar`s among the [actions](DeltaMergeIntoClause.md#actions) (they are not `DeltaMergeAction`s so skipped in the step earlier) (`containsStarAction`)
1. Builds a `migrationSchema` with the [fields](#filterSchema) of the [source](#source) table that are referenced by merge clauses
1. Merges the schema of the [target](#target) table with the `migrationSchema` (allowing conversions from the types of the source type to the target's)

!!! note "Schema Evolution and Types"
    Implicit conversions are allowed, so `resolveReferencesAndSchema` can change the type of source columns to match the target's.

In the end, `resolveReferencesAndSchema` creates a new [DeltaMergeInto]().

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

### Filtering Schema { #filterSchema }

```scala
filterSchema(
  sourceSchema: StructType,
  basePath: Seq[String]): StructType
```

`filterSchema` filters the source schema to retain only fields that are referenced by a merge clause.

!!! note "Recursive Method"
    `filterSchema` is recursive so it can handle `StructType` fields.
    
    There are the following two base cases (that terminate recursion):

    1. There is an exact match (and the field is included in the final schema)
    1. A field and its children are not assigned to in any `*` or non-`*` action (and the field is skipped in the final schema)

For every field in the given `StructType`, `filterSchema` checks if the field is amongst (_referenced by_) the clause assignments and does one of the following:

1. If there is an exact match, `filterSchema` keeps the field
1. If the type of the field is a `StructType` and one of the children is assigned to in a merge clause or there is a `*` action, recursively [filterSchema](#filterSchema) with the struct and the field path
1. For non-`StructType` fields and there is a `*` action, `filterSchema` keeps the field
1. Otherwise, `filterSchema` drops (_filters out_) the field
