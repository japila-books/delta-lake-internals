# Demo: Merge Operation

This demo shows [DeltaTable.merge](../DeltaTable.md#merge) operation (and the underlying [MergeIntoCommand](../commands/MergeIntoCommand.md)) in action.

!!! tip
    Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.MergeIntoCommand` logger as described in [Logging](../commands/MergeIntoCommand.md#logging).

## Create Delta Table (Target Data)

```scala
val path = "/tmp/delta/demo"
val data = spark.range(5)
data.write.format("delta").mode("overwrite").save(path)

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

Note the difference in schemas

```text
scala> target.toDF.printSchema
root
 |-- id: long (nullable = true)

scala> source.printSchema
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

```text
assert(mergeBuilder.isInstanceOf[io.delta.tables.DeltaMergeBuilder])
scala> mergeBuilder.execute
org.apache.spark.sql.AnalysisException: There must be at least one WHEN clause in a MERGE query;
  at org.apache.spark.sql.catalyst.plans.logical.DeltaMergeInto$.apply(deltaMerge.scala:217)
  at io.delta.tables.DeltaMergeBuilder.mergePlan(DeltaMergeBuilder.scala:255)
  at io.delta.tables.DeltaMergeBuilder.$anonfun$execute$1(DeltaMergeBuilder.scala:228)
  at org.apache.spark.sql.delta.util.AnalysisHelper.improveUnsupportedOpError(AnalysisHelper.scala:60)
  at org.apache.spark.sql.delta.util.AnalysisHelper.improveUnsupportedOpError$(AnalysisHelper.scala:48)
  at io.delta.tables.DeltaMergeBuilder.improveUnsupportedOpError(DeltaMergeBuilder.scala:121)
  at io.delta.tables.DeltaMergeBuilder.execute(DeltaMergeBuilder.scala:225)
  ... 47 elided
```

```scala
val mergeMatchedBuilder = mergeBuilder.whenMatched()
assert(mergeMatchedBuilder.isInstanceOf[io.delta.tables.DeltaMergeMatchedActionBuilder])

val mergeBuilderDeleteMatched = mergeMatchedBuilder.delete()
assert(mergeBuilderDeleteMatched.isInstanceOf[io.delta.tables.DeltaMergeBuilder])

mergeBuilderDeleteMatched.execute()

assert(target.history.count == 2, "There must be two versions only")
```
