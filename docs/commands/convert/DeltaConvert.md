# DeltaConvert Utility

## <span id="executeConvert"> executeConvert

```scala
executeConvert(
  spark: SparkSession,
  tableIdentifier: TableIdentifier,
  partitionSchema: Option[StructType],
  deltaPath: Option[String]): DeltaTable
```

`executeConvert` _converts_ a parquet table to a delta table.

`executeConvert` executes a new [ConvertToDeltaCommand](ConvertToDeltaCommand.md).

In the end, `executeConvert` creates a [DeltaTable](../../DeltaTable.md).

!!! note
    `executeConvert` can convert a Spark table (to Delta) that is registered in a metastore.

`executeConvert` is used when:

* [DeltaTable.convertToDelta](../../DeltaTable.md#convertToDelta) utility is used

## Demo

```text
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

// CONVERT TO DELTA only supports parquet tables
// TableIdentifier should be parquet.`users`
import org.apache.spark.sql.catalyst.TableIdentifier
val table = TableIdentifier(table = "users", database = Some("parquet"))

import org.apache.spark.sql.types.{StringType, StructField, StructType}
val partitionSchema: Option[StructType] = Some(
  new StructType().add(StructField("country", StringType)))

val deltaPath: Option[String] = None

// Use web UI to monitor execution, e.g. http://localhost:4040
import io.delta.tables.execution.DeltaConvert
DeltaConvert.executeConvert(spark, table, partitionSchema, deltaPath)
```
