= [[DeltaFileFormat]] DeltaFileFormat Contract -- Spark FileFormat Of Delta Table

`DeltaFileFormat` is the <<contract, abstraction>> of <<implementations, FileFormat "descriptors">> that can <<fileFormat, specify the Spark FileFormat of a Delta table>>.

[[contract]]
.DeltaFileFormat Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| fileFormat
a| [[fileFormat]]

[source, scala]
----
fileFormat: FileFormat
----

Spark SQL's `FileFormat` of a delta table

Default: `ParquetFileFormat`

Used when:

* `DeltaLog` is requested for a <<DeltaLog.md#createRelation, relation>> (in batch queries) and <<createDataFrame, DataFrame>>

* `DeltaCommand` is requested for a <<DeltaCommand.md#buildBaseRelation, relation>>

* `TransactionalWrite` is requested to <<TransactionalWrite.md#writeFiles, write data out>>

|===

[[implementations]]
NOTE: <<Snapshot.md#, Snapshot>> is the only known `DeltaFileFormat`.
