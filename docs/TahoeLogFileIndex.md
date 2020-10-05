# TahoeLogFileIndex

`TahoeLogFileIndex` is a [file index](TahoeFileIndex.md).

## Creating Instance

`TahoeLogFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="path"> Data directory of the [Delta table](#deltaLog) (as a Hadoop [Path](https://hadoop.apache.org/docs/r{{ hadoop.version }}/api/org/apache/hadoop/fs/Path.html))
* <span id="schemaAtAnalysis"> Schema at analysis (`StructType`)
* <span id="partitionFilters"> Catalyst Expressions for the partition filters (default: `empty`)
* <span id="versionToUse"> Snapshot version (default: `undefined`) (`Option[Long]`)

`TahoeLogFileIndex` is created when `DeltaLog` is requested for an [Insertable HadoopFsRelation](DeltaLog.md#createRelation).

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

## <span id="getSnapshot"> Historical Or Latest Snapshot

```scala
getSnapshot(
  stalenessAcceptable: Boolean): Snapshot
```

`getSnapshot` returns a [Snapshot](Snapshot.md) that is either the [historical snapshot](#historicalSnapshotOpt) (for the [snapshot version](#versionToUse) if specified) or requests the [DeltaLog](#deltaLog) to [update](DeltaLog.md#update) (and give one).

`getSnapshot` is used when `TahoeLogFileIndex` is requested for the [matching files](#matchingFiles) and the [input files](#inputFiles).

## Internal Properties

### <span id="historicalSnapshotOpt"> historicalSnapshotOpt

**Historical snapshot** that is the [Snapshot](Snapshot.md) for the [versionToUse](#versionToUse) if defined.

Used when `TahoeLogFileIndex` is requested for the [(historical or latest) snapshot](#getSnapshot) and the [schema of the partition columns](#partitionSchema)
