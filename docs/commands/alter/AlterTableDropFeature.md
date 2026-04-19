---
title: DROP FEATURE
---

# AlterTableDropFeature Command

`AlterTableDropFeature` is an `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand)) unary logical operator that represents [ALTER TABLE DROP FEATURE](../../sql/index.md#ALTER-TABLE-DROP-FEATURE) SQL command in a logical query plan.

`AlterTableDropFeature` supports a single feature removal (by the [feature name](#featureName)).

`AlterTableDropFeature` becomes an [AlterTableDropFeatureDeltaCommand](AlterTableDropFeatureDeltaCommand.md) at execution time (when `AbstractDeltaCatalog` is requested to [alter a table](../../AbstractDeltaCatalog.md#alterTable)).

## Creating Instance

`AlterTableDropFeature` takes the following to be created:

* <span id="table"> Table (`LogicalPlan`)
* <span id="featureName"> Name of the feature to drop
* <span id="truncateHistory"> `truncateHistory` flag

`AlterTableDropFeature` is created when:

* `DeltaSqlAstBuilder` is requested to [parse ALTER TABLE DROP FEATURE SQL command](../../sql/DeltaSqlAstBuilder.md#visitAlterTableDropFeature)

## TableChanges { #changes }

??? note "AlterTableCommand"

    ```scala
    changes: Seq[TableChange]
    ```

    `changes` is part of the `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand/#changes)) abstraction.

`changes` is just a single [DropFeature](DropFeature.md) (for this [name of the feature to drop](#featureName) and [truncateHistory](#truncateHistory) flag).
