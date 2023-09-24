# DescribeDeltaDetailCommand

`DescribeDeltaDetailCommand` is a leaf `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) that represents [DESCRIBE DETAIL](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaDetail) SQL command at execution.

```text
(DESC | DESCRIBE) DETAIL (path | table)
```

## Creating Instance

`DescribeDeltaDetailCommand` takes the following to be created:

* <span id="path"> (optional) Table Path
* <span id="tableIdentifier"> (optional) Table identifier

`DescribeDeltaDetailCommand` is created when:

* `DeltaSqlAstBuilder` is requested to [parse DESCRIBE DETAIL SQL command](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaDetail)

## Output (Schema) Attributes { #output }

??? note "QueryPlan"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the `QueryPlan` ([Spark SQL]({{ book.spark_sql }}/catalyst/QueryPlan#output)) abstraction.

`output` is the fields of [TableDetail](TableDetail.md).

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run`...FIXME

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
