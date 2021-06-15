---
hide:
  - toc
---

# Generated Columns

**Generated Columns** are columns of a delta table with generation expressions.

**Generation Expression** is a SQL expression to generate values at write time (unless provided by a query). Generation expressions are attached to a column using [delta.generationExpression](../DeltaSourceUtils.md) metadata key.

Generated Columns can be defined using [DeltaColumnBuilder.generatedAlwaysAs](../DeltaColumnBuilder.md#generatedAlwaysAs) operator.

Generated Columns is a new feature in Delta Lake 1.0.0.
