---
title: DropFeature
---

# DropFeature Table Change

`DropFeature` is a `TableChange` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/TableChange)).

`DropFeature` is used when `AbstractDeltaCatalog` is requested to [alter a table](../../AbstractDeltaCatalog.md#alterTable) (to create a [AlterTableDropFeatureDeltaCommand](AlterTableDropFeatureDeltaCommand.md)).

## Creating Instance

`DropFeature` takes the following to be created:

* <span id="featureName"> Name of the feature to drop
* <span id="truncateHistory"> `truncateHistory` flag

`DropFeature` is created when:

* `AlterTableDropFeature` command is requested for the [table changes](AlterTableDropFeature.md#changes)
