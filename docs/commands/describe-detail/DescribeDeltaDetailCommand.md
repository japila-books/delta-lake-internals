# DescribeDeltaDetailCommand

`DescribeDeltaDetailCommand` is a leaf `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) that represents the following high-level operators at execution:

* [DESCRIBE DETAIL](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaDetail) SQL command
* [DeltaTable.detail](../../DeltaTable.md#detail)

## Creating Instance

`DescribeDeltaDetailCommand` takes the following to be created:

* <span id="child"> Child logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan))
* <span id="hadoopConf"> Hadoop Configuration (`Map[String, String]`)

`DescribeDeltaDetailCommand` is created using [apply](#apply) utility.

## Create DescribeDeltaDetailCommand { #apply }

```scala
apply(
  path: Option[String],
  tableIdentifier: Option[TableIdentifier],
  hadoopConf: Map[String, String]): DescribeDeltaDetailCommand
```

`apply` creates a `UnresolvedPathOrIdentifier` for the optional `path` and `tableIdentifier`.

In the end, `apply` creates a [DescribeDeltaDetailCommand](#creating-instance).

---

`apply` is used when:

* `DeltaSqlAstBuilder` is requested to [parse DESCRIBE DETAIL SQL command](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaDetail)
* `DeltaTableOperations` is requested to [executeDetails](../../DeltaTableOperations.md#executeDetails)

## Output (Schema) Attributes { #output }

??? note "QueryPlan"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the `QueryPlan` ([Spark SQL]({{ book.spark_sql }}/catalyst/QueryPlan#output)) abstraction.

`output` is the fields of [TableDetail](TableDetail.md).

## Execute Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` [finds the CatalogTable](../DeltaCommand.md#getTableCatalogTable) (of this [table](#child)).

`run`...FIXME

For an existing delta table (the [version](../../Snapshot.md#version) is at least `0`), `run` [describeDeltaTable](#describeDeltaTable).

### describeDeltaTable { #describeDeltaTable }

```scala
describeDeltaTable(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  snapshot: Snapshot,
  tableMetadata: Option[CatalogTable]): Seq[Row]
```

`describeDeltaTable`...FIXME

## Demo

=== "SQL"

    ```scala
    DESCRIBE DETAIL '/tmp/delta/users'
    ```

```text
scala> q.show
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
|format|                  id|name|description|            location|           createdAt|       lastModified|partitionColumns|numFiles|sizeInBytes|properties|minReaderVersion|minWriterVersion|
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
| delta|3799b291-dbfa-4f8...|null|       null|file:/tmp/delta/u...|2020-01-06 17:08:...|2020-01-06 17:12:28| [city, country]|       4|       2581|        []|               1|               2|
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
```
