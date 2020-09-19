= StagedDeltaTableV2

*StagedDeltaTableV2* is a StagedTable and a SupportsWrite (both from Spark SQL 3.0.0).

== [[creating-instance]] Creating Instance

StagedDeltaTableV2 takes the following to be created:

* [[ident]] Identifier
* [[schema]] Schema
* [[partitions]] Partitions (`Array[Transform]`)
* [[properties]] Properties
* [[operation]] Operation (one of Create, CreateOrReplace, Replace)

StagedDeltaTableV2 is created when DeltaCatalog is requested to DeltaCatalog.adoc#stageReplace[stageReplace], DeltaCatalog.adoc#stageCreateOrReplace[stageCreateOrReplace] or DeltaCatalog.adoc#stageCreate[stageCreate].

== [[commitStagedChanges]] commitStagedChanges

[source,scala]
----
commitStagedChanges(): Unit
----

commitStagedChanges...FIXME

commitStagedChanges is part of the StagedTable (Spark SQL 3.0.0) abstraction.

== [[abortStagedChanges]] abortStagedChanges

[source,scala]
----
abortStagedChanges(): Unit
----

abortStagedChanges does nothing.

abortStagedChanges is part of the StagedTable (Spark SQL 3.0.0) abstraction.

== [[newWriteBuilder]] newWriteBuilder

[source,scala]
----
newWriteBuilder(
  info: LogicalWriteInfo): V1WriteBuilder
----

newWriteBuilder...FIXME

newWriteBuilder is part of the SupportsWrite (Spark SQL 3.0.0) abstraction.
