# DeltaErrors Utility

## concurrentAppendException { #concurrentAppendException }

```scala
concurrentAppendException(
  conflictingCommit: Option[CommitInfo],
  partition: String,
  customRetryMsg: Option[String] = None): ConcurrentAppendException
```

`concurrentAppendException` creates a [ConcurrentAppendException](exceptions/ConcurrentAppendException.md) with the following message:

```text
Files were added to [partition] by a concurrent update. [customRetryMsg] | Please try the operation again.
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`concurrentAppendException` is used when:

* `OptimisticTransactionImpl` is requested to [check logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts)

## concurrentDeleteDeleteException { #concurrentDeleteDeleteException }

```scala
concurrentDeleteDeleteException(
  conflictingCommit: Option[CommitInfo],
  file: String): ConcurrentDeleteDeleteException
```

`concurrentDeleteDeleteException` creates a [ConcurrentDeleteDeleteException](exceptions/ConcurrentDeleteDeleteException.md) with the following message:

```text
This transaction attempted to delete one or more files that were deleted (for example [file]) by a concurrent update. Please try the operation again.
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`concurrentDeleteDeleteException` is used when:

* `OptimisticTransactionImpl` is requested to [check for logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts)

## concurrentDeleteReadException { #concurrentDeleteReadException }

```scala
concurrentDeleteReadException(
  conflictingCommit: Option[CommitInfo],
  file: String): ConcurrentDeleteReadException
```

`concurrentDeleteReadException` creates a [ConcurrentDeleteReadException](exceptions/ConcurrentDeleteReadException.md) with the following message:

```text
This transaction attempted to read one or more files that were deleted (for example [file]) by a concurrent update. Please try the operation again.
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`concurrentDeleteReadException` is used when:

* `OptimisticTransactionImpl` is requested to [check for logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts)

## concurrentTransactionException { #concurrentTransactionException }

```scala
concurrentTransactionException(
  conflictingCommit: Option[CommitInfo]): ConcurrentTransactionException
```

`concurrentTransactionException` creates a [ConcurrentTransactionException](exceptions/ConcurrentTransactionException.md) with the following message:

```text
This error occurs when multiple streaming queries are using the same checkpoint to write into this table.
Did you run multiple instances of the same streaming query at the same time?
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`concurrentTransactionException` is used when:

* `OptimisticTransactionImpl` is requested to [check for logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts)

## concurrentWriteException { #concurrentWriteException }

```scala
concurrentWriteException(
  conflictingCommit: Option[CommitInfo]): ConcurrentWriteException
```

`concurrentWriteException` creates a [ConcurrentWriteException](exceptions/ConcurrentWriteException.md) with the following message:

```text
A concurrent transaction has written new data since the current transaction read the table. Please try the operation again.
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`concurrentWriteException` is used when:

* [Convert to Delta](commands/convert/index.md) command is executed (and `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge))

## metadataChangedException { #metadataChangedException }

```scala
metadataChangedException(
  conflictingCommit: Option[CommitInfo]): MetadataChangedException
```

`metadataChangedException` creates a [MetadataChangedException](exceptions/MetadataChangedException.md) with the following message:

```text
The metadata of the Delta table has been changed by a concurrent update. Please try the operation again.
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`metadataChangedException` is used when:

* `OptimisticTransactionImpl` is requested to [check for logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts)

## protocolChangedException { #protocolChangedException }

```scala
protocolChangedException(
  conflictingCommit: Option[CommitInfo]): ProtocolChangedException
```

`protocolChangedException` creates a [ProtocolChangedException](exceptions/ProtocolChangedException.md) with the following message:

```text
The protocol version of the Delta table has been changed by a concurrent update.
[additionalInfo]
Please try the operation again.
Conflicting commit: [commitinfo]
Refer to [docs]/concurrency-control.html for more details.
```

`protocolChangedException` is used when:

* `OptimisticTransactionImpl` is requested to [check for logical conflicts with concurrent updates](OptimisticTransactionImpl.md#checkForConflicts)

## modifyAppendOnlyTableException { #modifyAppendOnlyTableException }

```scala
modifyAppendOnlyTableException: Throwable
```

`modifyAppendOnlyTableException` throws an `UnsupportedOperationException`:

```text
This table is configured to only allow appends. If you would like to permit updates or deletes, use 'ALTER TABLE <table_name> SET TBLPROPERTIES (appendOnly=false)'.
```

`modifyAppendOnlyTableException` is used when:

* `DeltaLog` is requested to [assertRemovable](DeltaLog.md#assertRemovable)

## notNullColumnMissingException { #notNullColumnMissingException }

```scala
notNullColumnMissingException(
  constraint: Constraints.NotNull): Throwable
```

`notNullColumnMissingException` creates a [InvariantViolationException](constraints/InvariantViolationException.md) with the following error message:

```text
Column [name], which has a NOT NULL constraint, is missing from the data being written into the table.
```

`notNullColumnMissingException` is used when:

* `DeltaInvariantCheckerExec` utility is used to [buildInvariantChecks](constraints/DeltaInvariantCheckerExec.md#buildInvariantChecks)

## Reporting Post-Commit Hook Failure { #postCommitHookFailedException }

```scala
postCommitHookFailedException(
  failedHook: PostCommitHook,
  failedOnCommitVersion: Long,
  extraErrorMessage: String,
  error: Throwable): Throwable
```

`postCommitHookFailedException` throws a `RuntimeException`:

```text
Committing to the Delta table version [failedOnCommitVersion] succeeded but error while executing post-commit hook [failedHook]: [extraErrorMessage]
```

`postCommitHookFailedException` is used when:

* `GenerateSymlinkManifestImpl` is requested to [handleError](post-commit-hooks/GenerateSymlinkManifest.md#handleError)

## changeColumnMappingModeOnOldProtocol { #changeColumnMappingModeOnOldProtocol }

```scala
changeColumnMappingModeOnOldProtocol(
  oldProtocol: Protocol): Throwable
```

`changeColumnMappingModeOnOldProtocol` creates a `DeltaColumnMappingUnsupportedException` with `UNSUPPORTED_COLUMN_MAPPING_PROTOCOL` error class.

`changeColumnMappingModeOnOldProtocol` is used when:

* `DeltaColumnMappingBase` is requested to [verifyAndUpdateMetadataChange](column-mapping/DeltaColumnMappingBase.md#verifyAndUpdateMetadataChange)

## convertToDeltaWithColumnMappingNotSupported { #convertToDeltaWithColumnMappingNotSupported }

```scala
convertToDeltaWithColumnMappingNotSupported(
  mode: DeltaColumnMappingMode): Throwable
```

`convertToDeltaWithColumnMappingNotSupported` creates a `DeltaColumnMappingUnsupportedException` with `UNSUPPORTED_COLUMN_MAPPING_CONVERT_TO_DELTA` error class.

`convertToDeltaWithColumnMappingNotSupported` is used when:

* `ConvertToDeltaCommandBase` is requested to [checkColumnMapping](commands/convert/ConvertToDeltaCommand.md#checkColumnMapping)

## unknownConfigurationKeyException { #unknownConfigurationKeyException }

```scala
unknownConfigurationKeyException(
  confKey: String): Throwable
```

`unknownConfigurationKeyException` creates a [DeltaAnalysisException](DeltaAnalysisException.md) for `DELTA_UNKNOWN_CONFIGURATION` [error class](DeltaAnalysisException.md#errorClass) and the following [message parameters](DeltaAnalysisException.md#messageParameters):

1. The given `confKey`
1. [spark.databricks.delta.allowArbitraryProperties.enabled](./configuration-properties/index.md#ALLOW_ARBITRARY_TABLE_PROPERTIES)

---

`unknownConfigurationKeyException` is used when:

* `DeltaConfigsBase` is requested to [validate table properties](./table-properties/DeltaConfigs.md#validateConfigurations)
