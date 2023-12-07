# DeltaHistory

`DeltaHistory` is the schema of [DescribeDeltaHistory](DescribeDeltaHistory.md) and [DescribeDeltaHistoryCommand](DescribeDeltaHistoryCommand.md) logical operators.

## Creating Instance

`DeltaHistory` takes the following to be created:

* <span id="version"> Version
* <span id="timestamp"> Timestamp
* <span id="userId"> User ID
* <span id="userName"> Username
* <span id="operation"> Operation
* <span id="operationParameters"> Operation Parameters (`Map[String, String]`)
* <span id="job"> `JobInfo`
* <span id="notebook"> `NotebookInfo`
* <span id="clusterId"> Cluster ID
* <span id="readVersion"> Read Version
* <span id="isolationLevel"> Isolation Level
* <span id="isBlindAppend"> `isBlindAppend` flag
* <span id="operationMetrics"> Operation Metrics
* <span id="userMetadata"> User Metadata
* <span id="engineInfo"> Engine Info

`DeltaHistory` is created using [fromCommitInfo](#fromCommitInfo) factory method.
