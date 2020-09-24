# PreprocessTableDelete Logical Resolution Rule

**PreprocessTableDelete** is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to <<apply, resolve DeltaDelete logical commands>> in a query plan into DeleteCommand.md[]s.

PreprocessTableDelete is _installed_ (injected) into a SparkSession using DeltaSparkSessionExtension.md[].

== [[creating-instance]][[conf]] Creating Instance

PreprocessTableDelete takes a single `SQLConf` to be created.

PreprocessTableDelete is created when DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.md#apply[register Delta SQL support].

== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

apply resolves (_replaces_) DeltaDelete logical commands (in a logical query plan) into corresponding DeleteCommand.md[]s.

apply is part of the Spark SQL's `Rule` abstraction.
