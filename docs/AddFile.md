# AddFile

`AddFile` is a <<FileAction.md#, file action>> to denote a <<path, file>> added to a <<DeltaLog.md#, delta table>>.

`AddFile` is <<creating-instance, created>> when:

* <<ConvertToDeltaCommand.md#, ConvertToDeltaCommand>> is executed (for <<ConvertToDeltaCommand.md#createAddFile, every data file to import>>)

* `DelayedCommitProtocol` is requested to <<DelayedCommitProtocol.md#commitTask, commit a task (after successful write)>> (for <<TransactionalWrite.md#, optimistic transactional writers>>)

== [[creating-instance]] Creating AddFile Instance

`AddFile` takes the following to be created:

* [[path]] Path
* [[partitionValues]] Partition values (`Map[String, String]`)
* [[size]] Size (in bytes)
* [[modificationTime]] Modification time
* [[dataChange]] `dataChange` flag
* [[stats]] Stats (default: `null`)
* [[tags]] Tags (`Map[String, String]`) (default: `null`)

== [[wrap]] `wrap` Method

[source, scala]
----
wrap: SingleAction
----

NOTE: `wrap` is part of the <<Action.md#wrap, Action>> contract to wrap the action into a <<SingleAction.md#, SingleAction>> for serialization.

`wrap` simply creates a new <<SingleAction.md#, SingleAction>> with the `add` field set to this `AddFile`.

== [[remove]] Creating RemoveFile Instance With Current Timestamp -- `remove` Method

[source, scala]
----
remove: RemoveFile
----

`remove` <<removeWithTimestamp, creates a RemoveFile action>> with the current timestamp and `dataChange` flag enabled.

[NOTE]
====
`remove` is used when:

* <<MergeIntoCommand.md#, MergeIntoCommand>> is executed

* <<WriteIntoDelta.md#, WriteIntoDelta>> is executed (with `Overwrite` mode)

* `DeltaSink` is requested to <<DeltaSink.md#addBatch, add a streaming micro-batch>> (with `Complete` mode)
====

== [[removeWithTimestamp]] Creating RemoveFile Instance For Given Timestamp -- `removeWithTimestamp` Method

[source, scala]
----
removeWithTimestamp(
  timestamp: Long = System.currentTimeMillis(),
  dataChange: Boolean = true): RemoveFile
----

`removeWithTimestamp` creates a <<RemoveFile.md#, RemoveFile>> action for the <<path, path>>, and the given `timestamp` and `dataChange` flag.

[NOTE]
====
`removeWithTimestamp` is used when:

* `AddFile` is requested to <<remove, create a RemoveFile action with the current timestamp>>

* <<DeleteCommand.md#, DeleteCommand>> and <<UpdateCommand.md#, UpdateCommand>> are executed
====
