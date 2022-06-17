# AppendDelta Scala Extractor

`AppendDelta` is a Scala extractor for [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule to analyze `AppendData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AppendData)) logical operators and [destructure them](#unapply) into a pair of the following:

* `DataSourceV2Relation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/DataSourceV2Relation))
* [DeltaTableV2](DeltaTableV2.md)

## <span id="unapply"> Destructuring AppendData

```scala
unapply(
  a: AppendData): Option[(DataSourceV2Relation, DeltaTableV2)]
```

`unapply` requests the given `AppendData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AppendData)) logical operator for the query. If resolved, `unapply` requests the `AppendData` for the table (as a [NamedRelation]({{ book.spark_sql }}/logical-operators/NamedRelation)). If the table is a `DataSourceV2Relation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/DataSourceV2Relation)) that is also a [DeltaTableV2](DeltaTableV2.md), `unapply` returns the `DataSourceV2Relation` and the `DeltaTableV2`.

For all other cases, `unapply` returns `None` (and destructures nothing).

`unapply` is used when:

* [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule is executed (to resolve [AppendDelta](DeltaAnalysis.md#AppendDelta)) logical operator)
