---
hide:
  - navigation
---

# Demo: User Metadata for Labelling Commits

The demo shows how to differentiate commits of a write batch query using [userMetadata](../DeltaOptions.md#userMetadata) option.

!!! tip
    A fine example could be for distinguishing between two or more separate streaming write queries.

## Creating Delta Table

```text
val tableName = "/tmp/delta-demo-userMetadata"
```

```text
spark.range(5)
  .write
  .format("delta")
  .save(tableName)
```

## Describing History

```scala
import io.delta.tables.DeltaTable
val d = DeltaTable.forPath(tableName)
```

We are interested in a subset of the available history metadata.

```scala
d.history
  .select('version, 'operation, 'operationParameters, 'userMetadata)
  .show(truncate = false)
```

```text
+-------+---------+------------------------------------------+------------+
|version|operation|operationParameters                       |userMetadata|
+-------+---------+------------------------------------------+------------+
|0      |WRITE    |[mode -> ErrorIfExists, partitionBy -> []]|null        |
+-------+---------+------------------------------------------+------------+
```

## Appending Data

In this step, you're going to append new data to the existing Delta table.

You're going to use [userMetadata](../DeltaOptions.md#userMetadata) option for a custom user-defined historical marker (e.g. to know when this extra append happended in the life of the Delta table).

```text
val userMetadata = "two more rows for demo"
```

Since you're appending new rows, it is required to use `Append` mode.

```scala
import org.apache.spark.sql.SaveMode.Append
```

The whole append write is as follows:

```scala
spark.range(start = 5, end = 7)
  .write
  .format("delta")
  .option("userMetadata", userMetadata)
  .mode(Append)
  .save(tableName)
```

That write query creates another version of the Delta table.

## Listing Versions with userMetadata

For the sake of the demo, you are going to show the versions of the Delta table with `userMetadata` defined.

```scala
d.history
  .select('version, 'operation, 'operationParameters, 'userMetadata)
  .where('userMetadata.isNotNull)
  .show(truncate = false)
```

```text
+-------+---------+-----------------------------------+----------------------+
|version|operation|operationParameters                |userMetadata          |
+-------+---------+-----------------------------------+----------------------+
|1      |WRITE    |[mode -> Append, partitionBy -> []]|two more rows for demo|
+-------+---------+-----------------------------------+----------------------+
```
