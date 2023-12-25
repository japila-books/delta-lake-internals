# DeltaCDFRelation

`DeltaCDFRelation` is a `BaseRelation` ([Spark SQL]({{ book.spark_sql }}/BaseRelation)) and a `PrunedFilteredScan` ([Spark SQL]({{ book.spark_sql }}/PrunedFilteredScan)).

## Creating Instance

`DeltaCDFRelation` takes the following to be created:

* <span id="snapshotWithSchemaMode"> `SnapshotWithSchemaMode`
* <span id="sqlContext"> `SQLContext` ([Spark SQL]({{ book.spark_sql }}/SQLContext))
* <span id="startingVersion"> Starting version
* <span id="endingVersion"> Ending version

`DeltaCDFRelation` is created when:

* `CDCReaderImpl` is requested for a [CDF-aware BaseRelation](CDCReaderImpl.md#getCDCRelation)

## buildScan { #buildScan }

??? note "PrunedFilteredScan"

    ```scala
    buildScan(
      requiredColumns: Array[String],
      filters: Array[Filter]): RDD[Row]
    ```

    `buildScan` is part of the `PrunedFilteredScan` ([Spark SQL]({{ book.spark_sql }}/PrunedFilteredScan#buildScan)) abstraction.

`buildScan` [changesToBatchDF](CDCReaderImpl.md#changesToBatchDF).

In the end, `buildScan` selects the given `requiredColumns` (using `Dataset.select` operator) and requests the `DataFrame` for the underlying `RDD[Row]`.
