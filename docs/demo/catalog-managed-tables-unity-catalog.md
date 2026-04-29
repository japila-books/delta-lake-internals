---
hide:
  - navigation
---

# Demo: Catalog-Managed Tables with Unity Catalog

This demo shows how to set up a Apache Spark environment with Delta Lake for [Catalog-Managed Tables](../catalog-managed-tables/index.md) in [Unity Catalog]({{ book.unity_catalog }}).

For this demo, you will use `pyspark` as the Apache Spark environment.

## Set Up Unity Catalog Server

Set up a Unity Catalog server as described in [this demo](https://books.japila.pl/spark-declarative-pipelines/demo/unity-catalog/#set-up-unity-catalog-server).

You should do the following:

1. Enable MANAGED table (experimental feature)
2. Start Unity Catalog
3. Create Demo Catalog with Storage Root
4. Create Default Schema in Demo Catalog

You should now have `demo.default` schema available with the `demo` catalog with a storage location.

```shell
❯ ./bin/uc catalog list --output json | jq '.[] | [.name, .storage_root]'
[
  "demo",
  "file:///tmp/demo_storage_root"
]
[
  "unity",
  null
]
```

## Start PySpark

```shell
uvx --from "pyspark==4.1.1" pyspark \
  --packages io.delta:delta-spark_2.13:4.2.0,io.unitycatalog:unitycatalog-spark_2.13:0.4.1,org.slf4j:slf4j-api:2.0.17 \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=io.unitycatalog.spark.UCSingleCatalog \
  --conf spark.sql.catalog.spark_catalog.uri=http://localhost:8080 \
  --conf spark.sql.catalog.spark_catalog.type=static \
  --conf spark.sql.catalog.spark_catalog.token=some_token \
  --conf spark.sql.catalog.demo=io.unitycatalog.spark.UCSingleCatalog \
  --conf spark.sql.catalog.demo.uri=http://localhost:8080 \
  --conf spark.sql.catalog.demo.type=static \
  --conf spark.sql.catalog.demo.token=some_token
```

??? note "How to start Spark application differently"
    Review some other options to start a Spark application with Unity Catalog and Delta Lake available in [Run Spark Application with Unity Catalog]({{ book.unity_catalog }}/demo/spark-connector/#optional-build-spark-connector).

## Create Catalog-Managed Delta Table

While in `pyspark`, create a delta table with [delta.feature.catalogManaged](../catalog-managed-tables/index.md) table property enabled.

```python
sql("""
CREATE TABLE demo.default.delta_table(a int)
USING delta
TBLPROPERTIES (
  "delta.feature.catalogManaged" = "supported"
)
""")
```

Insert some records.

```python
sql("INSERT INTO demo.default.delta_table VALUES (1),(2),(3)")
```

Query the table.

```text
>>> spark.table("demo.default.delta_table").show(truncate=False)
+---+
|a  |
+---+
|1  |
|2  |
|3  |
+---+
```

## Review Catalog-Managed Delta Table

```text
>>> sql("SHOW TBLPROPERTIES demo.default.delta_table").show(truncate=False, n=100)
+---------------------------------------------------------------+------------------------------------------------------------+
|key                                                            |value                                                       |
+---------------------------------------------------------------+------------------------------------------------------------+
|delta.checkpointPolicy                                         |v2                                                          |
|delta.enableDeletionVectors                                    |true                                                        |
|delta.enableInCommitTimestamps                                 |true                                                        |
|delta.enableRowTracking                                        |true                                                        |
|delta.feature.appendOnly                                       |supported                                                   |
|delta.feature.catalogManaged                                   |supported                                                   |
|delta.feature.deletionVectors                                  |supported                                                   |
|delta.feature.domainMetadata                                   |supported                                                   |
|delta.feature.inCommitTimestamp                                |supported                                                   |
|delta.feature.invariants                                       |supported                                                   |
|delta.feature.rowTracking                                      |supported                                                   |
|delta.feature.v2Checkpoint                                     |supported                                                   |
|delta.feature.vacuumProtocolCheck                              |supported                                                   |
|delta.minReaderVersion                                         |3                                                           |
|delta.minWriterVersion                                         |7                                                           |
|delta.rowTracking.materializedRowCommitVersionColumnName       |_row-commit-version-col-8c0fafce-a56d-4df8-acb7-d3f7ef51350f|
|delta.rowTracking.materializedRowIdColumnName                  |_row-id-col-c3df4b30-71fc-4721-b3a1-6a86f9a4c04b            |
|io.unitycatalog.tableId                                        |177ff3f5-a09e-4edc-b426-3bac3be7d75c                        |
|option.delta.checkpointPolicy                                  |v2                                                          |
|option.delta.enableDeletionVectors                             |true                                                        |
|option.delta.enableInCommitTimestamps                          |true                                                        |
|option.delta.enableRowTracking                                 |true                                                        |
|option.delta.feature.appendOnly                                |supported                                                   |
|option.delta.feature.catalogManaged                            |supported                                                   |
|option.delta.feature.deletionVectors                           |supported                                                   |
|option.delta.feature.domainMetadata                            |supported                                                   |
|option.delta.feature.inCommitTimestamp                         |supported                                                   |
|option.delta.feature.invariants                                |supported                                                   |
|option.delta.feature.rowTracking                               |supported                                                   |
|option.delta.feature.v2Checkpoint                              |supported                                                   |
|option.delta.feature.vacuumProtocolCheck                       |supported                                                   |
|option.delta.lastCommitTimestamp                               |1777473704010                                               |
|option.delta.lastUpdateVersion                                 |0                                                           |
|option.delta.minReaderVersion                                  |3                                                           |
|option.delta.minWriterVersion                                  |7                                                           |
|option.delta.rowTracking.materializedRowCommitVersionColumnName|_row-commit-version-col-8c0fafce-a56d-4df8-acb7-d3f7ef51350f|
|option.delta.rowTracking.materializedRowIdColumnName           |_row-id-col-c3df4b30-71fc-4721-b3a1-6a86f9a4c04b            |
|option.io.unitycatalog.tableId                                 |177ff3f5-a09e-4edc-b426-3bac3be7d75c                        |
|option.table_type                                              |MANAGED                                                     |
+---------------------------------------------------------------+------------------------------------------------------------+
```
