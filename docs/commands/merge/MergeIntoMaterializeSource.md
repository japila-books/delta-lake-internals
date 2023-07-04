# MergeIntoMaterializeSource

`MergeIntoMaterializeSource` is an abstraction of [merge commands](#implementations) that can [materialize source table](#shouldMaterializeSource) when [executed](MergeIntoCommandBase.md#runMerge).

## Implementations

* [MergeIntoCommandBase](MergeIntoCommandBase.md)

## sourceDF { #sourceDF }

```scala
sourceDF: Option[Dataset[Row]] = None
```

??? note "Mutable Variable"
    `sourceDF` is a Scala `var`.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/04-basic-declarations-and-definitions.html#variable-declarations-and-definitions).

`sourceDF` is undefined (`None`) when `MergeIntoMaterializeSource` is created and after [runWithMaterializedSourceLostRetries](#runWithMaterializedSourceLostRetries).

`sourceDF` is assigned a `DataFrame` in [prepareSourceDFAndReturnMaterializeReason](#prepareSourceDFAndReturnMaterializeReason) (with no materialization or checkpointed).

When materialized, `sourceDF`'s execution plan is printed out in a DEBUG message:

```text
Materialized MERGE source plan:
[sourceDF]
```

When defined, `sourceDF` is available using [getSourceDF](#getSourceDF).

## getSourceDF { #getSourceDF }

```scala
getSourceDF: DataFrame
```

`getSourceDF` returns the [sourceDF](#sourceDF) if defined.

Otherwise, `getSourceDF` throws an `IllegalStateException` with the following message:

```text
sourceDF was not initialized! Call prepareSourceDFAndReturnMaterializeReason before.
```

---

`getSourceDF` is used when:

* `ClassicMergeExecutor` is requested to [findTouchedFiles](ClassicMergeExecutor.md#findTouchedFiles) and [writeAllChanges](ClassicMergeExecutor.md#writeAllChanges)
* `InsertOnlyMergeExecutor` is requested to [writeOnlyInserts](InsertOnlyMergeExecutor.md#writeOnlyInserts)

## Logging

`MergeIntoMaterializeSource` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
