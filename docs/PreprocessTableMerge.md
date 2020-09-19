= PreprocessTableMerge Logical Resolution Rule
:navtitle: PreprocessTableMerge

*PreprocessTableMerge* is a post-hoc logical resolution rule (`Rule[LogicalPlan]`) to <<apply, resolve DeltaMergeInto logical commands>> in a query plan into MergeIntoCommand.adoc[]s.

PreprocessTableMerge is _installed_ (injected) into a SparkSession using DeltaSparkSessionExtension.adoc[].

== [[creating-instance]][[conf]] Creating Instance

PreprocessTableMerge takes a single `SQLConf` to be created.

PreprocessTableMerge is created when:

* DeltaMergeBuilder is requested to DeltaMergeBuilder.adoc#execute[execute]

* DeltaSparkSessionExtension is requested to DeltaSparkSessionExtension.adoc#apply[register Delta SQL support]

== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

apply resolves (_replaces_) DeltaMergeInto.adoc[] logical commands (in a logical query plan) into corresponding MergeIntoCommand.adoc[]s.

apply is part of the Spark SQL's `Rule` abstraction.
