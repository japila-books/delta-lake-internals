# SparkScan

`SparkScan` is a `Scan` ([Spark SQL]({{ book.spark_sql }}/connector/Scan/)).

## Physical Representation for Batch Query { #toBatch }

??? note "Scan"

    ```java
    Batch toBatch()
    ```

    `toBatch` is part of the `Scan` ([Spark SQL]({{ book.spark_sql }}/connector/Scan/#toBatch)) abstraction.

`toBatch` creates a [SparkBatch](SparkBatch.md).
