= DeltaGenerateCommandBase

`DeltaGenerateCommandBase` is an extension of the `RunnableCommand` contract (from Spark SQL) for <<implementations, runnable commands>> that <<getPath, getPath>>.

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-LogicalPlan-RunnableCommand.html[RunnableCommand] in https://bit.ly/spark-sql-internals[The Internals of Spark SQL] online book.

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
