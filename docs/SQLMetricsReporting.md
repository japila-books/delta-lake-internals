# SQLMetricsReporting

`SQLMetricsReporting` is an extension for [OptimisticTransactionImpl](OptimisticTransactionImpl.md) to track SQL metrics of [Operations](Operation.md).

## Implementations

* [OptimisticTransactionImpl](OptimisticTransactionImpl.md)

## <span id="operationSQLMetrics"> operationSQLMetrics Registry

```scala
operationSQLMetrics(
  spark: SparkSession,
  metrics: Map[String, SQLMetric]): Unit
```

`operationSQLMetrics`...FIXME

`operationSQLMetrics` is used when...FIXME

## <span id="registerSQLMetrics"> registerSQLMetrics

```scala
registerSQLMetrics(
  spark: SparkSession,
  metrics: Map[String, SQLMetric]): Unit
```

`registerSQLMetrics`...FIXME

`registerSQLMetrics` is used when...FIXME

## <span id="getMetricsForOperation"> Operation Metrics

```scala
getMetricsForOperation(
  operation: Operation): Map[String, String]
```

`getMetricsForOperation` requests the given [Operation](Operation.md) to [transform](Operation.md#transformMetrics) the [operation metrics](#operationSQLMetrics).

`getMetricsForOperation` is used when:

* `OptimisticTransactionImpl` is requested to [getOperationMetrics](OptimisticTransactionImpl.md#getOperationMetrics)
