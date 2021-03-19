# DeltaGenerateCommandBase

`DeltaGenerateCommandBase` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) for <<implementations, runnable commands>> that <<getPath, getPath>>.

[[implementations]]
NOTE: <<DeltaGenerateCommand.md#, DeltaGenerateCommand>> is the default and only known `DeltaGenerateCommandBase` in Delta Lake.

== [[getPath]] Getting Path Of Delta Table From Table Identifier -- `getPath` Method

[source, scala]
----
getPath(
  spark: SparkSession,
  tableId: TableIdentifier): Path
----

`getPath`...FIXME

NOTE: `getPath` is used when `DeltaGenerateCommand` is requested to <<DeltaGenerateCommand.md#run, run>>.
