---
hide:
  - toc
subtitle: Clustered Tables
---

# Liquid Clustering

**Liquid Clustering** is an optimization technique in Delta Lake that uses [OPTIMIZE](../commands/optimize/index.md) with [Hilbert clustering](../commands/optimize/HilbertClustering.md).

!!! warning "Not Recommended for Production Use"
    1. A clustered table is currently in preview and is disabled by default.
    1. A clustered table is not recommended for production use (e.g., unsupported incremental clustering).

Liquid Clustering can be enabled system-wide using [spark.databricks.delta.clusteredTable.enableClusteringTablePreview](../configuration-properties/index.md#spark.databricks.delta.clusteredTable.enableClusteringTablePreview) configuration property.

```sql
SET spark.databricks.delta.clusteredTable.enableClusteringTablePreview=true
```

Liquid Clustering can only be applied to delta tables created with `CLUSTER BY` clause.

```sql
CREATE TABLE IF NOT EXISTS delta_table
USING delta
CLUSTER BY (id)
AS
  SELECT * FROM values 1, 2, 3 t(id)
```

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

## Limitations

1. Liquid Clustering cannot be used with partitioning (`PARTITIONED BY`)
1. Liquid Clustering cannot be used with bucketing (`CLUSTERED BY INTO BUCKETS`)
1. Liquid Clustering can be used with 2 and [up to 9 columns](../commands/optimize/MultiDimClusteringFunctions.md#hilbert_index) to `CLUSTER BY`.
