---
hide:
  - toc
---

# Row Tracking

!!! danger "Under Development"
    Row Tracking is under development and only available in testing.

**Row Tracking** is enabled on a delta table using [delta.enableRowTracking](../DeltaConfigs.md#ROW_TRACKING_ENABLED) table property.

=== "SQL"

    ```sql
    CREATE TABLE tbl(a int)
    USING delta
    TBLPROPERTIES (
      'delta.enableRowTracking' = 'true'
    )
    ```
