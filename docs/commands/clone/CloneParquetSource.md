# CloneParquetSource

`CloneParquetSource` is a [CloneSource](CloneSource.md).

## Creating Instance

`CloneParquetSource` takes the following to be created:

* <span id="tableIdentifier"> Table Identifier
* <span id="catalogTable"> `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable))
* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`CloneParquetSource` is created when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed (to resolve a [CloneTableStatement](CloneTableStatement.md) with `ParquetFileFormat` source table)

## allFiles { #allFiles }

??? note "Signature"

    ```scala
    allFiles: Dataset[AddFile]
    ```

    `allFiles` is part of the [CloneSource](CloneSource.md#allFiles) abstraction.

`allFiles`...FIXME
