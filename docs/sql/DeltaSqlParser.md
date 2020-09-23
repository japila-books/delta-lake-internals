# DeltaSqlParser

**DeltaSqlParser** is a SQL parser (Spark SQL's [ParserInterface](https://jaceklaskowski.github.io/mastering-spark-sql-book/sql/ParserInterface/)) for [Delta SQL](index.md).

`DeltaSqlParser` is registered in a Spark SQL application using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md).

## Creating Instance

`DeltaSqlParser` takes the following to be created:

* <span id="delegate"> `ParserInterface` (to fall back to for unsupported SQL)

`DeltaSqlParser` is created when `DeltaSparkSessionExtension` is requested to [register Delta SQL support](../DeltaSparkSessionExtension.md).

## <span id="builder"> DeltaSqlAstBuilder

`DeltaSqlParser` uses [DeltaSqlAstBuilder](DeltaSqlAstBuilder.md) to convert an AST to a `LogicalPlan`.
