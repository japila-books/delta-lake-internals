---
hide:
  - toc
---

# SHOW COLUMNS Command

Delta Lake supports displaying the details of the columns of delta tables using the following high-level operator:

* [SHOW COLUMNS](ShowDeltaTableColumnsCommand.md) SQL command

## Internals

Delta Lake "intercepts" (_takes care of_) resolving `ShowColumns` ([Spark SQL]({{ book.spark_sql }}/logical-operators/ShowColumns)) logical commands at [DeltaAnalysis](../../DeltaAnalysis.md).

The reason is that the schema of delta tables is stored in the [transaction log](../../SnapshotDescriptor.md#schema) (not a catalog).
