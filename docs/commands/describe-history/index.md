# DESCRIBE HISTORY Command

Delta Lake can display the versions (_history_) of delta tables using the following high-level operators:

* [DESCRIBE HISTORY](../../sql/index.md#describe-history) SQL command
* [DeltaTable.history](../../DeltaTable.md#history)

`DESCRIBE HISTORY` (regardless of the variant: SQL or `DeltaTable` API) is a mere wrapper around [DeltaHistoryManager](../../DeltaHistoryManager.md) to access the history of a delta table.

!!! note "Possible Cost Optimization on Microsoft Azure"
    When on Microsoft Azure, consider increasing [spark.databricks.delta.history.maxKeysPerList](../../configuration-properties/index.md#spark.databricks.delta.history.maxKeysPerList) configuration property to `5000` (which is the maximum number of blobs to return, including all `BlobPrefix` elements, in a single [List Blobs](https://learn.microsoft.com/en-us/rest/api/storageservices/list-blobs) API call).

## Metrics Reporting

Write metrics can be collected at [transactional write](../../TransactionalWrite.md#writeFiles) based on [history.metricsEnabled](../../configuration-properties/index.md#history.metricsEnabled) configuration property.
