# DeltaJobStatisticsTracker

`DeltaJobStatisticsTracker` is a `WriteJobStatsTracker` ([Spark SQL]({{ book.spark_sql }}/WriteJobStatsTracker)) for per-file statistics collection (when [spark.databricks.delta.stats.collect](DeltaSQLConf.md#DELTA_COLLECT_STATS) is enabled).

## Creating Instance

`DeltaJobStatisticsTracker` takes the following to be created:

* <span id="hadoopConf"> Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
* <span id="path"> Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) (to a delta table's data directory)
* <span id="dataCols"> Data non-partitioned column `Attribute`s ([Spark SQL]({{ book.spark_sql }}/expressions/Attribute))
* <span id="statsColExpr"> Statistics Column `Expression` ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`DeltaJobStatisticsTracker` is created when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)

## <span id="recordedStats"> Recorded Per-File Statistics

```scala
recordedStats: Map[String, String]
```

`recordedStats` is a collection of recorded per-file statistics (that are collected upon [processing per-job write task statistics](#processStats)).

`recordedStats` is used when:

* `TransactionalWrite` is requested to [write data out](TransactionalWrite.md#writeFiles)

## <span id="processStats"> Processing Per-Job Write Task Statistics

```scala
processStats(
  stats: Seq[WriteTaskStats],
  jobCommitTime: Long): Unit
```

`processStats` extracts a `DeltaFileStatistics` (from the given `WriteTaskStats`) to access [collected per-file statistics](#recordedStats).

`processStats` is part of the `WriteJobStatsTracker` ([Spark SQL]({{ book.spark_sql }}/WriteJobStatsTracker#processStats)) abstraction.
