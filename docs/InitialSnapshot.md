# InitialSnapshot

`InitialSnapshot` is an initial [Snapshot](Snapshot.md) of a delta table (at the [logPath](#logPath)) that is about to be created (so there is no delta log yet).

`InitialSnapshot` is a [Snapshot](Snapshot.md) with the following:

Snapshot | Value
---------|------
 [LogSegment](Snapshot.md#logSegment) | [Empty transaction log directory](LogSegment.md#empty) (for the [logPath](#logPath))
 [minFileRetentionTimestamp](Snapshot.md#minFileRetentionTimestamp) | -1
 [minSetTransactionRetentionTimestamp](Snapshot.md#minSetTransactionRetentionTimestamp) | (undefined)
 [Path](Snapshot.md#path) | [logPath](#logPath)
 [Timestamp](Snapshot.md#timestamp) | -1
 [Version](Snapshot.md#version) | -1
 [VersionChecksum](Snapshot.md#checksumOpt) | (undefined)

## Creating Instance

`InitialSnapshot` takes the following to be created:

* <span id="logPath"> Path ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) of the Transaction Log
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="metadata"> [Metadata](Metadata.md)

`InitialSnapshot` is created when:

* `SnapshotManagement` is requested to [createSnapshotAtInitInternal](SnapshotManagement.md#createSnapshotAtInitInternal) and [installLogSegmentInternal](SnapshotManagement.md#installLogSegmentInternal)
* `ConvertToDeltaCommandBase` is requested to [createDeltaActions](commands/convert/ConvertToDeltaCommand.md#createDeltaActions)

### <span id="metadata"> Metadata

`InitialSnapshot` can be given a [Metadata](Metadata.md) when [created](#creating-instance). Unless given, `InitialSnapshot` creates a [Metadata](Metadata.md) with the following:

Metadata | Value
---------|------
 [configuration](#configuration) | [mergeGlobalConfigs](table-properties/DeltaConfigs.md#mergeGlobalConfigs)
 [createdTime](#createdTime) | Current time (in ms)

## <span id="computedState"> computedState

??? note "Signature"

    ```scala
    computedState: Snapshot.State
    ```

    `computedState` is part of the [Snapshot](Snapshot.md#computedState) abstraction.

`computedState` [initialState](#initialState).

??? note "Lazy Value"
    `computedState` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

??? question
    Why does `InitialSnapshot` define the private [initialState](#initialState) to initialize `computedState`? They could be one, couldn't they?

### <span id="initialState"> Initial State

```scala
initialState: Snapshot.State
```

`initialState`...FIXME
