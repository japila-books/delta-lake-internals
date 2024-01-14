---
title: DeltaDelete
---

# DeltaDelete Unary Logical Command

`DeltaDelete` is an unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/UnaryNode/)) that represents `DeleteFromTable`s ([Spark SQL]({{ book.spark_sql }}/logical-operators/DeleteFromTable/)) at execution.

As per the [comment]({{ delta.github }}/spark/src/main/scala/org/apache/spark/sql/catalyst/plans/logical/DeltaDelete.scala#L21-L22):

> Needs to be compatible with DBR 6 and can't use the new class added in Spark 3.0: `DeleteFromTable`.

## Creating Instance

`DeltaDelete` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="condition"> Condition Expression ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/))

`DeltaDelete` is created when:

* [DeltaAnalysis](../../DeltaAnalysis.md) logical resolution rule is executed and resolves `DeleteFromTable`s

## Logical Resolution

`DeltaDelete` is resolved to a [DeleteCommand](DeleteCommand.md) when [PreprocessTableDelete](../../PreprocessTableDelete.md) post-hoc logical resolution rule is executed.
