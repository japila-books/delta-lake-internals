= DescribeDeltaDetailCommand (And DescribeDeltaDetailCommandBase)

`DescribeDeltaDetailCommand` represents `DESCRIBE DETAIL` SQL command at execution (and is <<creating-instance, created>> when `DeltaSqlAstBuilder` is requested to <<DeltaSqlAstBuilder.md#visitDescribeDeltaDetail, parse DESCRIBE DETAIL SQL command>>).

Like `DESCRIBE DETAIL` SQL command, `DescribeDeltaDetailCommand` accepts either a <<path, path>> or a <<table, table>> (e.g. `'/tmp/delta/t1'` or `++delta.`/tmp/delta/t1`++`)

```
(DESC | DESCRIBE) DETAIL (path | table)
```

[[demo]]
.DESCRIBE DETAIL SQL Command's Demo
```
val q = sql("DESCRIBE DETAIL '/tmp/delta/users'")
scala> q.show
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
|format|                  id|name|description|            location|           createdAt|       lastModified|partitionColumns|numFiles|sizeInBytes|properties|minReaderVersion|minWriterVersion|
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
| delta|3799b291-dbfa-4f8...|null|       null|file:/tmp/delta/u...|2020-01-06 17:08:...|2020-01-06 17:12:28| [city, country]|       4|       2581|        []|               1|               2|
+------+--------------------+----+-----------+--------------------+--------------------+-------------------+----------------+--------+-----------+----------+----------------+----------------+
```

[[implementations]]
`DescribeDeltaDetailCommand` is the default and only known <<DescribeDeltaDetailCommandBase, DescribeDeltaDetailCommandBase>> in Delta Lake.

[[DescribeDeltaDetailCommandBase]]
`DescribeDeltaDetailCommandBase` is an extension of the `RunnableCommand` contract (from Spark SQL) for <<implementations, runnable commands>>.

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-LogicalPlan-RunnableCommand.html[RunnableCommand] in https://bit.ly/spark-sql-internals[The Internals of Spark SQL] online book.

== [[creating-instance]] Creating DescribeDeltaDetailCommand Instance

`DescribeDeltaDetailCommand` takes the following to be created:

* [[path]] Table path
* [[tableIdentifier]] Table identifier (e.g. `t1` or `++delta.`/tmp/delta/t1`++`)

== [[run]] Running Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of the `RunnableCommand` contract to...FIXME.

`run`...FIXME
