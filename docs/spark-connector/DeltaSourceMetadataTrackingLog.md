# DeltaSourceMetadataTrackingLog

`DeltaSourceMetadataTrackingLog` is used by [DeltaDataSource](DeltaDataSource.md) to track data schema evolution of a delta table.

## Creating Instance

`DeltaSourceMetadataTrackingLog` takes the following to be created:

* <span id="sparkSession"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="rootMetadataLocation"> Metadata Location
* <span id="sourceSnapshot"> [Snapshot](../Snapshot.md)
* <span id="sourceMetadataPathOpt"> Metadata Path
* <span id="initMetadataLogEagerly"> `initMetadataLogEagerly` flag (default: `true`)

`DeltaSourceMetadataTrackingLog` is created using [DeltaSourceMetadataTrackingLog.create](#create) utility.

## Creating DeltaSourceMetadataTrackingLog { #create }

```scala
create(
  sparkSession: SparkSession,
  rootMetadataLocation: String,
  sourceSnapshot: Snapshot,
  sourceTrackingId: Option[String] = None,
  sourceMetadataPathOpt: Option[String] = None,
  mergeConsecutiveSchemaChanges: Boolean = false,
  initMetadataLogEagerly: Boolean = true): DeltaSourceMetadataTrackingLog
```

`create`...FIXME

---

`create` is used when:

* `DeltaDataSource` is requested for a [DeltaSourceMetadataTrackingLog](DeltaDataSource.md#getMetadataTrackingLogForDeltaSource)
