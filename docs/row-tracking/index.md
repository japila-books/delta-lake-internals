---
hide:
  - toc
---

# Row Tracking

!!! warning "Under Development"
    [Row IDs are still under development and only available in testing.]({{ delta.github }}/spark/src/main/scala/org/apache/spark/sql/delta/TableFeature.scala#L355)

**Row Tracking** is enabled on a delta table using [delta.enableRowTracking](../table-properties/DeltaConfigs.md#ROW_TRACKING_ENABLED) table property.

=== "SQL"

    ```sql
    CREATE TABLE tbl(a int)
    USING delta
    TBLPROPERTIES (
      'delta.enableRowTracking' = 'true'
    )
    ```
