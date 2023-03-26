---
title: DeltaTableValueFunction
---

# DeltaTableValueFunction Logical Operators

`DeltaTableValueFunction` is an [extension](#contract) of the `LeafNode` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafNode)) abstraction for [Delta table-valued functions](#implementations).

## Contract

### Function Arguments { #functionArgs }

```scala
functionArgs: Seq[Expression]
```

## Implementations

### CDCNameBased { #CDCNameBased }

Function name: [table_changes](#fnName)

### CDCPathBased { #CDCPathBased }

Function name: [table_changes_by_path](#fnName)

## Creating Instance

`DeltaTableValueFunction` takes the following to be created:

* <span id="fnName"> Function Name

!!! note "Abstract Class"
    `DeltaTableValueFunction` is an abstract class and cannot be created directly. It is created indirectly for the [concrete DeltaTableValueFunctions](#implementations).
