# DeltaMergeBuilder

**DeltaMergeBuilder** is a [builder interface](#operators) to describe how to merge data from a [source DataFrame](#source) into the [target](#targetTable) delta table.

## Creating Instance

`DeltaMergeBuilder` takes the following to be created:

* <span id="targetTable"> Target [DeltaTable](DeltaTable.md)
* <span id="source"> Source `DataFrame`
* <span id="onCondition"> Condition `Column`
* <span id="whenClauses"> [When Clauses](DeltaMergeIntoClause.md)

`DeltaMergeBuilder` is created using [DeltaTable.merge](DeltaTable.md#merge) operator.

## Operators

### <span id="whenMatched"> whenMatched

```scala
whenMatched(): DeltaMergeMatchedActionBuilder
whenMatched(
  condition: Column): DeltaMergeMatchedActionBuilder
whenMatched(
  condition: String): DeltaMergeMatchedActionBuilder
```

Creates a [DeltaMergeMatchedActionBuilder](DeltaMergeMatchedActionBuilder.md) (for the `DeltaMergeBuilder` and a condition)

### <span id="whenNotMatched"> whenNotMatched

```scala
whenNotMatched(): DeltaMergeNotMatchedActionBuilder
whenNotMatched(
  condition: Column): DeltaMergeNotMatchedActionBuilder
whenNotMatched(
  condition: String): DeltaMergeNotMatchedActionBuilder
```

Creates a [DeltaMergeNotMatchedActionBuilder](DeltaMergeNotMatchedActionBuilder.md) (for the `DeltaMergeBuilder` and a condition)

## <span id="execute"> Executing Merge Operation

```scala
execute(): Unit
```

`execute` resolves column references (and creates a `MergeInto`).

In the end, execute creates a [PreprocessTableMerge](PreprocessTableMerge.md) to create and run a [MergeIntoCommand](MergeIntoCommand.md).

## <span id="mergePlan"> Creating Logical Plan for Merge

```scala
mergePlan: DeltaMergeInto
```

`mergePlan` creates a [DeltaMergeInto](DeltaMergeInto.md) logical command.

`mergePlan` is used when `DeltaMergeBuilder` is requested to [execute](#execute).

## <span id="apply"> Creating DeltaMergeBuilder

```scala
apply(
  targetTable: DeltaTable,
  source: DataFrame,
  onCondition: Column): DeltaMergeBuilder
```

`apply` creates a new `DeltaMergeBuilder` for the given parameters and no [DeltaMergeIntoClauses](#whenClauses).

`apply` is used for [DeltaTable.merge](DeltaTable.md#merge) operator.

## <span id="withClause"> Adding DeltaMergeIntoClause

```scala
withClause(
  clause: DeltaMergeIntoClause): DeltaMergeBuilder
```

`withClause` creates a new `DeltaMergeBuilder` (based on the existing properties, e.g. the [DeltaTable](#targetTable)) with the given [DeltaMergeIntoClause](DeltaMergeIntoClause.md) added to the existing [DeltaMergeIntoClauses](#whenClauses) (to create a more refined `DeltaMergeBuilder`).

`withClause` is used when:

* [DeltaMergeMatchedActionBuilder](DeltaMergeMatchedActionBuilder.md) is requested to [updateAll](DeltaMergeMatchedActionBuilder.md#updateAll), [delete](DeltaMergeMatchedActionBuilder.md#delete) and [addUpdateClause](DeltaMergeMatchedActionBuilder.md#addUpdateClause)
* [DeltaMergeMatchedActionBuilder](DeltaMergeNotMatchedActionBuilder.md) is requested to [insertAll](DeltaMergeNotMatchedActionBuilder.md#insertAll) and [addInsertClause](DeltaMergeNotMatchedActionBuilder.md#addInsertClause)

## Demo

```text
// Create a delta table
val path = "/tmp/delta/demo"
val data = spark.range(5)
data.write.format("delta").save(path)

// Manage the delta table
import io.delta.tables.DeltaTable
val target = DeltaTable.forPath(path)

scala> :type target
io.delta.tables.DeltaTable

case class Person(id: Long, name: String)
val source = Seq(Person(0, "Zero"), Person(1, "One")).toDF

// Note the difference in schemas

scala> target.toDF.printSchema
root
 |-- id: long (nullable = true)

scala> source.printSchema
root
 |-- id: long (nullable = false)
 |-- name: string (nullable = true)

// Not only do we update the matching rows
// But also update the schema (schema evolution)

val mergeBuilder = target.as("to")
  .merge(
    source = source.as("from"),
    condition = $"to.id" === $"from.id")

scala> :type mergeBuilder
io.delta.tables.DeltaMergeBuilder

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
