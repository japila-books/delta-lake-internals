# PrepareDeltaScan Logical Optimization Rule

`PrepareDeltaScan` is a [PrepareDeltaScanBase](PrepareDeltaScanBase.md).

## Creating Instance

`PrepareDeltaScan` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`PrepareDeltaScan` is created when:

* `DeltaSparkSessionExtension` is requested to [inject extensions](../DeltaSparkSessionExtension.md#apply) (and injects pre-CBO optimizer rules)
