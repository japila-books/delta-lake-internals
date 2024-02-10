---
hide:
  - toc
subtitle: Clustered Tables
---

# Liquid Clustering

**Liquid Clustering** (_Clustered Tables_) is an optimization technique in Delta Lake based on [OPTIMIZE](../commands/optimize/index.md) command with [Hilbert clustering](../commands/optimize/HilbertClustering.md).

!!! warning "Not Recommended for Production Use"
    1. A clustered table is currently in preview and is disabled by default.
    1. A clustered table is not recommended for production use (e.g., unsupported incremental clustering).

Liquid Clustering optimization can be executed on delta tables automatically or manually, at write time with [Auto Compaction](../auto-compaction/index.md) enabled or at any time using [OPTIMIZE](../commands/optimize/index.md) command, respectively.

Liquid Clustering can be enabled system-wide using [spark.databricks.delta.clusteredTable.enableClusteringTablePreview](../configuration-properties/index.md#spark.databricks.delta.clusteredTable.enableClusteringTablePreview) configuration property.

```sql
SET spark.databricks.delta.clusteredTable.enableClusteringTablePreview=true
```

Liquid Clustering can only be used on delta tables created with [CLUSTER BY](#cluster-by-clause) clause.

```sql
CREATE TABLE IF NOT EXISTS delta_table
USING delta
CLUSTER BY (id)
AS
  SELECT * FROM values 1, 2, 3 t(id)
```

At write time, Delta Lake registers [AutoCompact](../auto-compaction/AutoCompact.md) post-commit hook (part of [Auto Compaction](../auto-compaction/index.md) feature) that determines the type of optimization (incl. Liquid Clustering).

The clustering columns of a delta table are stored (_persisted_) in a table catalog (as [clusteringColumns](ClusteredTableUtilsBase.md#clusteringColumns) table property).

```sql
DESC EXTENDED delta_table
```

```text
+----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-------+
|col_name                    |data_type                                                                                                                                               |comment|
+----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-------+
|id                          |int                                                                                                                                                     |NULL   |
|                            |                                                                                                                                                        |       |
|# Detailed Table Information|                                                                                                                                                        |       |
|Name                        |spark_catalog.default.delta_table                                                                                                                       |       |
|Type                        |MANAGED                                                                                                                                                 |       |
|Location                    |file:/Users/jacek/dev/oss/spark/spark-warehouse/delta_table                                                                                             |       |
|Provider                    |delta                                                                                                                                                   |       |
|Owner                       |jacek                                                                                                                                                   |       |
|Table Properties            |[clusteringColumns=[["id"]],delta.feature.clustering=supported,delta.feature.domainMetadata=supported,delta.minReaderVersion=1,delta.minWriterVersion=7]|       |
+----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-------+
```

## CLUSTER BY Clause

!!! note "Spark 4.0.0"
    With [SPARK-44886](https://issues.apache.org/jira/browse/SPARK-44886) resolved, support for clustered tables is slated to be available natively in Apache Spark 4.0.0 🔥

`CLUSTER BY` clause is made available in `CREATE`/`REPLACE` SQL using [ClusterByParserUtils](ClusterByParserUtils.md) that is needed until a native support in Apache Spark is provided for catalog/datasource implementations to use for clustering.

```sql
CREATE TABLE tbl(a int, b string)
CLUSTER BY (a, b)
```

## Limitations

1. Liquid Clustering cannot be used with partitioning (`PARTITIONED BY`)
1. Liquid Clustering cannot be used with bucketing (`CLUSTERED BY INTO BUCKETS`)
1. Liquid Clustering can be used with 2 and [up to 9 columns](../commands/optimize/MultiDimClusteringFunctions.md#hilbert_index) to `CLUSTER BY`.
