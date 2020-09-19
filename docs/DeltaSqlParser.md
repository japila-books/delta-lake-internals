= DeltaSqlParser

*DeltaSqlParser* is a SQL parser (Spark SQL's `ParserInterface`) for delta-sql.adoc[].

DeltaSqlParser is registered in a Spark SQL application using DeltaSparkSessionExtension.adoc[].

== [[creating-instance]] Creating Instance

DeltaSqlParser takes the following to be created:

* [[delegate]] ParserInterface (to fall back to for unsupported SQL)

DeltaSqlParser is created when DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.adoc#apply[register Delta SQL support].

== [[builder]] DeltaSqlAstBuilder

DeltaSqlParser uses DeltaSqlAstBuilder.adoc[DeltaSqlAstBuilder] for...FIXME
