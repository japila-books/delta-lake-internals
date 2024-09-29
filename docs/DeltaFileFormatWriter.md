# DeltaFileFormatWriter

## Write Data Out { #write }

```scala
write(
  sparkSession: SparkSession,
  plan: SparkPlan,
  fileFormat: FileFormat,
  committer: FileCommitProtocol,
  outputSpec: OutputSpec,
  hadoopConf: Configuration,
  partitionColumns: Seq[Attribute],
  bucketSpec: Option[BucketSpec],
  statsTrackers: Seq[WriteJobStatsTracker],
  options: Map[String, String],
  numStaticPartitionCols: Int = 0): Set[String]
```

`write`...FIXME

---

`write` is used when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)
