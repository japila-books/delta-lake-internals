---
hide:
  - navigation
---

# Demo: Generated Columns

This demo shows [Generated Columns](../generated-columns/index.md) in action.

## Create Delta Table with Generated Column

This step uses [DeltaColumnBuilder](../DeltaColumnBuilder.md) API to define a generated column using [DeltaColumnBuilder.generatedAlwaysAs](../DeltaColumnBuilder.md#generatedAlwaysAs).

```scala
import io.delta.tables.DeltaTable
val tableName = "delta_gencols"
sql(s"DROP TABLE IF EXISTS $tableName")
```

### Primitive Type

```scala
import org.apache.spark.sql.types.DataTypes

DeltaTable.create
  .addColumn("id", DataTypes.LongType, nullable = false)
  .addColumn(
    DeltaTable.columnBuilder("value")
      .dataType(DataTypes.BooleanType)
      .generatedAlwaysAs("true")
      .build)
  .tableName(tableName)
  .execute
```

### Complex Type

With a complex type (e.g., `StructType`), you have to define fields with `nullable` disabled. Otherwise, you run into a very mysterious exception (that you don't want to spend you time on).

```scala
import org.apache.spark.sql.types._

val dataType = StructType(
  StructField("long", LongType, nullable = false) ::
  StructField("str", StringType, nullable = false) :: Nil)

val generationExpr = "struct(id AS long, 'hello' AS str)"

val generatedColumn = DeltaTable.columnBuilder("metadata")
  .dataType(dataType)
  .generatedAlwaysAs(generationExpr)
  .build

DeltaTable.createOrReplace
  .addColumn("id", LongType, nullable = false)
  .addColumn(generatedColumn)
  .tableName(tableName)
  .execute
```

## Review Metadata

=== "Scala"

    ```scala
    import org.apache.spark.sql.delta.DeltaLog
    import org.apache.spark.sql.catalyst.TableIdentifier
    val deltaLog = DeltaLog.forTable(spark, TableIdentifier(tableName))
    ```

    ```scala
    println(deltaLog.snapshot.metadata.dataSchema("value").metadata.json)
    ```

```text
{"delta.generationExpression":"true"}
```

## Write to Delta Table

=== "Scala"

    ```scala
    spark.range(5).writeTo(tableName).append()
    ```

=== "SQL"

    !!! bug ""

        The following SQL query fails with an `AnalysisException` due to [this issue]({{ delta.issues }}/1215).

    ```sql
    --- FIXME: Fails with org.apache.spark.sql.
    sql("""
    INSERT INTO delta_gencols (id)
    SELECT * FROM RANGE(5)
    """)
    ```

## Show Table

=== "Scala"

    ```scala
    spark.table(tableName).orderBy('id).show
    ```

=== "SQL"

    ```sql
    SELECT * FROM delta_gencols
    ORDER BY id
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

It is possible to give the value of the generated column, but it has to pass a `CHECK` constraint.

The following one-row query will break the constraint since the value is not `true`.

=== "Scala"

    ```scala
    Seq(5L).toDF("id")
      .withColumn("value", lit(false))
      .writeTo(tableName)
      .append()
    ```

```text
org.apache.spark.sql.delta.schema.InvariantViolationException: CHECK constraint Generated Column (value <=> true) violated by row with values:
 - value : false
  at org.apache.spark.sql.delta.schema.InvariantViolationException$.apply(InvariantViolationException.scala:72)
  at org.apache.spark.sql.delta.schema.InvariantViolationException$.apply(InvariantViolationException.scala:82)
  at org.apache.spark.sql.delta.schema.InvariantViolationException.apply(InvariantViolationException.scala)
  at org.apache.spark.sql.catalyst.expressions.GeneratedClass$SpecificUnsafeProjection.apply(Unknown Source)
  at org.apache.spark.sql.delta.constraints.DeltaInvariantCheckerExec.$anonfun$doExecute$3(DeltaInvariantCheckerExec.scala:87)
```
