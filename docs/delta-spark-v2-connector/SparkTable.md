# SparkTable

`SparkTable` is a `Table` ([Spark SQL]({{ book.spark_sql }}/connector/Table/)) with support for reads ([SupportsRead]({{ book.spark_sql }}/connector/SupportsRead/)) and writes ([SupportsWrite]({{ book.spark_sql }}/connector/SupportsWrite/)).

## Creating Instance

`SparkTable` takes the following to be created:

* <span id="identifier"> Table `Identifier`
* <span id="tablePath"> Table Path
* <span id="userOptions"> (optional) User-Defined Options
* <span id="catalogTable"> (optional) `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable))

`SparkTable` is created when:

* `DeltaCatalog` is requested to [loadPathTable](../DeltaCatalog.md#loadPathTable) and [loadCatalogTable](../DeltaCatalog.md#loadCatalogTable)
* `ApplyV2Streaming` logical rule is [executed](../ApplyV2Streaming.md#apply)
