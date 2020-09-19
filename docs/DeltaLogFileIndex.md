= DeltaLogFileIndex

[[creating-instance]]
`DeltaLogFileIndex` is a `FileIndex` (Spark SQL) that takes the following to be created:

* [[format]] One of the supported <<DeltaLog.adoc#FileFormats, FileFormats>>
* [[files]] `Array[FileStatus]` (Hadoop)

`DeltaLogFileIndex` is <<creating-instance, created>> (directly or indirectly using <<apply, apply>> utility) when `DeltaLog` is requested for the <<DeltaLog.adoc#currentSnapshot, currentSnapshot>>, to <<updateInternal, updateInternal>> and <<getSnapshotAt, getSnapshotAt>>.

== [[apply]] `apply` Utility

[source, scala]
----
apply(
  format: FileFormat,
  fs: FileSystem,
  paths: Seq[Path]): DeltaLogFileIndex
----

`apply` simply creates a new `DeltaLogFileIndex`.

NOTE: `apply` is used when `DeltaLog` is requested for the <<DeltaLog.adoc#currentSnapshot, currentSnapshot>>, to <<updateInternal, updateInternal>> and <<getSnapshotAt, getSnapshotAt>>.
