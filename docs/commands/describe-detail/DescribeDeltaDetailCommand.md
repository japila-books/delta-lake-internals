# DescribeDeltaDetailCommand (DescribeDeltaDetailCommandBase)

`DescribeDeltaDetailCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) for [DESCRIBE DETAIL](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaDetail) SQL command.

```text
(DESC | DESCRIBE) DETAIL (path | table)
```

## Creating Instance

`DescribeDeltaDetailCommand` takes the following to be created:

* <span id="path"> (optional) Table Path
* <span id="tableIdentifier"> (optional) Table identifier

`DescribeDeltaDetailCommand` is created when:

* `DeltaSqlAstBuilder` is requested to [parse DESCRIBE DETAIL SQL command](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaDetail))

## <span id="run"> run

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run`...FIXME

## Demo

```scala
val q = sql("DESCRIBE DETAIL '/tmp/delta/users'")
```

```text
scala> q.show
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
|format|                  id|name|description|            location|           createdAt|       lastModified|partitionColumns|numFiles|sizeInBytes|properties|minReaderVersion|minWriterVersion|
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
| delta|3799b291-dbfa-4f8...|null|       null|file:/tmp/delta/u...|2020-01-06 17:08:...|2020-01-06 17:12:28| [city, country]|       4|       2581|        []|               1|               2|
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
```
