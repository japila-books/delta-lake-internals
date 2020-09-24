# PreprocessTableUpdate Logical Resolution Rule

*PreprocessTableUpdate* is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to <<apply, resolve DeltaUpdateTable logical commands>> in a query plan into UpdateCommand.md[]s.

PreprocessTableUpdate is _installed_ (injected) into a SparkSession using DeltaSparkSessionExtension.md[].

== [[creating-instance]][[conf]] Creating Instance

PreprocessTableUpdate takes a single `SQLConf` to be created.

PreprocessTableUpdate is created when DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.md#apply[register Delta SQL support].

== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

apply resolves (_replaces_) DeltaUpdateTable logical commands (in a logical query plan) into corresponding UpdateCommand.md[]s.

apply is part of the Spark SQL's `Rule` abstraction.
