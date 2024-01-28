---
title: DeltaInvariantChecker
---

# DeltaInvariantChecker Unary Logical Operator

`DeltaInvariantChecker` is a `UnaryNode` ([Spark SQL]({{ book.spark_sql }}/logical-operators/UnaryNode/)).

## Creating Instance

`DeltaInvariantChecker` takes the following to be created:

* <span id="child"> Child `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="deltaConstraints"> [Constraint](Constraint.md)s

!!! note
    `DeltaInvariantChecker` does not seem to be created at all.

## Execution Planning

`DeltaInvariantChecker` is planned as [DeltaInvariantCheckerExec](DeltaInvariantCheckerExec.md) unary physical operator by [DeltaInvariantCheckerStrategy](DeltaInvariantCheckerStrategy.md) execution planning strategy.
