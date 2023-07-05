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

`shouldMaterializeSource` returns a pair of the following:

1. Whether the given `source` plan can be materialized (checkpointed) or not (`Boolean`)
1. The reason for the decision (`MergeIntoMaterializeSourceReason`)

`shouldMaterializeSource` is controlled by [spark.databricks.delta.merge.materializeSource](../../configuration-properties/index.md#merge.materializeSource).

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
* `MergeIntoMaterializeSource` is requested to [prepare the source table](#prepareSourceDFAndReturnMaterializeReason)

## Preparing Source Table { #prepareSourceDFAndReturnMaterializeReason }

```scala
prepareSourceDFAndReturnMaterializeReason(
  spark: SparkSession,
  source: LogicalPlan,
  condition: Expression,
  matchedClauses: Seq[DeltaMergeIntoMatchedClause],
  notMatchedClauses: Seq[DeltaMergeIntoNotMatchedClause],
  isInsertOnly: Boolean): MergeIntoMaterializeSourceReason.MergeIntoMaterializeSourceReason
```

`prepareSourceDFAndReturnMaterializeReason` [shouldMaterializeSource](#shouldMaterializeSource).

??? note "shouldMaterializeSource"
    `shouldMaterializeSource` gives whether the source table has been materialized or not (`materialize`) and the reason of the decision (`materializeReason`).

When decided not to [materialize](#shouldMaterializeSource), `prepareSourceDFAndReturnMaterializeReason` creates a `DataFrame` for the given `source` logical plan that is available as the [sourceDF](#sourceDF) from now on. `prepareSourceDFAndReturnMaterializeReason` stops (and returns the reason for this rejection).

`prepareSourceDFAndReturnMaterializeReason` [finds the columns used in this MERGE command](#getReferencedSourceColumns) and creates a `Project` logical operator with the columns and the given `source` logical plan.

??? note "Column Pruning"
    With the `Project` logical operator and the columns used for this MERGE command, `prepareSourceDFAndReturnMaterializeReason` hopes for **Column Pruning** optimization.

`prepareSourceDFAndReturnMaterializeReason` creates a `DataFrame` (with the `Project` operator over the `source` logical plan) that is then checkpointed (using `Dataset.localCheckpoint` operator).

??? note "Local Checkpointing Lazily"
    `prepareSourceDFAndReturnMaterializeReason` uses `Dataset.localCheckpoint` operator with `eager` flag disabled so materialization (checkpointing) happens at first access.
    This is for more precise performance metrics.

`prepareSourceDFAndReturnMaterializeReason` stores the checkpointed `DataFrame` to be available later as the [materializedSourceRDD](#materializedSourceRDD). The name of the RDD is **mergeMaterializedSource**.

`prepareSourceDFAndReturnMaterializeReason` [add hints to the plan](#addHintsToPlan) (with the `source` and the analyzed logical plan of the checkpointed and column-pruned source `Dataset`) and creates a `DataFrame` that is available as the [sourceDF](#sourceDF) from now on.

`prepareSourceDFAndReturnMaterializeReason` caches (using `Dataset.persist` operator) the RDD with the storage level based on the following configuration properties:

* [spark.databricks.delta.merge.materializeSource.rddStorageLevel](../../configuration-properties/index.md#MERGE_MATERIALIZE_SOURCE_RDD_STORAGE_LEVEL) initially (based on the [attempt](#attempt))
* [spark.databricks.delta.merge.materializeSource.rddStorageLevelRetry](../../configuration-properties/index.md#MERGE_MATERIALIZE_SOURCE_RDD_STORAGE_LEVEL_RETRY) when retried (based on the [attempt](#attempt))

`prepareSourceDFAndReturnMaterializeReason` prints out the following DEBUG messages:

```text
Materializing MERGE with pruned columns [referencedSourceColumns].
Materialized MERGE source plan:
[getSourceDF]
```

In the end, `prepareSourceDFAndReturnMaterializeReason` returns the reason to materialize (`materializeReason` from [shouldMaterializeSource](#shouldMaterializeSource)).

---

`prepareSourceDFAndReturnMaterializeReason` is used when:

* `MergeIntoCommand`  is requested to [run merge](MergeIntoCommand.md#runMerge)

## Logging

`MergeIntoMaterializeSource` is an abstract class and logging is configured using the logger of the [MergeIntoCommand](MergeIntoCommand.md#logging).
