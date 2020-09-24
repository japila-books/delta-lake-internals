# DeleteCommand

`DeleteCommand` is a <<DeltaCommand.md#, Delta command>> that <<run, FIXME>>.

`DeleteCommand` is <<creating-instance, created>> (using <<apply, apply>> factory utility) and <<run, executed>> when <<DeltaTable.md#delete, DeltaTable.delete>> operator is used (indirectly through `DeltaTableOperations` when requested to <<DeltaTableOperations.md#executeDelete, execute delete command>>).

== [[creating-instance]] Creating DeleteCommand Instance

`DeleteCommand` takes the following to be created:

* [[tahoeFileIndex]] `TahoeFileIndex`
* [[target]] Target `LogicalPlan`
* [[condition]] Optional Catalyst expression

== [[apply]] Creating DeleteCommand Instance -- `apply` Factory Utility

[source, scala]
----
apply(delete: Delete): DeleteCommand
----

`apply`...FIXME

NOTE: `apply` is used when...FIXME

== [[run]] Running Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of the `RunnableCommand` contract to...FIXME.

`run` requests the <<tahoeFileIndex, TahoeFileIndex>> for the <<TahoeFileIndex.md#deltaLog, DeltaLog>>.

`run` requests the `DeltaLog` to <<DeltaLog.md#withNewTransaction, start a new transaction>> for <<performDelete, performDelete>>.

In the end, `run` re-caches all cached plans (incl. this relation itself) by requesting the `CacheManager` to recache the <<target, target LogicalPlan>>.

== [[performDelete]] `performDelete` Internal Method

[source, scala]
----
performDelete(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
----

`performDelete`...FIXME

NOTE: `performDelete` is used exclusively when `DeleteCommand` is requested to <<run, run>>.
