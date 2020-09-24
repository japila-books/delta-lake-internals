# DeltaAnalysis Logical Resolution Rule

*DeltaAnalysis* is a logical resolution rule (Spark SQL's `Rule[LogicalPlan]`) for INSERT INTO and INSERT OVERWRITE SQL commands (and DeleteFromTable, UpdateTable, MergeIntoTable).

== [[creating-instance]] Creating Instance

DeltaAnalysis takes the following to be created:

* [[session]] SparkSession
* [[conf]] SQLConf

DeltaAnalysis is created when DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.md#apply[register Delta SQL support].

== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

apply...FIXME

apply is part of the Rule (Spark SQL) abstraction.
