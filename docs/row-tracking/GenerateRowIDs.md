---
title: GenerateRowIDs
---

# GenerateRowIDs Logical Plan Normalization Rule

`GenerateRowIDs` is a logical rule (`Rule[LogicalPlan]`) that Delta Lake injects into `SparkSession` (using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md)).

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule#apply)) abstraction.

`apply` transforms the [scans on delta tables with Row Tracking enabled](DeltaScanWithRowTrackingEnabled.md) in the given `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan)) bottom-up.

`apply`...FIXME

### metadataWithRowTrackingColumnsProjection { #metadataWithRowTrackingColumnsProjection }

```scala
metadataWithRowTrackingColumnsProjection(
  metadata: AttributeReference): NamedExpression
```

`metadataWithRowTrackingColumnsProjection`...FIXME

### rowIdExpr { #rowIdExpr }

```scala
rowIdExpr(
  metadata: AttributeReference): Expression
```

`rowIdExpr` creates a `Coalesce` expression with the following expressions:

1. `row_id` (sub)attribute of the given `AttributeReference`
    ```
    _metadata.row_id
    ```
1. `Add` expression of the `base_row_id` and `row_index` attributes of the given `AttributeReference`

    ```
    _metadata.base_row_id + _metadata.row_index
    ```
