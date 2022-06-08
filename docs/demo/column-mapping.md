---
hide:
  - navigation
---

# Demo: Column Mapping

This demo shows [Column Mapping](../column-mapping/index.md) in action.

## Create Delta Table

Let's create a delta table using a mixture of Scala and SQL.

=== "Scala"

    ```scala
    val tableName = "delta101"

    sql(s"DROP TABLE IF EXISTS $tableName")
    spark.range(1).writeTo(tableName).using("delta").create
    ```

## Enable Column Mapping (by Name)

=== "Scala"

    ```scala
    sql(s"""
      ALTER TABLE $tableName SET TBLPROPERTIES (
        'delta.columnMapping.mode' = 'name'
      )
      """)
    ```

=== "SQL"

    ```sql
    ALTER TABLE delta101 SET TBLPROPERTIES (
      'delta.columnMapping.mode' = 'name'
    )
    ```

The above command runs into the following issue (and looks self-explanatory):

```text
org.apache.spark.sql.delta.DeltaColumnMappingUnsupportedException:
Your current table protocol version does not support changing column mapping modes
using delta.columnMapping.mode.

Required Delta protocol version for column mapping:
Protocol(2,5)
Your table's current Delta protocol version:
Protocol(1,2)

Please upgrade your table's protocol version using ALTER TABLE SET TBLPROPERTIES and try again.
```

Let's upgrade the table protocol.

=== "Scala"

    ```scala
    sql(s"""
      ALTER TABLE $tableName SET TBLPROPERTIES (
        'delta.minReaderVersion' = '2',
        'delta.minWriterVersion' = '5',
        'delta.columnMapping.mode' = 'name'
      )
      """)
    ```

## Show Table Properties

=== "Scala"

    ```scala
    sql(s"SHOW TBLPROPERTIES $tableName").show(truncate = false)
    ```

```text
+-------------------------------+-------+
|key                            |value  |
+-------------------------------+-------+
|Type                           |MANAGED|
|delta.columnMapping.maxColumnId|1      |
|delta.columnMapping.mode       |name   |
|delta.minReaderVersion         |2      |
|delta.minWriterVersion         |5      |
+-------------------------------+-------+
```

## Rename Column

=== "Scala"

    ```scala
    spark.table(tableName).printSchema
    ```

```text
root
 |-- id: long (nullable = true)
```

=== "Scala"

    ```scala
    sql(s"ALTER TABLE $tableName RENAME COLUMN id TO new_id")
    ```

## Review Schema

### Delta Lake View

Let's review the schema again.

=== "Scala"

    ```scala
    spark.table(tableName).printSchema
    ```

```text
root
 |-- new_id: long (nullable = true)
```

### Parquet View

This time you're going to read the data files without Delta Lake to know and review the schema (as is in the parquet files themselves).

=== "Scala"

    ```text
    spark.read.format("parquet").load(s"spark-warehouse/$tableName").printSchema
    ```

```text
root
|-- id: long (nullable = true)
```

So, parquet files with the data of a delta table know about `id` column while Delta Lake maps it over to `new_id` at load time.
