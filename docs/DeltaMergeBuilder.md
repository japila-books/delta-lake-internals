# DeltaMergeBuilder

**DeltaMergeBuilder** is a [builder interface](#operators) to describe how to merge data from a [source DataFrame](#source) into the [target](#targetTable) delta table.

## Creating Instance

`DeltaMergeBuilder` takes the following to be created:

* <span id="targetTable"> Target [DeltaTable](DeltaTable.md)
* <span id="source"> Source `DataFrame`
* <span id="onCondition"> Condition `Column`
* <span id="whenClauses"> [When Clauses](DeltaMergeIntoClause.md)

`DeltaMergeBuilder` is created using [DeltaTable.merge](DeltaTable.md#merge) operator.

## Operators

### <span id="whenMatched"> whenMatched

```scala
whenMatched(): DeltaMergeMatchedActionBuilder
whenMatched(
  condition: Column): DeltaMergeMatchedActionBuilder
whenMatched(
  condition: String): DeltaMergeMatchedActionBuilder
```

Creates a [DeltaMergeMatchedActionBuilder](DeltaMergeMatchedActionBuilder.md) (for the `DeltaMergeBuilder` and a condition)

### <span id="whenNotMatched"> whenNotMatched

```scala
whenNotMatched(): DeltaMergeNotMatchedActionBuilder
whenNotMatched(
  condition: Column): DeltaMergeNotMatchedActionBuilder
whenNotMatched(
  condition: String): DeltaMergeNotMatchedActionBuilder
```

Creates a [DeltaMergeNotMatchedActionBuilder](DeltaMergeNotMatchedActionBuilder.md) (for the `DeltaMergeBuilder` and a condition)

## <span id="execute"> Executing Merge

```scala
execute(): Unit
```

`execute` resolves column references and creates a [DeltaMergeInto](DeltaMergeInto.md) logical command.

`execute` creates and executes a [PreprocessTableMerge](PreprocessTableMerge.md) logical resolution rule with the `DeltaMergeInto` logical command (that creates a [MergeIntoCommand](MergeIntoCommand.md) runnable logical command).

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

`apply` creates a new `DeltaMergeBuilder` for the given parameters and no [DeltaMergeIntoClauses](#whenClauses).

`apply` is used for [DeltaTable.merge](DeltaTable.md#merge) operator.

## <span id="withClause"> Adding DeltaMergeIntoClause

```scala
withClause(
  clause: DeltaMergeIntoClause): DeltaMergeBuilder
```

`withClause` creates a new `DeltaMergeBuilder` (based on the existing properties, e.g. the [DeltaTable](#targetTable)) with the given [DeltaMergeIntoClause](DeltaMergeIntoClause.md) added to the existing [DeltaMergeIntoClauses](#whenClauses) (to create a more refined `DeltaMergeBuilder`).

`withClause` is used when:

* [DeltaMergeMatchedActionBuilder](DeltaMergeMatchedActionBuilder.md) is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [delete](DeltaMergeMatchedActionBuilder.md#delete) and [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause)
* [DeltaMergeNotMatchedActionBuilder](DeltaMergeNotMatchedActionBuilder.md) is requested to [insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeNotMatchedActionBuilder.md#addInsertClause)
