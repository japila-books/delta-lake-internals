# DeltaSqlParser

`DeltaSqlParser` is a SQL parser ([Spark SQL]({{ book.spark_sql }}/sql/ParserInterface/)) for [Delta SQL](index.md).

`DeltaSqlParser` is registered in a Spark SQL application using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md).

## Creating Instance

`DeltaSqlParser` takes the following to be created:

* <span id="delegate"> Delegate `ParserInterface` ([Spark SQL]({{ book.spark_sql }}/sql/ParserInterface/)) (to fall back to for unsupported SQLs)

`DeltaSqlParser` is created when:

* `DeltaSparkSessionExtension` is requested to [register Delta SQL support](../DeltaSparkSessionExtension.md)

## <span id="builder"> DeltaSqlAstBuilder

`DeltaSqlParser` uses [DeltaSqlAstBuilder](DeltaSqlAstBuilder.md) to convert SQL statements to their runtime representation (as a `LogicalPlan`).

In case a SQL statement could not be parsed to a `LogicalPlan`, `DeltaSqlAstBuilder` requests the [delegate ParserInterface](#delegate) to handle it.
