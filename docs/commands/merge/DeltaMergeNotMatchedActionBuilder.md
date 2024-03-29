---
tags:
  - DeveloperApi
---

# DeltaMergeNotMatchedActionBuilder

`DeltaMergeNotMatchedActionBuilder` is a [builder interface](#operators) for [DeltaMergeBuilder.whenNotMatched](DeltaMergeBuilder.md#whenNotMatched) operator.

## Creating Instance

`DeltaMergeNotMatchedActionBuilder` takes the following to be created:

* <span id="mergeBuilder"> [DeltaMergeBuilder](DeltaMergeBuilder.md)
* <span id="notMatchCondition"> (optional) Not-Match Condition ([Spark SQL]({{ book.spark_sql }}/Column))

`DeltaMergeNotMatchedActionBuilder` is created when:

* `DeltaMergeBuilder` is requested to [whenNotMatched](DeltaMergeBuilder.md#whenNotMatched)

## Operators

### insert { #insert }

```scala
insert(
  values: Map[String, Column]): DeltaMergeBuilder
```

`insert` [adds an insert clause](#addInsertClause) (with the `values`).

### insertAll { #insertAll }

```scala
insertAll(): DeltaMergeBuilder
```

`insertAll` requests the [DeltaMergeBuilder](#mergeBuilder) to [add](DeltaMergeBuilder.md#withClause) a new [DeltaMergeIntoNotMatchedInsertClause](DeltaMergeIntoNotMatchedInsertClause.md) (with the [notMatchCondition](#notMatchCondition), if specified).

### insertExpr { #insertExpr }

```scala
insertExpr(
  values: Map[String, String]): DeltaMergeBuilder
```

`insertExpr` [adds an insert clause](#addInsertClause) (with the `values`).

## Registering New DeltaMergeIntoNotMatchedInsertClause { #addInsertClause }

```scala
addInsertClause(
  setValues: Map[String, Column]): DeltaMergeBuilder
```

`addInsertClause` requests the [DeltaMergeBuilder](#mergeBuilder) to [register](DeltaMergeBuilder.md#withClause) a new [DeltaMergeIntoNotMatchedInsertClause](DeltaMergeIntoNotMatchedInsertClause.md) (similarly to [insertAll](#insertAll) but with the given `setValues`).

---

`addInsertClause` is used when:

* `DeltaMergeNotMatchedActionBuilder` is requested to [insert](#insert) and [insertExpr](#insertExpr)
