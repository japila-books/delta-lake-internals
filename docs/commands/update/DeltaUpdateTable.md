---
title: DeltaUpdateTable
---

# DeltaUpdateTable Unary Logical Operator

`DeltaUpdateTable` is an unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/UnaryNode.md)) that represents `UpdateTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/UpdateTable/)) at execution.

## Creating Instance

`DeltaUpdateTable` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="updateColumns"> Update Column Expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/))
* <span id="updateExpressions"> Update Expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/))
* <span id="condition"> (optional) Condition Expression ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/))

`DeltaUpdateTable` is created when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed and resolves `UpdateTable`s

## Logical Resolution

`DeltaUpdateTable` is resolved to a [UpdateCommand](UpdateCommand.md) when [PreprocessTableUpdate](../../PreprocessTableUpdate.md) post-hoc logical resolution rule is executed.
