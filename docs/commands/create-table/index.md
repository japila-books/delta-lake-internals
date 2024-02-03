# CREATE TABLE

```sql
CREATE TABLE (IF NOT EXISTS)? [table]...

(CREATE OR)? REPLACE TABLE [table]...
```

=== "SQL"

    ```sql
    CREATE TABLE IF NOT EXISTS delta_table
    USING delta
    AS
    SELECT * FROM values(1,2,3)
    ```
