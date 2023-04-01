# SQLMetricsReporting

`SQLMetricsReporting` is an extension for [OptimisticTransactionImpl](OptimisticTransactionImpl.md) to track [performance metrics](#operationSQLMetrics) of [Operation](Operation.md)s for reporting.

## Implementations

* [OptimisticTransactionImpl](OptimisticTransactionImpl.md)

## <span id="operationSQLMetrics"> operationSQLMetrics Registry

```scala
operationSQLMetrics: Map[String, SQLMetric]
```

`SQLMetricsReporting` uses `operationSQLMetrics` internal registry for `SQLMetric`s ([Spark SQL]({{ book.spark_sql }}/physical-operators/SQLMetric)) by their names.

`SQLMetric`s are [registered](#registerSQLMetrics) only when [spark.databricks.delta.history.metricsEnabled](configuration-properties/DeltaSQLConf.md#DELTA_HISTORY_METRICS_ENABLED) configuration property is enabled.

`operationSQLMetrics` is used when `SQLMetricsReporting` is requested for the following:

* [Operation Metrics](#getMetricsForOperation)
* [getMetric](#getMetric)

## <span id="registerSQLMetrics"> Registering SQLMetrics

```scala
registerSQLMetrics(
  spark: SparkSession,
  metrics: Map[String, SQLMetric]): Unit
```

`registerSQLMetrics` adds (_registers_) the given metrics to the [operationSQLMetrics](#operationSQLMetrics) internal registry only when [spark.databricks.delta.history.metricsEnabled](configuration-properties/DeltaSQLConf.md#DELTA_HISTORY_METRICS_ENABLED) configuration property is enabled.

`registerSQLMetrics` is used when:

* [DeleteCommand](commands/delete/DeleteCommand.md), [MergeIntoCommand](commands/merge/MergeIntoCommand.md), [UpdateCommand](commands/update/UpdateCommand.md) commands are executed
* `TransactionalWrite` is requested to [writeFiles](TransactionalWrite.md#writeFiles)
* `DeltaSink` is requested to [addBatch](DeltaSink.md#addBatch)

## <span id="getMetricsForOperation"> Operation Metrics

```scala
getMetricsForOperation(
  operation: Operation): Map[String, String]
```

`getMetricsForOperation` requests the given [Operation](Operation.md) to [transform](Operation.md#transformMetrics) the [operation metrics](#operationSQLMetrics).

`getMetricsForOperation` is used when:

* `OptimisticTransactionImpl` is requested for the [operation metrics](OptimisticTransactionImpl.md#getOperationMetrics)

## <span id="getMetric"> Looking Up Operation Metric

```scala
getMetric(
  name: String): Option[SQLMetric]
```

`getMetric` uses the [operationSQLMetrics](#operationSQLMetrics) registry to look up the `SQLMetric` by name.

`getMetric` is used when:

* [UpdateCommand](commands/update/UpdateCommand.md) is executed
