# Operation

`Operation` is an [abstraction](#contract) of [operations](#implementations) that can be executed on a Delta table.

Operation is described by a [name](#name) and [parameters](#parameters) (that are simply used to create a [CommitInfo](CommitInfo.md) for `OptimisticTransactionImpl` when [committed](OptimisticTransactionImpl.md#commit) and, as a way to bypass a transaction, [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md)).

Operation may have [performance metrics](#operationMetrics).

## Contract

### <span id="parameters"> Parameters

```scala
parameters: Map[String, Any]
```

Parameters of the operation (to create a [CommitInfo](CommitInfo.md) with the [JSON-encoded values](#jsonEncodedValues))

Used when:

* `Operation` is requested for the [parameters with the values in JSON format](#jsonEncodedValues)

## Implementations

!!! note "Sealed Abstract Class"
    `Operation` is a Scala **sealed abstract class** which means that all of the implementations are in the same compilation unit (a single file).

### <span id="AddColumns"> AddColumns

[Name](#name): `ADD COLUMNS`

[Parameters](#parameters):

* `columns`

Used when:

* [AlterTableAddColumnsDeltaCommand](commands/alter/AlterTableAddColumnsDeltaCommand.md) is executed (and committed to a Delta table)

### AddConstraint

### ChangeColumn

### Convert

### CreateTable

### Delete

### DropConstraint

### ManualUpdate

### Merge

[Name](#name): `MERGE`

[Parameters](#parameters):

* predicate
* matchedPredicates
* notMatchedPredicates

[changesData](#changesData): `true`

Used when:

* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed (and committed to a Delta table)

### ReplaceColumns

### ReplaceTable

### SetTableProperties

[Name](#name): `SET TBLPROPERTIES`

[Parameters](#parameters):

* properties

Used when:

* [AlterTableSetPropertiesDeltaCommand](commands/alter/AlterTableSetPropertiesDeltaCommand.md) is executed

### <span id="StreamingUpdate"> StreamingUpdate

[Name](#name): `STREAMING UPDATE`

[Parameters](#parameters):

* outputMode
* queryId
* epochId

Used when:

* `DeltaSink` is requested to [addBatch](DeltaSink.md#addBatch)

### Truncate

### UnsetTableProperties

### Update

### UpdateColumnMetadata

### UpdateSchema

### UpgradeProtocol

### Write

## Creating Instance

`Operation` takes the following to be created:

* <span id="name"> Name of this operation

??? note "Abstract Class"
    `Operation` is an abstract class and cannot be created directly. It is created indirectly for the [concrete Operations](#implementations).

## <span id="jsonEncodedValues"> Serializing Parameter Values (to JSON Format)

```scala
jsonEncodedValues: Map[String, String]
```

`jsonEncodedValues` converts the values of the [parameters](#parameters) to JSON format.

`jsonEncodedValues` is used when:

* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit)
* `ConvertToDeltaCommand` command is requested to [streamWrite](commands/convert/ConvertToDeltaCommand.md#streamWrite)

## <span id="operationMetrics"> Operation Metrics

```scala
operationMetrics: Set[String]
```

`operationMetrics` is empty by default (and is expected to be overriden by [concrete operations](#implementations)).

`operationMetrics` is used when:

* `Operation` is requested to [transformMetrics](#transformMetrics)

## <span id="transformMetrics"> Transforming Performance Metrics

```scala
transformMetrics(
  metrics: Map[String, SQLMetric]): Map[String, String]
```

`transformMetrics` returns a collection of `SQLMetric`s ([Spark SQL]({{ book.spark_sql }}/physical-operators/SQLMetric)) and their values (as text) that are defined as the [operation metrics](#operationMetrics).

`transformMetrics` is used when:

* `SQLMetricsReporting` is requested for [operation metrics](SQLMetricsReporting.md#getMetricsForOperation)

## <span id="userMetadata"> User Metadata

```scala
userMetadata: Option[String]
```

`userMetadata` is undefined (`None`) by default (and is expected to be overriden by [concrete operations](#implementations)).

`userMetadata` is used when:

* `OptimisticTransactionImpl` is requested for the [user metadata](OptimisticTransactionImpl.md#getUserMetadata)

## <span id="changesData"> changesData Flag

```scala
changesData: Boolean
```

`changesData` is disabled (`false`) by default (and is expected to be overriden by [concrete operations](#implementations)).

!!! note
    `changesData` seems not used.
