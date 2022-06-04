# DeltaSparkSessionExtension

**DeltaSparkSessionExtension** is used to register (_inject_) the following extensions to a `SparkSession`:

* [Delta SQL](sql/index.md) support (using [DeltaSqlParser](sql/DeltaSqlParser.md))
* [DeltaAnalysis](DeltaAnalysis.md)
* [DeltaUnsupportedOperationsCheck](DeltaUnsupportedOperationsCheck.md)
* [PrepareDeltaScan](data-skipping/PrepareDeltaScan.md)
* [PreprocessTableDelete](PreprocessTableDelete.md)
* [PreprocessTableMerge](PreprocessTableMerge.md)
* [PreprocessTableRestore](PreprocessTableRestore.md)
* [PreprocessTableUpdate](PreprocessTableUpdate.md)

`DeltaSparkSessionExtension` is [registered](installation.md) using **spark.sql.extensions** configuration property (while creating a `SparkSession` in a Spark application).
