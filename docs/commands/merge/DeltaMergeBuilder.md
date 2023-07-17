---
tags:
  - DeveloperApi
---

# DeltaMergeBuilder

`DeltaMergeBuilder` is a [builder interface](#operators) to describe how to merge data from a [source DataFrame](#source) into the [target](#targetTable) delta table (using [whenMatched](#whenMatched), [whenNotMatched](#whenNotMatched), and [whenNotMatchedBySource](#whenNotMatchedBySource) conditions).

In the end, `DeltaMergeBuilder` is supposed to be [executed](#execute) to take action. 

`DeltaMergeBuilder` creates a [DeltaMergeInto](DeltaMergeInto.md) logical command that is resolved to a [MergeIntoCommand](MergeIntoCommand.md) runnable logical command (using [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule).

## Creating Instance

`DeltaMergeBuilder` takes the following to be created:

* <span id="targetTable"> Target [DeltaTable](../../DeltaTable.md)
* <span id="source"> Source `DataFrame`
* <span id="onCondition"> Condition `Column`
* <span id="whenClauses"> [When Clauses](DeltaMergeIntoClause.md)

`DeltaMergeBuilder` is created using [DeltaTable.merge](../../DeltaTable.md#merge) operator.

## Operators

### whenMatched { #whenMatched }

```scala
whenMatched(): DeltaMergeMatchedActionBuilder
whenMatched(
  condition: Column): DeltaMergeMatchedActionBuilder
whenMatched(
  condition: String): DeltaMergeMatchedActionBuilder
```

Creates a [DeltaMergeMatchedActionBuilder](DeltaMergeMatchedActionBuilder.md) (for this `DeltaMergeBuilder` and a condition)

### whenNotMatched { #whenNotMatched }

```scala
whenNotMatched(): DeltaMergeNotMatchedActionBuilder
whenNotMatched(
  condition: Column): DeltaMergeNotMatchedActionBuilder
whenNotMatched(
  condition: String): DeltaMergeNotMatchedActionBuilder
```

Creates a [DeltaMergeNotMatchedActionBuilder](DeltaMergeNotMatchedActionBuilder.md) (for this `DeltaMergeBuilder` and a condition)

### whenNotMatchedBySource { #whenNotMatchedBySource }

```scala
whenNotMatchedBySource(): DeltaMergeNotMatchedBySourceActionBuilder
whenNotMatchedBySource(
  condition: Column): DeltaMergeNotMatchedBySourceActionBuilder
whenNotMatchedBySource(
  condition: String): DeltaMergeNotMatchedBySourceActionBuilder
```

Creates a [DeltaMergeNotMatchedBySourceActionBuilder](DeltaMergeNotMatchedBySourceActionBuilder.md) (for this `DeltaMergeBuilder` and a condition)

## Executing Merge { #execute }

```scala
execute(): Unit
```

`execute` [creates a merge plan](#mergePlan) (that is [DeltaMergeInto](DeltaMergeInto.md) logical command) and [resolves column references](DeltaMergeInto.md#resolveReferences).

`execute` runs [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule on the `DeltaMergeInto` logical command (that gives [MergeIntoCommand](MergeIntoCommand.md) runnable logical command).

In the end, `execute` executes the [MergeIntoCommand](MergeIntoCommand.md) logical command.

## <span id="mergePlan"> Creating Logical Plan for Merge

```scala
mergePlan: DeltaMergeInto
```

`mergePlan` creates a [DeltaMergeInto](DeltaMergeInto.md) logical command.

`mergePlan` is used when `DeltaMergeBuilder` is requested to [execute](#execute).

## <span id="apply"> Creating DeltaMergeBuilder

```scala
apply(
  targetTable: DeltaTable,
  source: DataFrame,
  onCondition: Column): DeltaMergeBuilder
```

`apply` utility creates a new `DeltaMergeBuilder` for the given parameters and no [DeltaMergeIntoClauses](#whenClauses).

`apply` is used for [DeltaTable.merge](../../DeltaTable.md#merge) operator.

## <span id="withClause"> Adding DeltaMergeIntoClause

```scala
withClause(
  clause: DeltaMergeIntoClause): DeltaMergeBuilder
```

`withClause` creates a new `DeltaMergeBuilder` (based on the existing properties, e.g. the [DeltaTable](#targetTable)) with the given [DeltaMergeIntoClause](DeltaMergeIntoClause.md) added to the existing [DeltaMergeIntoClauses](#whenClauses) (to create a more refined `DeltaMergeBuilder`).

`withClause` is used when:

* [DeltaMergeMatchedActionBuilder](DeltaMergeMatchedActionBuilder.md) is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [delete](DeltaMergeMatchedActionBuilder.md#delete) and [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause)
* [DeltaMergeNotMatchedActionBuilder](DeltaMergeNotMatchedActionBuilder.md) is requested to [insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeNotMatchedActionBuilder.md#addInsertClause)
