# CDF Table-Valued Functions

Delta Lake 2.3.0 comes with the following table-valued functions for [Change Data Feed](../change-data-feed/index.md):

* `table_changes` (_table changes by delta table name_)
* `table_changes_by_path`

```text
spark-sql> SHOW FUNCTIONS LIKE 'table_*';
table_changes
table_changes_by_path

spark-sql> DESC FUNCTION table_changes;
Function: table_changes
Class: org.apache.spark.sql.delta.CDCNameBased
Usage: N/A.

spark-sql> DESC FUNCTION table_changes_by_path;
Function: table_changes_by_path
Class: org.apache.spark.sql.delta.CDCPathBased
Usage: N/A.
```

The functions accepts two arguments for the time- or version range:

* `startingVersion` or `startingTimestamp`
* `endingVersion` or `endingTimestamp`

!!! tip "Learn More"
    Learn more about table-valued functions in [The Internals of Spark SQL]({{ book.spark_sql }}/table-valued-functions/).

## Internals

The CDF Table-Valued Functions are [DeltaTableValueFunction](DeltaTableValueFunction.md)s that are registered (_injected_) using [DeltaSparkSessionExtension](../DeltaSparkSessionExtension.md).

The CDF Table-Valued Functions are resolved (using [DeltaAnalysis](../DeltaAnalysis.md) logical resolution rule) into `LogicalRelation`s ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation)) with the [BaseRelation](../DeltaTableV2.md#toBaseRelation)s of the respective [DeltaTableV2](../DeltaTableV2.md)s with the following [CDC Options](../DeltaTableV2.md#cdcOptions):

* `startingVersion` or `startingTimestamp`
* `endingVersion` or `endingTimestamp`
* [readChangeFeed](../DeltaDataSource.md#CDC_ENABLED_KEY) enabled

## Demo

```sql
CREATE TABLE delta_demo (
  ID LONG,
  name STRING)
USING delta;
INSERT INTO delta_demo VALUES (0, "zero");
INSERT INTO delta_demo VALUES (1, "one");
```

=== "SQL"

    ```sql
    DESC HISTORY delta_demo;
    ```

```text
2	2023-03-26 19:14:47.895	NULL	NULL	WRITE	{"mode":"Append","partitionBy":"[]"}	NULL	NULL	NULL	1	Serializable	true	{"numFiles":"1","numOutputBytes":"705","numOutputRows":"1"}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
1	2023-03-26 19:14:38.828	NULL	NULL	WRITE	{"mode":"Append","partitionBy":"[]"}	NULL	NULL	NULL	0	Serializable	true	{"numFiles":"1","numOutputBytes":"712","numOutputRows":"1"}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
0	2023-03-26 19:14:06.261	NULL	NULL	CREATE TABLE	{"description":null,"isManaged":"true","partitionBy":"[]","properties":"{}"}	NULL	NULL	NULL	NULL	Serializabletrue	{}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
```

=== "SQL"

    ```sql
    SELECT * FROM table_changes("delta_demo", 0, 2);
    ```

```text
Error in query: Error getting change data for range [0 , 2] as change data was not
recorded for version [0]. If you've enabled change data feed on this table,
use `DESCRIBE HISTORY` to see when it was first enabled.
Otherwise, to start recording change data, use `ALTER TABLE table_name SET TBLPROPERTIES
(delta.enableChangeDataFeed=true)`.
```

```sql
ALTER TABLE delta_demo SET TBLPROPERTIES
(delta.enableChangeDataFeed=true);
```

```sql
INSERT INTO delta_demo VALUES (2, "two");
INSERT INTO delta_demo VALUES (3, "three");
```

=== "SQL"

    ```sql
    DESC HISTORY delta_demo;
    ```

```text
5	2023-03-26 19:53:51.526	NULL	NULL	WRITE	{"mode":"Append","partitionBy":"[]"}	NULL	NULL	NULL	4	Serializable	true	{"numFiles":"1","numOutputBytes":"719","numOutputRows":"1"}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
4	2023-03-26 19:53:48.756	NULL	NULL	WRITE	{"mode":"Append","partitionBy":"[]"}	NULL	NULL	NULL	3	Serializable	true	{"numFiles":"1","numOutputBytes":"705","numOutputRows":"1"}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
3	2023-03-26 19:48:42.872	NULL	NULL	SET TBLPROPERTIES	{"properties":"{"delta.enableChangeDataFeed":"true"}"}	NULL	NULL	NULL	2	Serializable	true	{}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
2	2023-03-26 19:14:47.895	NULL	NULL	WRITE	{"mode":"Append","partitionBy":"[]"}	NULL	NULL	NULL	1	Serializable	true	{"numFiles":"1","numOutputBytes":"705","numOutputRows":"1"}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
1	2023-03-26 19:14:38.828	NULL	NULL	WRITE	{"mode":"Append","partitionBy":"[]"}	NULL	NULL	NULL	0	Serializable	true	{"numFiles":"1","numOutputBytes":"712","numOutputRows":"1"}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
0	2023-03-26 19:14:06.261	NULL	NULL	CREATE TABLE	{"description":null,"isManaged":"true","partitionBy":"[]","properties":"{}"}	NULL	NULL	NULL	NULL	Serializabletrue	{}	NULL	Apache-Spark/3.3.2 Delta-Lake/2.3.0rc1
```

=== "SQL"

    ```sql
    SELECT * FROM table_changes("delta_demo", 3, 5);
    ```

```text
3	three	insert	5	2023-03-26 19:53:51.526
2	two     insert	4	2023-03-26 19:53:48.756
```
