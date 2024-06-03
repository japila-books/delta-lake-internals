---
title: DROP FEATURE
---

# AlterTableDropFeature

`AlterTableDropFeature` is a `AlterTableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/AlterTableCommand)) unary logical operator that represents [ALTER TABLE DROP FEATURE](../../sql/index.md#ALTER-TABLE-DROP-FEATURE) SQL command in a logical query plan.

`AlterTableDropFeature` supports a single feature removal (by the [feature name](#featureName)).

## Creating Instance

`AlterTableDropFeature` takes the following to be created:

* <span id="table"> Table (`LogicalPlan`)
* <span id="featureName"> Feature name
* <span id="truncateHistory"> `truncateHistory` flag

`AlterTableDropFeature` is created when:

* `DeltaSqlAstBuilder` is requested to [parse ALTER TABLE DROP FEATURE SQL command](../../sql/DeltaSqlAstBuilder.md#visitAlterTableDropFeature)
