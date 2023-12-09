---
title: DescribeDeltaHistory
---

# DescribeDeltaHistory Unary Logical Operator

`DescribeDeltaHistory` is a [DeltaCommand](../DeltaCommand.md) that represents [DESCRIBE HISTORY](../../sql/index.md#describe-history) SQL command.

`DescribeDeltaHistory` is [resolved into](#toCommand) a [DescribeDeltaHistoryCommand](DescribeDeltaHistoryCommand.md) at [analysis](../../DeltaAnalysis.md).

`DescribeDeltaHistory` is a unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan#UnaryNode)).

!!! note
    There's a comment in the [source code]({{ delta.github }}/spark/src/main/scala/org/apache/spark/sql/delta/commands/DescribeDeltaHistoryCommand.scala#L56-L57) of `DescribeDeltaHistory` that says:

    > A logical placeholder for describing a Delta table's history, so that the history can be leveraged in subqueries.

    [It is not available in the OSS version of Delta Lake](https://twitter.com/jaceklaskowski/status/1733466666749526278), though. Sorry 🤷

## Creating Instance

`DescribeDeltaHistory` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="limit"> History Limit
* <span id="output"> Output Schema Attributes

`DescribeDeltaHistory` is created using [apply](#apply) factory method.

### Creating DescribeDeltaHistory { #apply }

```scala
apply(
  path: Option[String],
  tableIdentifier: Option[TableIdentifier],
  limit: Option[Int]): DescribeDeltaHistory
```

`apply` creates a [DescribeDeltaHistory](DescribeDeltaHistory.md) with a `UnresolvedDeltaPathOrIdentifier` (with the given `path` and `tableIdentifier`).

---

`apply` is used for:

* [DESCRIBE HISTORY](../../sql/index.md#describe-history) SQL command (that uses `DeltaSqlAstBuilder` to [parse DESCRIBE HISTORY SQL command](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaHistory))

## toCommand { #toCommand }

```scala
toCommand: DescribeDeltaHistoryCommand
```

`toCommand` converts this `DescribeDeltaHistory` logical operator into a [DescribeDeltaHistoryCommand](DescribeDeltaHistoryCommand.md) executable command.

---

`toCommand` is used when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (to resolve a `DescribeDeltaHistory` logical operator)
