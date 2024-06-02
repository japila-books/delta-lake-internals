# CREATE TABLE LIKE Command

Delta Lake supports creating an empty new delta table using `CREATE TABLE LIKE` DDL statement based on the definition and metadata of an existing table or view.

Delta Lake resolves `CREATE TABLE LIKE`s with a delta source table or `USING delta` (case-insensitive) to a [CreateDeltaTableCommand](../commands/create-table/CreateDeltaTableCommand.md) using [DeltaAnalysis](../DeltaAnalysis.md) logical resolution rule.

!!! note "CREATE TABLE LIKE Feature for Delta #1584"
    [CREATE TABLE LIKE Feature for Delta #1584](https://github.com/delta-io/delta/pull/1584).

## Demo

### Create Delta Table

```scala
spark.range(5)
  .withColumn("my_lit", lit(5))
  .writeTo("source_delta")
  .using("delta")
  .create
```

### Create Like Using Delta

```scala
sql("""
  CREATE TABLE target_like_delta
  LIKE source_delta
  USING delta
""").show(false)
```

```scala
sql("""
  DESC EXTENDED target_like_delta
""").show(false)
```

```text
+----------------------------+------------------------------------------------------------------------------------+-------+
|col_name                    |data_type                                                                           |comment|
+----------------------------+------------------------------------------------------------------------------------+-------+
|id                          |bigint                                                                              |       |
|my_lit                      |int                                                                                 |       |
|                            |                                                                                    |       |
|# Partitioning              |                                                                                    |       |
|Not partitioned             |                                                                                    |       |
|                            |                                                                                    |       |
|# Detailed Table Information|                                                                                    |       |
|Name                        |default.target_like_delta                                                           |       |
|Location                    |file:/Users/jacek/dev/apps/spark-3.3.2-bin-hadoop3/spark-warehouse/target_like_delta|       |
|Provider                    |delta                                                                               |       |
|Owner                       |jacek                                                                               |       |
|Table Properties            |[delta.minReaderVersion=1,delta.minWriterVersion=2]                                 |       |
+----------------------------+------------------------------------------------------------------------------------+-------+
```

### Create Like

```scala
sql("""
  CREATE TABLE target_like_delta_no_using
  LIKE source_delta
""").show(false)
```

```scala
sql("""
  DESC HISTORY target_like_delta_no_using
""").show(false)
```

```text
+-------+-----------------------+------+--------+------------+-----------------------------------------------------------------------------+----+--------+---------+-----------+--------------+-------------+----------------+------------+-----------------------------------+
|version|timestamp              |userId|userName|operation   |operationParameters                                                          |job |notebook|clusterId|readVersion|isolationLevel|isBlindAppend|operationMetrics|userMetadata|engineInfo                         |
+-------+-----------------------+------+--------+------------+-----------------------------------------------------------------------------+----+--------+---------+-----------+--------------+-------------+----------------+------------+-----------------------------------+
|0      |2023-04-07 20:13:17.669|null  |null    |CREATE TABLE|{isManaged -> true, description -> null, partitionBy -> [], properties -> {}}|null|null    |null     |null       |Serializable  |true         |{}              |null        |Apache-Spark/3.3.2 Delta-Lake/2.3.0|
+-------+-----------------------+------+--------+------------+-----------------------------------------------------------------------------+----+--------+---------+-----------+--------------+-------------+----------------+------------+-----------------------------------+
```
