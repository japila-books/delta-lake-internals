= Action

`Action` is an <<contract, abstraction>> of <<implementations, metadata>> of a change to (the state of) a Delta table.

`Action` can be converted (_serialized_) to <<json, json>> format for...FIXME

[[logSchema]]
`Action` object defines `logSchema` that is a schema (`StructType`) based on the <<SingleAction.md#, SingleAction>> case class.

[source, scala]
----
import org.apache.spark.sql.delta.actions.Action.logSchema
scala> logSchema.printTreeString
root
 |-- txn: struct (nullable = true)
 |    |-- appId: string (nullable = true)
 |    |-- version: long (nullable = false)
 |    |-- lastUpdated: long (nullable = true)
 |-- add: struct (nullable = true)
 |    |-- path: string (nullable = true)
 |    |-- partitionValues: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- size: long (nullable = false)
 |    |-- modificationTime: long (nullable = false)
 |    |-- dataChange: boolean (nullable = false)
 |    |-- stats: string (nullable = true)
 |    |-- tags: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |-- remove: struct (nullable = true)
 |    |-- path: string (nullable = true)
 |    |-- deletionTimestamp: long (nullable = true)
 |    |-- dataChange: boolean (nullable = false)
 |-- metaData: struct (nullable = true)
 |    |-- id: string (nullable = true)
 |    |-- name: string (nullable = true)
 |    |-- description: string (nullable = true)
 |    |-- format: struct (nullable = true)
 |    |    |-- provider: string (nullable = true)
 |    |    |-- options: map (nullable = true)
 |    |    |    |-- key: string
 |    |    |    |-- value: string (valueContainsNull = true)
 |    |-- schemaString: string (nullable = true)
 |    |-- partitionColumns: array (nullable = true)
 |    |    |-- element: string (containsNull = true)
 |    |-- configuration: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- createdTime: long (nullable = true)
 |-- protocol: struct (nullable = true)
 |    |-- minReaderVersion: integer (nullable = false)
 |    |-- minWriterVersion: integer (nullable = false)
 |-- commitInfo: struct (nullable = true)
 |    |-- version: long (nullable = true)
 |    |-- timestamp: timestamp (nullable = true)
 |    |-- userId: string (nullable = true)
 |    |-- userName: string (nullable = true)
 |    |-- operation: string (nullable = true)
 |    |-- operationParameters: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- job: struct (nullable = true)
 |    |    |-- jobId: string (nullable = true)
 |    |    |-- jobName: string (nullable = true)
 |    |    |-- runId: string (nullable = true)
 |    |    |-- jobOwnerId: string (nullable = true)
 |    |    |-- triggerType: string (nullable = true)
 |    |-- notebook: struct (nullable = true)
 |    |    |-- notebookId: string (nullable = true)
 |    |-- clusterId: string (nullable = true)
 |    |-- readVersion: long (nullable = true)
 |    |-- isolationLevel: string (nullable = true)
 |    |-- isBlindAppend: boolean (nullable = true)
----

[[contract]]
.Action Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| wrap
a| [[wrap]]

[source, scala]
----
wrap: SingleAction
----

Wraps the action into a <<SingleAction.md#, SingleAction>> for serialization

Used when:

* `Snapshot` is created (and initializes the <<Snapshot.md#stateReconstruction, state reconstruction>> for the <<Snapshot.md#cachedState, cached state>> of a delta table)

* `Action` is requested to <<json, serialize to JSON format>>

|===

[[implementations]]
[[extensions]]
.Actions (Direct Implementations and Extensions Only)
[cols="30,70",options="header",width="100%"]
|===
| Action
| Description

| <<CommitInfo.md#, CommitInfo>>
| [[CommitInfo]]

| <<FileAction.md#, FileAction>>
| [[FileAction]]

| <<Metadata.md#, Metadata>>
| [[Metadata]]

| <<Protocol.md#, Protocol>>
| [[Protocol]]

| <<SetTransaction.md#, SetTransaction>>
| [[SetTransaction]]

|===

NOTE: `Action` is a Scala *sealed trait* which means that all the <<implementations, implementations>> are in the same compilation unit (a single file).

== [[json]] Serializing to JSON Format -- `json` Method

[source, scala]
----
json: String
----

`json` simply serializes (_converts_) the <<wrap, (wrapped) action>> to JSON format.

NOTE: `json` uses https://github.com/FasterXML/jackson[Jackson] library (with https://github.com/FasterXML/jackson-module-scala[jackson-module-scala]) as the JSON processor.

[NOTE]
====
`json` is used when:

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#doCommit, doCommit>>

* `ConvertToDeltaCommand` is requested to <<ConvertToDeltaCommand.md#streamWrite, streamWrite>>
====

== [[fromJson]] Deserializing Action (From JSON Format) -- `fromJson` Utility

[source, scala]
----
fromJson(
  json: String): Action
----

`fromJson`...FIXME

[NOTE]
====
`fromJson` is used when:

* `DeltaHistoryManager` utility is requested for the <<DeltaHistoryManager.md#getCommitInfo, CommitInfo (action) of the given delta file>>

* `DeltaLog` is requested for the <<DeltaLog.md#getChanges, changes (actions) of the given delta version and later>>

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.md#checkAndRetry, retry a commit>>
====
