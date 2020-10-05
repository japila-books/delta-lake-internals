= TahoeFileIndex -- Indices Of Files Of Delta Table
:navtitle: TahoeFileIndex

*TahoeFileIndex* is an <<contract, extension>> of the Spark SQL `FileIndex` contract for <<implementations, file indices>> of delta tables that can <<listFiles, list data files>> to scan (based on <<matchingFiles, partition and data filters>>).

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-FileIndex.html[FileIndex] in https://bit.ly/spark-sql-internals[The Internals of Spark SQL] online book.

NOTE: The aim of TahoeFileIndex is to reduce usage of very expensive disk access for file-related information using Hadoop [FileSystem](https://hadoop.apache.org/docs/r{{ hadoop.version }}/api/org/apache/hadoop/fs/FileSystem.html) API.

[[contract]]
.TahoeFileIndex Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| matchingFiles
a| [[matchingFiles]]

[source, scala]
----
matchingFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression],
  keepStats: Boolean = false): Seq[AddFile]
----

Files (AddFile.md[AddFiles]) matching given partition and data predicates

Used for <<listFiles, listing data files>>

|===

[[rootPaths]]
When requested for the root input paths (`rootPaths`), TahoeFileIndex simply gives the <<path, path>>.

[[implementations]]
.TahoeFileIndices
[cols="30,70",options="header",width="100%"]
|===
| TahoeFileIndex
| Description

| <<TahoeBatchFileIndex.md#, TahoeBatchFileIndex>>
| [[TahoeBatchFileIndex]]

| <<TahoeLogFileIndex.md#, TahoeLogFileIndex>>
| [[TahoeLogFileIndex]]

|===

== [[creating-instance]] Creating TahoeFileIndex Instance

TahoeFileIndex takes the following to be created:

* [[spark]] `SparkSession`
* [[deltaLog]] <<DeltaLog.md#, DeltaLog>>
* [[path]] Hadoop [Path](https://hadoop.apache.org/docs/r{{ hadoop.version }}/api/org/apache/hadoop/fs/Path.html)

NOTE: TahoeFileIndex is a Scala abstract class and cannot be <<creating-instance, created>> directly. It is created indirectly for the <<implementations, concrete file indices>>.

== [[tableVersion]] Version of Delta Table -- `tableVersion` Method

[source, scala]
----
tableVersion: Long
----

`tableVersion` is simply the <<Snapshot.md#version, version>> of (the <<DeltaLog.md#snapshot, snapshot>> of) the <<deltaLog, DeltaLog>>.

NOTE: `tableVersion` is used when TahoeFileIndex is requested for the <<toString, human-friendly textual representation>>.

== [[listFiles]] Listing Data Files -- `listFiles` Method

[source, scala]
----
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
----

NOTE: `listFiles` is part of the `FileIndex` contract for the file names (grouped into partitions when the data is partitioned).

`listFiles`...FIXME

== [[partitionSchema]] Partition Schema -- `partitionSchema` Method

[source, scala]
----
partitionSchema: StructType
----

NOTE: `partitionSchema` is part of the `FileIndex` contract for the partition schema.

`partitionSchema` simply requests the <<deltaLog, DeltaLog>> for the <<DeltaLog.md#snapshot, Snapshot>> and then requests the `Snapshot` for <<Snapshot.md#metadata, Metadata>> that in turn is requested for the <<Metadata.md#partitionSchema, partitionSchema>>.

== [[toString]] Human-Friendly Textual Representation -- `toString` Method

[source, scala]
----
toString: String
----

NOTE: `toString` is part of the `java.lang.Object` contract for a string representation of the object.

`toString` returns the following text (based on the <<tableVersion, table version>> and the <<path, path>> truncated to 100 characters):

```
Delta[version=[tableVersion], [truncatedPath]]
```
