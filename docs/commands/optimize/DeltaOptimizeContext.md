# DeltaOptimizeContext

`DeltaOptimizeContext` represents an execution context of the following commands:

* [OPTIMIZE](../optimize/index.md)
* [REORG TABLE](../reorg/index.md)

## Creating Instance

`DeltaOptimizeContext` takes the following to be created:

* [isPurge Flag](#isPurge)
* <span id="minFileSize"> `minFileSize` (default: undefined)
* <span id="maxDeletedRowsRatio"> `maxDeletedRowsRatio` (default: undefined)

`DeltaOptimizeContext` is created when:

* `DeltaOptimizeBuilder` is requested to [execute](../../DeltaOptimizeBuilder.md#execute)
* [DeltaReorgTableCommand](../reorg/DeltaReorgTableCommand.md) is executed
* `OptimizeTableCommand` is [created](OptimizeTableCommand.md#apply)

### isPurge Flag { #isPurge }

`DeltaOptimizeContext` can be given `isPurge` flag when [created](#creating-instance).

`isPurge` flag is used to indicate that a rewriting task is for purging soft-deleted data (with [Deletion Vectors](../../deletion-vectors/index.md)).

`isPurge` flag is disabled (`false`) by default.

When enabled (`true`), `DeltaOptimizeContext` requires that the [minFileSize](#minFileSize) and the [maxDeletedRowsRatio](#maxDeletedRowsRatio) are both `0`. Otherwise, `DeltaOptimizeContext` reports an `IllegalArgumentException`:

```text
minFileSize and maxDeletedRowsRatio must be 0 when running PURGE.
```
