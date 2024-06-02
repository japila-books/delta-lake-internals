---
title: ResolveDeltaPathTable
---

# ResolveDeltaPathTable Logical Resolution Rule

`ResolveDeltaPathTable` is a logical resolution rule to [resolve "path-identified" delta tables](#resolveAsPathTable) (_direct query on files_).

??? note "Spark SQL"
    In Spark SQL words, `ResolveDeltaPathTable` is a Catalyst `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/)) to resolve `UnresolvedTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/UnresolvedTable/)) leaf logical operators.

`ResolveDeltaPathTable` is registered (_injected_) using [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md).

## resolveAsPathTable { #resolveAsPathTable }

```scala
resolveAsPathTable(
  sparkSession: SparkSession,
  multipartIdentifier: Seq[String],
  options: Map[String, String]): Option[ResolvedTable]
```

`resolveAsPathTable` asserts that there is support for `datasource`.`path` as table identifiers in SQL queries (based on `spark.sql.runSQLOnFiles` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.runSQLOnFiles))) and that there are exactly two parts in the given `multipartIdentifier`.

`resolveAsPathTable` assumes that neither `spark.sql.runSQLOnFiles` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.runSQLOnFiles)) configuration property is disabled nor there are exactly two parts in the given `multipartIdentifier`. If either holds, `resolveAsPathTable` returns `None` (_undefined value_).

`resolveAsPathTable` creates a [DeltaTableV2](DeltaTableV2.md) for a [valid table identifier](DeltaTableUtils.md#isValidPath).

`resolveAsPathTable` uses a session `CatalogManager` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/CatalogManager/)) to access the `TableCatalog` (based on `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog))).

In the end, `resolveAsPathTable` creates a `ResolvedTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/ResolvedTable/)) with the `DeltaTableV2` (and the `TableCatalog`).

For all other cases, `resolveAsPathTable` return `None` (_undefined value_).
