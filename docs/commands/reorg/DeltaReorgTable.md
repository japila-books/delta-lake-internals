---
title: DeltaReorgTable
---

# DeltaReorgTable Unary Logical Operator

`DeltaReorgTable` is a unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/UnaryCommand)) that represents [REORG TABLE](index.md) SQL command in a logical query plan.

`DeltaReorgTable` is resolved into a [DeltaReorgTableCommand](DeltaReorgTableCommand.md) at [DeltaAnalysis](../../DeltaAnalysis.md#DeltaReorgTable) (for [DeltaTableV2](../../DeltaTableV2.md)s or throws a `DeltaAnalysisException`).

## Creating Instance

`DeltaReorgTable` takes the following to be created:

* <span id="target"> Target `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="predicates"> `WHERE` partition predicates

`DeltaReorgTable` is created when:

* `DeltaSqlAstBuilder` is requested to [parse REORG TABLE command](../../sql/DeltaSqlAstBuilder.md#visitReorgTable)
