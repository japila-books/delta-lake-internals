# DeltaProgressReporter

`DeltaProgressReporter` is an abstraction of [progress reporters](#implementations) (_loggers_).

## Implementations

* [DeltaLogging](DeltaLogging.md)

## <span id="withStatusCode"> withStatusCode

```scala
withStatusCode[T](
  statusCode: String,
  defaultMessage: String,
  data: Map[String, Any] = Map.empty)(body: => T): T
```

`withStatusCode` prints out the following INFO message to the logs:

```text
[statusCode]: [defaultMessage]
```

`withStatusCode` [withJobDescription](#withJobDescription) with the given `defaultMessage` and `body`.

`withStatusCode` prints out the following INFO message to the logs:

```text
[statusCode]: Done
```

`withStatusCode` is used when:

* `PartitionFiltering` is requested for the [files to scan](PartitionFiltering.md#filesForScan)
* `Snapshot` is requested for the [state](Snapshot.md#computedState)
* [DeleteCommand](commands/delete/DeleteCommand.md), [MergeIntoCommand](commands/merge/MergeIntoCommand.md), [UpdateCommand](commands/update/UpdateCommand.md) are executed
* `GenerateSymlinkManifest` is requested to [recordManifestGeneration](GenerateSymlinkManifest.md#recordManifestGeneration)

### <span id="withJobDescription"> withJobDescription

```scala
withJobDescription[U](
  jobDesc: String)(body: => U): U
```

`withJobDescription`...FIXME

## Logging

Since `DeltaProgressReporter` is an abstraction, logging is configured using the logger of the [implementations](#implementations).
