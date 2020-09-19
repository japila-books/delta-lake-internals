# UpdateCommand

`UpdateCommand` is...FIXME

== [[run]] Running Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of the `RunnableCommand` contract to...FIXME.

`run`...FIXME

== [[performUpdate]] `performUpdate` Internal Method

[source, scala]
----
performUpdate(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
----

`performUpdate`...FIXME

NOTE: `performUpdate` is used exclusively when `UpdateCommand` is requested to <<run, run>>.

== [[rewriteFiles]] `rewriteFiles` Internal Method

[source, scala]
----
rewriteFiles(
  spark: SparkSession,
  txn: OptimisticTransaction,
  rootPath: Path,
  inputLeafFiles: Seq[String],
  nameToAddFileMap: Map[String, AddFile],
  condition: Expression): Seq[AddFile]
----

`rewriteFiles`...FIXME

NOTE: `rewriteFiles` is used exclusively when `UpdateCommand` is requested to <<performUpdate, performUpdate>>.
