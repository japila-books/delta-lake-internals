# SQLMetricsReporting

**SQLMetricsReporting** is an extension for [OptimisticTransactionImpl](OptimisticTransactionImpl.md) to track SQL metrics of [Operations](Operation.md).

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

## <span id="getMetricsForOperation"> getMetricsForOperation

```scala
getMetricsForOperation(
  operation: Operation): Map[String, String]
```

`getMetricsForOperation`...FIXME

`getMetricsForOperation` is used when `OptimisticTransactionImpl` is requested to [getOperationMetrics](OptimisticTransactionImpl.md#getOperationMetrics).
