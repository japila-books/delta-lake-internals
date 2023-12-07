# Describe History Command

Delta Lake supports displaying versions (_history_) of delta tables using the following high-level operators:

* [DESCRIBE HISTORY](DescribeDeltaHistory.md) SQL command
* [DeltaTable.history](../../DeltaTable.md#history)

## Metrics Reporting

Write metrics can be collected at [transactional write](../../TransactionalWrite.md#writeFiles) based on [history.metricsEnabled](../../configuration-properties/index.md#history.metricsEnabled) configuration property.
