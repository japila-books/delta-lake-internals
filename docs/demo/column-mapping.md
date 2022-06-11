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

=== "SQL"

    ```sql
    DROP TABLE IF EXISTS delta101;
    CREATE TABLE delta101 USING delta VALUES (0) t(id)
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

The above command runs into the following issue (which is fairly self-explanatory):

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

Let's upgrade the table protocol and enable column mapping all in one go.

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

## Review Schema

At the current setup, the physical column names (there is only `id`, actually) are the only column names.

You can use a Spark SQL way to access the schema.

=== "Spark SQL"

    ```scala
    println(spark.table(tableName).schema.prettyJson)
    ```

```text
{
  "type" : "struct",
  "fields" : [ {
    "name" : "id",
    "type" : "integer",
    "nullable" : true,
    "metadata" : { }
  } ]
}
```

A much elaborative way is to use Delta Lake API (that includes column mapping metadata).

=== "Delta Lake"

    ```scala
    import org.apache.spark.sql.catalyst.TableIdentifier
    val tid = TableIdentifier(tableName)

    import org.apache.spark.sql.delta.DeltaTableIdentifier
    val dtId = DeltaTableIdentifier(table = Some(tid))

    import org.apache.spark.sql.delta.DeltaLog
    val table = DeltaLog.forTable(spark, dtId)

    println(table.snapshot.metadata.schema.prettyJson)
    ```

```text
{
  "type" : "struct",
  "fields" : [ {
    "name" : "id",
    "type" : "long",
    "nullable" : true,
    "metadata" : {
      "delta.columnMapping.id" : 1,
      "delta.columnMapping.physicalName" : "id"
    }
  } ]
}
```

## Rename Column

Let's rename the `id` column using [ALTER TABLE RENAME COLUMN](../commands/alter/AlterTableChangeColumnDeltaCommand.md) command and review the schema again.

=== "Scala"

    ```scala
    sql(s"ALTER TABLE $tableName RENAME COLUMN id TO new_id")
    ```

## Describe History

`ALTER TABLE RENAME COLUMN` is a transactional change of the metadata of a delta table and is recorded in the [transaction log](../DeltaLog.md).

=== "Scala"

    ```scala
    sql("desc history delta101")
      .select('version, 'operation, 'operationParameters)
      .show(truncate = false)
    ```

```text
+-------+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
|version|operation             |operationParameters                                                                                                                        |
+-------+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
|2      |CHANGE COLUMN         |{column -> {"name":"new_id","type":"long","nullable":true,"metadata":{"delta.columnMapping.id":1,"delta.columnMapping.physicalName":"id"}}}|
|1      |SET TBLPROPERTIES     |{properties -> {"delta.minReaderVersion":"2","delta.minWriterVersion":"5","delta.columnMapping.mode":"name"}}                              |
|0      |CREATE TABLE AS SELECT|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}                                                              |
+-------+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
```

## Review Schema (After Column Mapping)

### Catalog Table View

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

This time you're going to read the data files without Delta Lake to know and review the schema (as is in the parquet files themselves). That will show you the physical column names as they are in parquet data files.

=== "Scala"

    ```text
    spark.read.format("parquet").load(s"spark-warehouse/$tableName").printSchema
    ```

```text
root
|-- id: long (nullable = true)
```

So, parquet files with the data of a delta table know about `id` column while Delta Lake maps it over to `new_id` at load time.

### Delta Lake View

In the end, let's have a look at the schema using Delta Lake API.

=== "Delta Lake"

    ```scala
    import org.apache.spark.sql.catalyst.TableIdentifier
    val tid = TableIdentifier(tableName)

    import org.apache.spark.sql.delta.DeltaTableIdentifier
    val dtId = DeltaTableIdentifier(table = Some(tid))

    import org.apache.spark.sql.delta.DeltaLog
    val table = DeltaLog.forTable(spark, dtId)

    println(table.snapshot.metadata.schema.prettyJson)
    ```

```text
{
  "type" : "struct",
  "fields" : [ {
    "name" : "new_id",
    "type" : "long",
    "nullable" : true,
    "metadata" : {
      "delta.columnMapping.id" : 1,
      "delta.columnMapping.physicalName" : "id"
    }
  } ]
}
```

Note the new `name` (`new_id`) and the associated metadata.
