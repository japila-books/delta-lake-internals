---
hide:
  - navigation
---

# Demo: Merge Operation

This demo shows [DeltaTable.merge](../DeltaTable.md#merge) operation (and the underlying [MergeIntoCommand](../commands/merge/MergeIntoCommand.md)) in action.

!!! tip
    Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.MergeIntoCommand` logger as described in [Logging](../commands/merge/MergeIntoCommand.md#logging).

## Create Delta Table (Target Data)

### Modern Delta Lake-Own Create Table

```scala
val path = "/tmp/delta/demo"
import io.delta.tables.DeltaTable
val target = DeltaTable.create.addColumn("id", "long").location(path).execute
```

```scala
assert(target.isInstanceOf[io.delta.tables.DeltaTable])
assert(target.history.count == 1, "There must be version 0 only")
```

Unfortunately, the above leaves us with an empty Delta table. Let's fix it.

```scala
import org.apache.spark.sql.SaveMode
spark.range(5).write.format("delta").mode(SaveMode.Append).save(path)
```

```scala
assert(target.history.count == 2)
```

### Legacy Spark-Based Create Table

!!! note
    This legacy Spark-based `CREATE TABLE` is left for comparison purposes only.

```scala
val path = "/tmp/delta/demo"
val data = spark.range(5)
data.write.format("delta").save(path)

import io.delta.tables.DeltaTable
val target = DeltaTable.forPath(path)

assert(target.isInstanceOf[io.delta.tables.DeltaTable])
assert(target.history.count == 1, "There must be version 0 only")
```

## Source Data

```scala
case class Person(id: Long, name: String)
val source = Seq(Person(0, "Zero"), Person(1, "One")).toDF
```

Note the difference in the schema of the `target` and `source` datasets.

```scala
target.toDF.printSchema
```

```text
root
 |-- id: long (nullable = true)
```

```scala
source.printSchema
```

```text
root
 |-- id: long (nullable = false)
 |-- name: string (nullable = true)
```

## Merge with Schema Evolution

Not only do we update the matching rows, but also update the schema (schema evolution)

```scala
val mergeBuilder = target.as("to")
  .merge(
    source = source.as("from"),
    condition = $"to.id" === $"from.id")
```

```scala
assert(mergeBuilder.isInstanceOf[io.delta.tables.DeltaMergeBuilder])
```

```text
scala> mergeBuilder.execute
org.apache.spark.sql.AnalysisException: There must be at least one WHEN clause in a MERGE statement
  at org.apache.spark.sql.catalyst.plans.logical.DeltaMergeInto$.apply(deltaMerge.scala:253)
  at io.delta.tables.DeltaMergeBuilder.mergePlan(DeltaMergeBuilder.scala:268)
  at io.delta.tables.DeltaMergeBuilder.$anonfun$execute$1(DeltaMergeBuilder.scala:215)
  at org.apache.spark.sql.delta.util.AnalysisHelper.improveUnsupportedOpError(AnalysisHelper.scala:87)
  at org.apache.spark.sql.delta.util.AnalysisHelper.improveUnsupportedOpError$(AnalysisHelper.scala:73)
  at io.delta.tables.DeltaMergeBuilder.improveUnsupportedOpError(DeltaMergeBuilder.scala:120)
  at io.delta.tables.DeltaMergeBuilder.execute(DeltaMergeBuilder.scala:204)
  ... 47 elided
```

```scala
val mergeMatchedBuilder = mergeBuilder.whenMatched()
assert(mergeMatchedBuilder.isInstanceOf[io.delta.tables.DeltaMergeMatchedActionBuilder])

val mergeBuilderDeleteMatched = mergeMatchedBuilder.delete()
assert(mergeBuilderDeleteMatched.isInstanceOf[io.delta.tables.DeltaMergeBuilder])

mergeBuilderDeleteMatched.execute()
```

```scala
assert(target.history.count == 3)
```

## Update All Columns Except One

This demo shows how to update all columns except one on a match.

```scala
val targetDF = target
  .toDF
  .withColumn("num", lit(1))
  .withColumn("updated", lit(false))
```

```scala
targetDF.sort('id.asc).show
```

```text
+---+---+-------+
| id|num|updated|
+---+---+-------+
|  2|  1|  false|
|  3|  1|  false|
|  4|  1|  false|
+---+---+-------+
```

Write the modified data out to the delta table (that will create a new version with the schema changed).

```scala
targetDF
  .write
  .format("delta")
  .mode("overwrite")
  .option("overwriteSchema", true)
  .save(path)
```

Reload the delta table (with the new column changes).

```scala
val target = DeltaTable.forPath(path)
val targetDF = target.toDF
```

```scala
val sourceDF = Seq(0, 1, 2).toDF("num")
```

Create an update map (with the columns of the target delta table and the new values).

```scala
val updates = Map(
  "updated" -> lit(true))
```

```scala
target.as("to")
  .merge(
    source = sourceDF.as("from"),
    condition = $"to.id" === $"from.num")
  .whenMatched.update(updates)
  .execute()
```

Reload the delta table (with the merge changes).

```text
val target = DeltaTable.forPath(path)
target.toDF.sort('id.asc).show
```

```text
+---+---+-------+
| id|num|updated|
+---+---+-------+
|  2|  1|   true|
|  3|  1|  false|
|  4|  1|  false|
+---+---+-------+
```

```scala
assert(target.history.count == 5)
```
