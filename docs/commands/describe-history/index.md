# DESCRIBE HISTORY Command

Delta Lake can display the versions (_history_) of delta tables using the following high-level operators:

* [DESCRIBE HISTORY](../../sql/index.md#describe-history) SQL command
* [DeltaTable.history](../../DeltaTable.md#history)

`DESCRIBE HISTORY` (regardless of the variant: SQL or `DeltaTable` API) is a mere wrapper around [DeltaHistoryManager](../../DeltaHistoryManager.md) to access the history of a delta table.

## Metrics Reporting

Write metrics can be collected at [transactional write](../../TransactionalWrite.md#writeFiles) based on [history.metricsEnabled](../../configuration-properties/index.md#history.metricsEnabled) configuration property.
