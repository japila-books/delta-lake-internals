---
title: PrepareDeltaScan
---

# PrepareDeltaScan Logical Optimization

`PrepareDeltaScan` is a [PrepareDeltaScanBase](PrepareDeltaScanBase.md).

## Creating Instance

`PrepareDeltaScan` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`PrepareDeltaScan` is created when:

* `DeltaSparkSessionExtension` is requested to [register delta extensions](../DeltaSparkSessionExtension.md#apply) (and injects pre-CBO optimizer rules)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.stats.PrepareDeltaScan` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.stats.PrepareDeltaScan=ALL
```

Refer to [Logging](../logging.md).
