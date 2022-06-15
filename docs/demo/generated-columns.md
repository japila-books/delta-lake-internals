---
hide:
  - navigation
---

# Demo: Generated Columns

This demo shows [Generated Columns](../generated-columns/index.md) in action.

## Create Delta Table with Generated Column

This step uses [DeltaColumnBuilder](../DeltaColumnBuilder.md) API to define a generated column using [DeltaColumnBuilder.generatedAlwaysAs](../DeltaColumnBuilder.md#generatedAlwaysAs).

=== "Scala"

    ```scala
    import io.delta.tables.DeltaTable
    import org.apache.spark.sql.types.DataTypes

    val dataPath = "/tmp/delta/values"
    DeltaTable.create
      .addColumn("id", DataTypes.LongType, nullable = false)
      .addColumn(
        DeltaTable.columnBuilder("value")
          .dataType(DataTypes.BooleanType)
          .generatedAlwaysAs("true")
          .build)
      .location(dataPath)
      .execute
    ```

## Review Metadata

```scala
import org.apache.spark.sql.delta.DeltaLog
val deltaLog = DeltaLog.forTable(spark, dataPath)
```

```scala
println(deltaLog.snapshot.metadata.dataSchema("value").metadata.json)
```

```text
{"delta.generationExpression":"true"}
```

## Write to Delta Table

```scala
import io.delta.implicits._
import org.apache.spark.sql.SaveMode
```

```scala
spark.range(5)
  .write
  .mode(SaveMode.Append)
  .delta(dataPath)
```

## Show Table

```scala
DeltaTable.forPath(dataPath).toDF.orderBy('id).show
```

```text
+---+-----+
| id|value|
+---+-----+
|  0| true|
|  1| true|
|  2| true|
|  3| true|
|  4| true|
+---+-----+
```

## InvariantViolationException

The following one-row query will break the CHECK constraint on the generated column since the value is not `true`.

```scala
spark.range(5, 6)
  .withColumn("value", lit(false))
  .write
  .mode(SaveMode.Append)
  .delta(dataPath)
```

```text
org.apache.spark.sql.delta.schema.InvariantViolationException: CHECK constraint Generated Column (`value` <=> true) violated by row with values:
 - value : false
  at org.apache.spark.sql.delta.schema.InvariantViolationException$.apply(InvariantViolationException.scala:50)
  at org.apache.spark.sql.delta.schema.InvariantViolationException$.apply(InvariantViolationException.scala:60)
  at org.apache.spark.sql.delta.schema.InvariantViolationException.apply(InvariantViolationException.scala)
  at org.apache.spark.sql.catalyst.expressions.GeneratedClass$SpecificUnsafeProjection.apply(Unknown Source)
  at org.apache.spark.sql.delta.constraints.DeltaInvariantCheckerExec.$anonfun$doExecute$3(DeltaInvariantCheckerExec.scala:86)
  at scala.collection.Iterator$$anon$10.next(Iterator.scala:459)
  at org.apache.spark.sql.execution.datasources.FileFormatWriter$.$anonfun$executeTask$1(FileFormatWriter.scala:278)
  at org.apache.spark.util.Utils$.tryWithSafeFinallyAndFailureCallbacks(Utils.scala:1473)
  at org.apache.spark.sql.execution.datasources.FileFormatWriter$.executeTask(FileFormatWriter.scala:286)
  at org.apache.spark.sql.execution.datasources.FileFormatWriter$.$anonfun$write$15(FileFormatWriter.scala:210)
  at org.apache.spark.scheduler.ResultTask.runTask(ResultTask.scala:90)
  at org.apache.spark.scheduler.Task.run(Task.scala:131)
  at org.apache.spark.executor.Executor$TaskRunner.$anonfun$run$3(Executor.scala:497)
  at org.apache.spark.util.Utils$.tryWithSafeFinally(Utils.scala:1439)
  at org.apache.spark.executor.Executor$TaskRunner.run(Executor.scala:500)
  at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
  at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
  at java.base/java.lang.Thread.run(Thread.java:829)
```
