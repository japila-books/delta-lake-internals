# DeltaSparkSessionExtension

`DeltaSparkSessionExtension` is used to register (_inject_) the following extensions to a `SparkSession`:

* [Delta SQL](sql/index.md) support (using [DeltaSqlParser](sql/DeltaSqlParser.md))
* [DeltaAnalysis](DeltaAnalysis.md)
* [PreprocessTimeTravel](PreprocessTimeTravel.md) resolution rule
* [DeltaUnsupportedOperationsCheck](DeltaUnsupportedOperationsCheck.md)
* [PrepareDeltaScan](data-skipping/PrepareDeltaScan.md)
* [PreprocessTableDelete](PreprocessTableDelete.md)
* [PreprocessTableMerge](PreprocessTableMerge.md)
* [PreprocessTableUpdate](PreprocessTableUpdate.md)
* [RangePartitionIdRewrite](commands/optimize/RangePartitionIdRewrite.md)
* [Table-Valued Functions](table-valued-functions/index.md)

`DeltaSparkSessionExtension` is [registered](installation.md) using `spark.sql.extensions` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.extensions)) configuration property (while creating a `SparkSession` in a Spark application).
