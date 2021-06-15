---
hide:
  - toc
---

# Generated Columns

**Generated Columns** are columns of a delta table with generation expressions.

**Generation Expression** is a SQL expression to generate values at write time (unless provided by a query). Generation expressions are attached to a column using [delta.generationExpression](../DeltaSourceUtils.md) metadata key.

Generated Columns can be defined using [DeltaColumnBuilder.generatedAlwaysAs](../DeltaColumnBuilder.md#generatedAlwaysAs) operator.

Generated Columns is a new feature in Delta Lake 1.0.0.

## Demo

```scala
val dataPath = "/tmp/delta/values"
```

```scala
import io.delta.tables.DeltaTable
import org.apache.spark.sql.types.DataTypes
```

```scala
val dt = DeltaTable.create
  .addColumn("id", DataTypes.LongType, nullable = false)
  .addColumn(
    DeltaTable.columnBuilder("value")
      .dataType(DataTypes.BooleanType)
      .generatedAlwaysAs("true")
      .build)
  .location(dataPath)
  .execute
```

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
