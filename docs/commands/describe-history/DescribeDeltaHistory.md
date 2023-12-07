# DescribeDeltaHistory

`DescribeDeltaHistory` is a [DeltaCommand](../DeltaCommand.md) that represents [DESCRIBE HISTORY](../../sql/index.md#DESCRIBE-HISTORY) SQL command in subqueries in a logical query plan:

```antlr
(DESC | DESCRIBE) HISTORY (path | table)
  (LIMIT limit)?
```

`DescribeDeltaHistory` is a unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan#UnaryNode)).

## Creating Instance

`DescribeDeltaHistory` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="limit"> Limit
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

* [DESCRIBE HISTORY](../../sql/index.md#DESCRIBE-HISTORY) SQL command (that uses `DeltaSqlAstBuilder` to [parse DESCRIBE HISTORY SQL command](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaHistory))

## toCommand { #toCommand }

```scala
toCommand: DescribeDeltaHistoryCommand
```

`toCommand` converts this `DescribeDeltaHistory` logical operator into a [DescribeDeltaHistoryCommand](DescribeDeltaHistoryCommand.md) executable command.

---

`toCommand` is used when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (to resolve a `DescribeDeltaHistory` logical operator)
