---
title: DeltaReorgTable
---

# DeltaReorgTable Unary Logical Operator

`DeltaReorgTable` is a unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/UnaryCommand)) that represents [REORG TABLE](index.md) SQL command in a logical query plan.

`DeltaReorgTable` is resolved into a [DeltaReorgTableCommand](DeltaReorgTableCommand.md) at [DeltaAnalysis](../../DeltaAnalysis.md#DeltaReorgTable).
