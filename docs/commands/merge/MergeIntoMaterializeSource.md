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

## shouldMaterializeSource { #shouldMaterializeSource }

```scala
shouldMaterializeSource(
  spark: SparkSession,
  source: LogicalPlan,
  isInsertOnly: Boolean): (Boolean, MergeIntoMaterializeSourceReason)
```

`shouldMaterializeSource` uses [spark.databricks.delta.merge.materializeSource](../../configuration-properties/index.md#merge.materializeSource) configuration property to determine the output pair (`(Boolean, MergeIntoMaterializeSourceReason)`).

merge.materializeSource | Boolean | MergeIntoMaterializeSourceReason
------------------------|---------|---------------------------------
 `ALL` | `true` | `MATERIALIZE_ALL`
 `AUTO` | _see the table below_ |
 `NONE` | `false` | `NOT_MATERIALIZED_NONE`
 _any other value incl. invalid_ | `true` | `INVALID_CONFIG`

For `auto`, `shouldMaterializeSource` is as follows (in the order):

 Boolean | MergeIntoMaterializeSourceReason | Condition
---------|----------------------------------|----------
 `false` | `NOT_MATERIALIZED_AUTO_INSERT_ONLY` | <ol><li>The given `isInsertOnly` flag enabled</li><li>[merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#merge.optimizeInsertOnlyMerge.enabled) is enabled</li></ol>
 `true` | `NON_DETERMINISTIC_SOURCE_NON_DELTA` | The given `source` plan [contains non-Delta scans](#planContainsOnlyDeltaScans)
 `true` | `NON_DETERMINISTIC_SOURCE_OPERATORS` | The given `source` plan [is non-deterministic](#planIsDeterministic)
 `false` | `NOT_MATERIALIZED_AUTO` |

!!! note "`isInsertOnly` flag"
    The given `isInsertOnly` flag is driven by [isInsertOnly](MergeIntoCommandBase.md#isInsertOnly).

---

`shouldMaterializeSource` is used when:

* `MergeIntoCommandBase` is requested to [run](MergeIntoCommandBase.md#run)
* `MergeIntoMaterializeSource` is requested to [prepareSourceDFAndReturnMaterializeReason](#prepareSourceDFAndReturnMaterializeReason)

## Logging

`MergeIntoMaterializeSource` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
