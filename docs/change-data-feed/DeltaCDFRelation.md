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

## Building Distributed Scan { #buildScan }

??? note "PrunedFilteredScan"

    ```scala
    buildScan(
      requiredColumns: Array[String],
      filters: Array[Filter]): RDD[Row]
    ```

    `buildScan` is part of the `PrunedFilteredScan` ([Spark SQL]({{ book.spark_sql }}/PrunedFilteredScan#buildScan)) abstraction.

`buildScan` [creates a batch DataFrame of changes](CDCReaderImpl.md#changesToBatchDF).

`buildScan` does column pruning with the `requiredColumns` defined (using `Dataset.select` operator).

In the end, `buildScan` converts the `DataFrame` to `RDD[Row]` (using `DataFrame.rdd` operator).
