# DeltaSparkSessionExtension

**DeltaSparkSessionExtension** is used to register (_inject_) the following extensions:

* [Delta SQL](sql/index.md) support (using [DeltaSqlParser](sql/DeltaSqlParser.md))
* [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule
* [DeltaUnsupportedOperationsCheck](DeltaUnsupportedOperationsCheck.md)
* [PreprocessTableUpdate](PreprocessTableUpdate.md) logical resolution rule
* [PreprocessTableMerge](PreprocessTableMerge.md) logical resolution rule
* [PreprocessTableDelete](PreprocessTableDelete.md) logical resolution rule

`DeltaSparkSessionExtension` is [registered](installation.md) using **spark.sql.extensions** configuration property (while creating a SparkSession in a Spark application).
