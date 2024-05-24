# DeltaSparkSessionExtension

`DeltaSparkSessionExtension` is used to register (_inject_) Delta Lake-specific Spark SQL extensions as part of its [installation](installation.md).

* [CheckUnresolvedRelationTimeTravel](CheckUnresolvedRelationTimeTravel.md)
* [Delta SQL](sql/index.md) support (using [DeltaSqlParser](sql/DeltaSqlParser.md))
* [DeltaAnalysis](DeltaAnalysis.md)
* [DeltaUnsupportedOperationsCheck](DeltaUnsupportedOperationsCheck.md)
* [GenerateRowIDs](row-tracking/GenerateRowIDs.md)
* [PostHocResolveUpCast](PostHocResolveUpCast.md)
* [PrepareDeltaScan](data-skipping/PrepareDeltaScan.md)
* [PreprocessTableWithDVsStrategy](deletion-vectors/PreprocessTableWithDVsStrategy.md)
* [PreprocessTableDelete](PreprocessTableDelete.md)
* [PreprocessTableMerge](PreprocessTableMerge.md)
* [PreprocessTableUpdate](PreprocessTableUpdate.md)
* [PreprocessTimeTravel](PreprocessTimeTravel.md) resolution rule
* [RangePartitionIdRewrite](commands/optimize/RangePartitionIdRewrite.md)
* [Table-Valued Functions](table-valued-functions/index.md)

`DeltaSparkSessionExtension` is [registered](installation.md) using `spark.sql.extensions` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.extensions)) configuration property (while creating a `SparkSession` in a Spark application).
