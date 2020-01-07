= [[TahoeBatchFileIndex]] TahoeBatchFileIndex

`TahoeBatchFileIndex` is a concrete <<TahoeFileIndex.adoc#, file index>> for a given <<snapshot, version>> of a <<deltaLog, delta table>>.

`TahoeBatchFileIndex` is <<creating-instance, created>> when:

* `DeltaLog` is requested for a <<DeltaLog.adoc#createDataFrame, DataFrame for given AddFiles>> (for <<MergeIntoCommand.adoc#, MergeIntoCommand>> and <<DeltaSource.adoc#getBatch, DeltaSource>>)

* <<DeleteCommand.adoc#, DeleteCommand>> and <<UpdateCommand.adoc#, UpdateCommand>> are executed

* `DeltaCommand` is requested for a <<DeltaCommand.adoc#buildBaseRelation, HadoopFsRelation>> (for <<DeleteCommand.adoc#, DeleteCommand>> and <<UpdateCommand.adoc#, UpdateCommand>>)

== [[creating-instance]] Creating TahoeBatchFileIndex Instance

`TahoeBatchFileIndex` takes the following to be created:

* [[spark]] `SparkSession`
* [[actionType]] Action type
* [[addFiles]] <<AddFile.adoc#, AddFiles>> (`Seq[AddFile]`)
* [[deltaLog]] <<DeltaLog.adoc#, DeltaLog>>
* [[path]] Data directory of the delta table (as Hadoop https://hadoop.apache.org/docs/r2.6.5/api/org/apache/hadoop/fs/Path.html[Path])
* [[snapshot]] <<Snapshot.adoc#, Snapshot>>

`TahoeBatchFileIndex` initializes the <<internal-properties, internal properties>>.

== [[tableVersion]] `tableVersion` Method

[source, scala]
----
tableVersion: Long
----

NOTE: `tableVersion` is part of the <<TahoeFileIndex.adoc#tableVersion, TahoeFileIndex>> contract for the version of the delta table.

`tableVersion`...FIXME

== [[matchingFiles]] `matchingFiles` Method

[source, scala]
----
matchingFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression],
  keepStats: Boolean = false): Seq[AddFile]
----

NOTE: `matchingFiles` is part of the <<TahoeFileIndex.adoc#matchingFiles, TahoeFileIndex Contract>> for the matching (valid) files by the given filtering expressions.

`matchingFiles`...FIXME

== [[inputFiles]] `inputFiles` Method

[source, scala]
----
inputFiles: Array[String]
----

NOTE: `inputFiles` is part of the `FileIndex` contract to...FIXME

`inputFiles`...FIXME

== [[partitionSchema]] Schema of Partition Columns -- `partitionSchema` Method

[source, scala]
----
partitionSchema: StructType
----

NOTE: `partitionSchema` is part of the `FileIndex` contract (Spark SQL) to get the schema of the partition columns (if used).

`partitionSchema` simply requests the <<snapshot, Snapshot>> for the <<Snapshot.adoc#metadata, metadata>> that is in turn requested for the <<Metadata.adoc#partitionSchema, partitionSchema>>.

== [[sizeInBytes]] `sizeInBytes` Property

[source, scala]
----
sizeInBytes: Long
----

NOTE: `sizeInBytes` is part of the `FileIndex` contract (Spark SQL) for the table size (in bytes).

`sizeInBytes` is simply a sum of the <<AddFile.adoc#size, size>> of all <<addFiles, AddFiles>>.
