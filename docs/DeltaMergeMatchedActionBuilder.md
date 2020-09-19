# DeltaMergeMatchedActionBuilder

**DeltaMergeMatchedActionBuilder** is a merge action builder for [DeltaMergeBuilder.whenMatched](DeltaMergeBuilder.md#whenMatched) operator.

```text
scala> :type mergeBuilder
io.delta.tables.DeltaMergeBuilder

val mergeMatchedBuilder = mergeBuilder.whenMatched

scala> :type mergeMatchedBuilder
io.delta.tables.DeltaMergeMatchedActionBuilder
```

== [[creating-instance]] Creating Instance

DeltaMergeMatchedActionBuilder takes the following to be created:

* [[mergeBuilder]] [DeltaMergeBuilder](DeltaMergeBuilder.md)
* [[matchCondition]] Optional match condition (`Column` expression)

DeltaMergeMatchedActionBuilder is created using <<apply, apply>> factory method.

## <span id="apply"> Creating DeltaMergeMatchedActionBuilder

```scala
apply(
  mergeBuilder: DeltaMergeBuilder,
  matchCondition: Option[Column]): DeltaMergeMatchedActionBuilder
```

`apply` creates a `DeltaMergeMatchedActionBuilder` (for the given parameters).

`apply` is used when `DeltaMergeBuilder` is requested to [whenMatched](DeltaMergeBuilder.md#whenMatched).
