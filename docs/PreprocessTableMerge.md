# PreprocessTableMerge Logical Resolution Rule

*PreprocessTableMerge* is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to <<apply, resolve DeltaMergeInto logical commands>> in a query plan into MergeIntoCommand.md[]s.

PreprocessTableMerge is _installed_ (injected) into a SparkSession using DeltaSparkSessionExtension.md[].

== [[creating-instance]][[conf]] Creating Instance

PreprocessTableMerge takes a single `SQLConf` to be created.

PreprocessTableMerge is created when:

* [DeltaMergeBuilder](commands/DeltaMergeBuilder.md) is executed

* DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.md#apply[register Delta SQL support]

== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

apply resolves (_replaces_) DeltaMergeInto.md[] logical commands (in a logical query plan) into corresponding MergeIntoCommand.md[]s.

apply is part of the Spark SQL's `Rule` abstraction.
