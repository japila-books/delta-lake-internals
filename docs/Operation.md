# Operation

**Operation** is an [abstraction](#contract) of [operations](#implementations) that can be executed on Delta tables.

Operation is described by a [name](#name) and [parameters](#parameters) (that are simply used to create a [CommitInfo](CommitInfo.md) for `OptimisticTransactionImpl` when [committed](OptimisticTransactionImpl.md#commit) and, as a way to bypass a transaction, [ConvertToDeltaCommand](ConvertToDeltaCommand.md)).

Operation may have [performance metrics](#operationMetrics).

## Contract

### <span id="parameters"> parameters

```scala
parameters: Map[String, Any]
```

Parameters of the operation (to create a [CommitInfo](CommitInfo.md) with the [JSON-encoded values](#jsonEncodedValues))

Used when `Operation` is requested for [parameters with the values in JSON format](#jsonEncodedValues)

## Implementations

??? note "Sealed Abstract Class"
    `Operation` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).

* AddColumns
* ChangeColumn
* ComputeStats
* Convert
* CreateTable
* Delete
* FileNotificationRetention
* Fsck
* ManualUpdate
* Optimize
* ReplaceColumns
* ReplaceTable
* ResetZCubeInfo
* SetTableProperties
* StreamingUpdate
* Truncate
* UnsetTableProperties
* Update
* UpdateColumnMetadata
* UpdateSchema
* UpgradeProtocol
* Write

### Merge

Recorded when a merge operation is committed to a Delta table (when [MergeIntoCommand](MergeIntoCommand.md) is executed)

## Creating Instance

`Operation` takes the following to be created:

* <span id="name"> Name

??? note "Abstract Class"
    `Operation` is an abstract class and cannot be created directly. It is created indirectly for the [concrete Operations](#implementations).

## <span id="jsonEncodedValues"> Serializing Parameter Values (to JSON Format)

```scala
jsonEncodedValues: Map[String, String]
```

`jsonEncodedValues` converts the values of the [parameters](#parameters) to JSON format.

`jsonEncodedValues` is used when:

* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit)
* `ConvertToDeltaCommand` command is requested to [streamWrite](ConvertToDeltaCommand.md#streamWrite)

## <span id="operationMetrics"> operationMetrics Registry

```scala
operationMetrics: Set[String]
```

`operationMetrics` is empty by default (and is expected to be overriden by [concrete operations](#implementations))

`operationMetrics` is used when `Operation` is requested to [transformMetrics](#transformMetrics).

## <span id="transformMetrics"> transformMetrics Method

```scala
transformMetrics(
  metrics: Map[String, SQLMetric]): Map[String, String]
```

`transformMetrics` returns a collection of performance metrics (`SQLMetric`) and their values (as a text) that are defined as the [operationMetrics](#operationMetrics).

`transformMetrics` is used when `SQLMetricsReporting` is requested to [getMetricsForOperation](SQLMetricsReporting.md#getMetricsForOperation).
