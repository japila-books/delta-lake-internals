---
title: RestoreTableStatement
---

# RestoreTableStatement Unary Logical Operator

`RestoreTableStatement` is a unary logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan#UnaryNode)) that represents the following:

* [RESTORE TABLE](../../sql/index.md#RESTORE) SQL statement
* [DeltaTable.restoreToVersion](../../DeltaTable.md#restoreToVersion) operation
* [DeltaTable.restoreToTimestamp](../../DeltaTable.md#restoreToTimestamp) operation

## Creating Instance

`RestoreTableStatement` takes the following to be created:

* <span id="table"> [TimeTravel](TimeTravel.md) specification

`RestoreTableStatement` is created when:

* `DeltaSqlAstBuilder` is requested to [parse RESTORE SQL statement](../../sql/DeltaSqlAstBuilder.md#visitRestore)
* `DeltaTableOperations` is requested to [executeRestore](../../DeltaTableOperations.md#executeRestore)

## Analysis Phase

`RestoreTableStatement` is resolved to [RestoreTableCommand](RestoreTableCommand.md) (by [DeltaAnalysis](../../DeltaAnalysis.md#RestoreTableStatement) logical resolution rule).
