# PreprocessTableUpdate Logical Resolution Rule

*PreprocessTableUpdate* is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to <<apply, resolve DeltaUpdateTable logical commands>> in a query plan into UpdateCommand.adoc[]s.

PreprocessTableUpdate is _installed_ (injected) into a SparkSession using DeltaSparkSessionExtension.adoc[].

== [[creating-instance]][[conf]] Creating Instance

PreprocessTableUpdate takes a single `SQLConf` to be created.

PreprocessTableUpdate is created when DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.adoc#apply[register Delta SQL support].

== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

apply resolves (_replaces_) DeltaUpdateTable logical commands (in a logical query plan) into corresponding UpdateCommand.adoc[]s.

apply is part of the Spark SQL's `Rule` abstraction.
