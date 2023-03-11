# Action

`Action` is an [abstraction](#contract) of [operations](#implementations) that change the state of a delta table.

## Contract

### <span id="json"> JSON Representation

```scala
json: String
```

Serializes (_converts_) the [(wrapped) action](#wrap) to JSON format

`json` uses [Jackson]({{ jackson.github }}) library (with [jackson-module-scala]({{ jackson.scala }})) as the JSON processor.

Used when:

* `OptimisticTransactionImpl` is requested to [doCommit](OptimisticTransactionImpl.md#doCommit)
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge)

### <span id="wrap"> SingleAction Representation

```scala
wrap: SingleAction
```

Wraps the action into a [SingleAction](SingleAction.md) for serialization

Used when:

* `Snapshot` is requested to [stateReconstruction](Snapshot.md#stateReconstruction)
* `Action` is requested to [serialize to JSON format](#json)

## Implementations

??? note "Sealed Trait"
    `Action` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#sealed).

* [CommitInfo](CommitInfo.md)
* [FileAction](FileAction.md)
* [Metadata](Metadata.md)
* [Protocol](Protocol.md)
* [SetTransaction](SetTransaction.md)

## <span id="logSchema"> Log Schema

```scala
logSchema: StructType
```

`logSchema` is the schema ([Spark SQL]({{ book.spark_sql }}/StructType)) of [SingleAction](SingleAction.md)s for `Snapshot` to [convert a DeltaLogFileIndex to a LogicalRelation](Snapshot.md#indexToRelation) and [emptyActions](Snapshot.md##emptyActions).

```scala
import org.apache.spark.sql.delta.actions.Action.logSchema
logSchema.printTreeString
```

```text
root
 |-- txn: struct (nullable = true)
 |    |-- appId: string (nullable = true)
 |    |-- version: long (nullable = false)
 |    |-- lastUpdated: long (nullable = true)
 |-- add: struct (nullable = true)
 |    |-- path: string (nullable = true)
 |    |-- partitionValues: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- size: long (nullable = false)
 |    |-- modificationTime: long (nullable = false)
 |    |-- dataChange: boolean (nullable = false)
 |    |-- stats: string (nullable = true)
 |    |-- tags: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |-- remove: struct (nullable = true)
 |    |-- path: string (nullable = true)
 |    |-- deletionTimestamp: long (nullable = true)
 |    |-- dataChange: boolean (nullable = false)
 |    |-- extendedFileMetadata: boolean (nullable = false)
 |    |-- partitionValues: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- size: long (nullable = false)
 |    |-- tags: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |-- metaData: struct (nullable = true)
 |    |-- id: string (nullable = true)
 |    |-- name: string (nullable = true)
 |    |-- description: string (nullable = true)
 |    |-- format: struct (nullable = true)
 |    |    |-- provider: string (nullable = true)
 |    |    |-- options: map (nullable = true)
 |    |    |    |-- key: string
 |    |    |    |-- value: string (valueContainsNull = true)
 |    |-- schemaString: string (nullable = true)
 |    |-- partitionColumns: array (nullable = true)
 |    |    |-- element: string (containsNull = true)
 |    |-- configuration: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- createdTime: long (nullable = true)
 |-- protocol: struct (nullable = true)
 |    |-- minReaderVersion: integer (nullable = false)
 |    |-- minWriterVersion: integer (nullable = false)
 |-- cdc: struct (nullable = true)
 |    |-- path: string (nullable = true)
 |    |-- partitionValues: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- size: long (nullable = false)
 |    |-- tags: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |-- commitInfo: struct (nullable = true)
 |    |-- version: long (nullable = true)
 |    |-- timestamp: timestamp (nullable = true)
 |    |-- userId: string (nullable = true)
 |    |-- userName: string (nullable = true)
 |    |-- operation: string (nullable = true)
 |    |-- operationParameters: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- job: struct (nullable = true)
 |    |    |-- jobId: string (nullable = true)
 |    |    |-- jobName: string (nullable = true)
 |    |    |-- runId: string (nullable = true)
 |    |    |-- jobOwnerId: string (nullable = true)
 |    |    |-- triggerType: string (nullable = true)
 |    |-- notebook: struct (nullable = true)
 |    |    |-- notebookId: string (nullable = true)
 |    |-- clusterId: string (nullable = true)
 |    |-- readVersion: long (nullable = true)
 |    |-- isolationLevel: string (nullable = true)
 |    |-- isBlindAppend: boolean (nullable = true)
 |    |-- operationMetrics: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |    |-- userMetadata: string (nullable = true)
```

## <span id="fromJson"> Deserializing Action (from JSON)

```scala
fromJson(
  json: String): Action
```

`fromJson` utility...FIXME

`fromJson` is used when:

* `DeltaHistoryManager` is requested for [CommitInfo of the given delta file](DeltaHistoryManager.md#getCommitInfo)
* `DeltaLog` is requested for the [changes of the given delta version and later](DeltaLog.md#getChanges)
* `OptimisticTransactionImpl` is requested to [checkForConflicts](OptimisticTransactionImpl.md#checkForConflicts)
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge)
