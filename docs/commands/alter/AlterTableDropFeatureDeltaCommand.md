---
title: DROP FEATURE
---

# AlterTableDropFeatureDeltaCommand

`AlterTableDropFeatureDeltaCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)) logical operator that represents the following high-level operators at execution:

* [ALTER TABLE DROP FEATURE](AlterTableDropFeature.md) SQL command
* [DeltaTable.dropFeatureSupport](../../DeltaTable.md#dropFeatureSupport)

`AlterTableDropFeatureDeltaCommand` is an [AlterDeltaTableCommand](AlterDeltaTableCommand.md).

`AlterTableDropFeatureDeltaCommand` is an `IgnoreCachedData` ([Spark SQL]({{ book.spark_sql }}/logical-operators/IgnoreCachedData)) logical operator.

## Creating Instance

`AlterTableDropFeatureDeltaCommand` takes the following to be created:

* <span id="table"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="featureName"> Name of the feature to drop
* <span id="truncateHistory"> `truncateHistory` flag (default: `false`)

`AlterTableDropFeatureDeltaCommand` is created when:

* `AbstractDeltaCatalog` is requested to [alter a table](../../AbstractDeltaCatalog.md#alterTable) (with [DropFeature](DropFeature.md) table change)
* `DeltaTable` is requested to [dropFeatureSupport](../../DeltaTable.md#dropFeatureSupport)

## Execute Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run`...FIXME

### executeDropFeatureWithHistoryTruncation { #executeDropFeatureWithHistoryTruncation }

```scala
executeDropFeatureWithHistoryTruncation(
  sparkSession: SparkSession,
  removableFeature: TableFeature with RemovableFeature): Seq[Row]
```

`executeDropFeatureWithHistoryTruncation`...FIXME

### executeDropFeatureWithCheckpointProtection { #executeDropFeatureWithCheckpointProtection }

```scala
executeDropFeatureWithCheckpointProtection(
  sparkSession: SparkSession,
  removableFeature: TableFeature with RemovableFeature): Seq[Row]
```

`executeDropFeatureWithCheckpointProtection`...FIXME
