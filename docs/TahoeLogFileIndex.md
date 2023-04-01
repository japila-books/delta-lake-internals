# TahoeLogFileIndex

`TahoeLogFileIndex` is a [file index](TahoeFileIndex.md).

## Creating Instance

`TahoeLogFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="path"> Data directory of the [Delta table](#deltaLog) (as a Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="snapshotAtAnalysis"> [Snapshot](Snapshot.md) at analysis
* <span id="partitionFilters"> Partition Filters (as Catalyst expressions; default: empty)
* [isTimeTravelQuery](#isTimeTravelQuery) flag (default: `false`)

`TahoeLogFileIndex` is created when:

* `DeltaLog` is requested for an [Insertable HadoopFsRelation](DeltaLog.md#createRelation)

## <span id="checkSchemaOnRead"><span id="checkLatestSchemaOnRead"><span id="spark.databricks.delta.checkLatestSchemaOnRead"> spark.databricks.delta.checkLatestSchemaOnRead

`TahoeLogFileIndex` uses the [spark.databricks.delta.checkLatestSchemaOnRead](configuration-properties/DeltaSQLConf.md#spark.databricks.delta.checkLatestSchemaOnRead) configuration property when requested for a [Snapshot](#getSnapshot).

## <span id="isTimeTravelQuery"> isTimeTravelQuery flag

`TahoeLogFileIndex` is given a `isTimeTravelQuery` flag when [created](#creating-instance).

`isTimeTravelQuery` flag is `false` by default and can be different when `DeltaLog` is requested to [create a BaseRelation](DeltaLog.md#createRelation) (when `DeltaTableV2` is requested for a [BaseRelation](DeltaTableV2.md#toBaseRelation) based on [DeltaTimeTravelSpec](DeltaTableV2.md#timeTravelSpec)).

## Demo

```text
val q = spark.read.format("delta").load("/tmp/delta/users")
val plan = q.queryExecution.executedPlan

import org.apache.spark.sql.execution.FileSourceScanExec
val scan = plan.collect { case e: FileSourceScanExec => e }.head

import org.apache.spark.sql.delta.files.TahoeLogFileIndex
val index = scan.relation.location.asInstanceOf[TahoeLogFileIndex]
scala> println(index)
Delta[version=1, file:/tmp/delta/users]
```

## <span id="matchingFiles"> matchingFiles Method

```scala
matchingFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression],
  keepStats: Boolean = false): Seq[AddFile]
```

`matchingFiles` [gets the snapshot](#getSnapshot) (with `stalenessAcceptable` flag off) and requests it for the [files to scan](PartitionFiltering.md#filesForScan) (for the index's [partition filters](#partitionFilters), the given `partitionFilters` and `dataFilters`).

!!! note
    [inputFiles](#inputFiles) and [matchingFiles](#matchingFiles) are similar. Both [get the snapshot](#getSnapshot) (of the delta table), but they use different filtering expressions and return value types.

`matchingFiles` is part of the [TahoeFileIndex](TahoeFileIndex.md#matchingFiles) abstraction.

## <span id="inputFiles"> inputFiles Method

```scala
inputFiles: Array[String]
```

`inputFiles` [gets the snapshot](#getSnapshot) (with `stalenessAcceptable` flag off) and requests it for the [files to scan](PartitionFiltering.md#filesForScan) (for the index's [partition filters](#partitionFilters) only).

!!! note
    [inputFiles](#inputFiles) and [matchingFiles](#matchingFiles) are similar. Both [get the snapshot](#getSnapshot), but they use different filtering expressions and return value types.

`inputFiles` is part of the `FileIndex` contract (Spark SQL).

## <span id="getSnapshot"> Snapshot

```scala
getSnapshot: Snapshot
```

`getSnapshot` returns the [Snapshot to scan](#getSnapshotToScan).

---

With [checkSchemaOnRead](#checkSchemaOnRead) enabled or the [DeltaColumnMappingMode](#columnMappingMode) (of the [Metadata](Snapshot.md#metadata) of the [Snapshot](Snapshot.md)) set (different from `NoMapping`), `getSnapshot` makes sure that the [schemas are read-compatible](SchemaUtils.md#isReadCompatible) (and hasn't changed in an incompatible manner since analysis time)

---

`getSnapshot` is used when:

* `TahoeLogFileIndex` is requested for the [matching files](#matchingFiles) and the [input files](#inputFiles)

### <span id="getSnapshotToScan"> getSnapshotToScan

```scala
getSnapshotToScan: Snapshot
```

`getSnapshot` returns the [Snapshot](#snapshotAtAnalysis) with [isTimeTravelQuery](#isTimeTravelQuery) enabled or requests the [DeltaLog](#deltaLog) to [update and give one](DeltaLog.md#update).

## Internal Properties

### <span id="historicalSnapshotOpt"> historicalSnapshotOpt

**Historical snapshot** that is the [Snapshot](Snapshot.md) for the [versionToUse](#versionToUse) if defined.

Used when `TahoeLogFileIndex` is requested for the [(historical or latest) snapshot](#getSnapshot) and the [schema of the partition columns](#partitionSchema)
