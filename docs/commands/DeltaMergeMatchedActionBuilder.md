# DeltaMergeMatchedActionBuilder

**DeltaMergeMatchedActionBuilder** is a [builder interface](#operators) for [DeltaMergeBuilder.whenMatched](DeltaMergeBuilder.md#whenMatched) operator.

## Creating Instance

`DeltaMergeMatchedActionBuilder` takes the following to be created:

* <span id="mergeBuilder"> [DeltaMergeBuilder](DeltaMergeBuilder.md)
* <span id="matchCondition"> Optional match condition

`DeltaMergeMatchedActionBuilder` is created when `DeltaMergeBuilder` is requested to [whenMatched](DeltaMergeBuilder.md#whenMatched) (using [apply](#apply) factory method).

## Operators

### <span id="delete"> delete

```scala
delete(): DeltaMergeBuilder
```

Adds a `DeltaMergeIntoDeleteClause` (with the [matchCondition](#matchCondition)) to the [DeltaMergeBuilder](#mergeBuilder).

### <span id="update"> update

```scala
update(
  set: Map[String, Column]): DeltaMergeBuilder
```

### <span id="updateAll"> updateAll

```scala
updateAll(): DeltaMergeBuilder
```

### <span id="updateExpr"> updateExpr

```scala
updateExpr(
  set: Map[String, String]): DeltaMergeBuilder
```

## <span id="apply"> Creating DeltaMergeMatchedActionBuilder

```scala
apply(
  mergeBuilder: DeltaMergeBuilder,
  matchCondition: Option[Column]): DeltaMergeMatchedActionBuilder
```

`apply` creates a `DeltaMergeMatchedActionBuilder` (for the given parameters).

`apply` is used when `DeltaMergeBuilder` is requested to [whenMatched](DeltaMergeBuilder.md#whenMatched).
