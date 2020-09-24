= FileAction

`FileAction` is an <<contract, extension>> of the <<Action.md#, Action contract>> for <<implementations,  metadata of file actions>> with the <<path, path>> and <<dataChange, dataChange>> flag.

[[contract]]
.FileAction Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| dataChange
a| [[dataChange]]

[source, scala]
----
dataChange: Boolean
----

Used when...FIXME

| path
a| [[path]]

[source, scala]
----
path: String
----

Used when...FIXME

|===

[[implementations]]
.FileActions
[cols="30m,70",options="header",width="100%"]
|===
| FileAction
| Description

| <<AddFile.md#, AddFile>>
| [[AddFile]]

| RemoveFile
| [[RemoveFile]]

|===

NOTE: `FileAction` is a Scala *sealed trait* which means that all the <<implementations, implementations>> are in the same compilation unit (a single file).
