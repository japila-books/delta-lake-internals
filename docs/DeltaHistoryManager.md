= DeltaHistoryManager

`DeltaHistoryManager` is...FIXME

== [[getHistory]] `getHistory` Method

[source, scala]
----
getHistory(
  limitOpt: Option[Int]): Seq[CommitInfo]
getHistory(
  start: Long,
  end: Option[Long]): Seq[CommitInfo]
----

`getHistory`...FIXME

NOTE: `getHistory` is used when...FIXME

== [[getActiveCommitAtTime]] `getActiveCommitAtTime` Method

[source, scala]
----
getActiveCommitAtTime(
  timestamp: Timestamp,
  canReturnLastCommit: Boolean,
  mustBeRecreatable: Boolean = true): Commit
----

`getActiveCommitAtTime`...FIXME

NOTE: `getActiveCommitAtTime` is used exclusively when `DeltaTableUtils` utility is requested to <<DeltaTableUtils.md#resolveTimeTravelVersion, resolveTimeTravelVersion>>.

== [[checkVersionExists]] `checkVersionExists` Method

[source, scala]
----
checkVersionExists(version: Long): Unit
----

`checkVersionExists`...FIXME

NOTE: `checkVersionExists` is used when...FIXME

== [[parallelSearch]] `parallelSearch` Internal Method

[source, scala]
----
parallelSearch(
  time: Long,
  start: Long,
  end: Long): Commit
----

`parallelSearch`...FIXME

NOTE: `parallelSearch` is used exclusively when `DeltaHistoryManager` is requested to <<getActiveCommitAtTime, getActiveCommitAtTime>>.

== [[parallelSearch0]] `parallelSearch0` Internal Utility

[source, scala]
----
parallelSearch0(
  spark: SparkSession,
  conf: SerializableConfiguration,
  logPath: String,
  time: Long,
  start: Long,
  end: Long,
  step: Long): Commit
----

`parallelSearch0`...FIXME

NOTE: `parallelSearch0` is used exclusively when `DeltaHistoryManager` is requested to <<parallelSearch, parallelSearch>>.

== [[getCommitInfo]] CommitInfo Of Delta File -- `getCommitInfo` Internal Utility

[source, scala]
----
getCommitInfo(
  logStore: LogStore,
  basePath: Path,
  version: Long): CommitInfo
----

`getCommitInfo`...FIXME

NOTE: `getCommitInfo` is used when...FIXME
