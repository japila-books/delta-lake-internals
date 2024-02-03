---
hide:
  - toc
subtitle: Clustered Tables
---

# Liquid Clustering

**Liquid Clustering** is an optimization technique in Delta Lake that...FIXME

!!! info "Not Recommended for Production Use"
    1. A clustered table is currently in preview and is disabled by default.
    1. A clustered table is not recommended for production use (e.g., unsupported incremental clustering).

Liquid Clustering is used for delta table that were created with `CLUSTER BY` clause.

Liquid Clustering is controlled using [spark.databricks.delta.clusteredTable.enableClusteringTablePreview](../configuration-properties/index.md#spark.databricks.delta.clusteredTable.enableClusteringTablePreview) configuration property.

The clustering columns of a delta table are stored in a table catalog (as an extra table property).

## Limitations

1. Liquid Clustering cannot be used with partitioning (`PARTITIONED BY`)
1. Liquid Clustering cannot be used with bucketing (`CLUSTERED BY INTO BUCKETS`)
