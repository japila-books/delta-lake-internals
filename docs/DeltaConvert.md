# DeltaConvert Utility

`DeltaConvert` utility is used exclusively for <<executeConvert, importing a parquet table into Delta Lake (DeltaConvert.executeConvert)>>.

`DeltaConvert` utility can be used directly or indirectly via <<DeltaTable.md#convertToDelta, DeltaTable.convertToDelta>> utility.

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

<span id="DeltaConvertBase">
`DeltaConvert` utility is a concrete `DeltaConvertBase`.

## <span id="executeConvert"> Importing Parquet Table Into Delta Lake (Converting Parquet Table To Delta Format)

```scala
executeConvert(
  spark: SparkSession,
  tableIdentifier: TableIdentifier,
  partitionSchema: Option[StructType],
  deltaPath: Option[String]): DeltaTable
```

`executeConvert` creates a new [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) and executes it.

In the end, `executeConvert` creates a [DeltaTable](DeltaTable.md).

!!! note
    `executeConvert` can convert a Spark table (to Delta) that is registered in a metastore.

`executeConvert` is used when `DeltaTable` utility is requested to [convert a parquet table to delta format (DeltaTable.convertToDelta)](DeltaTable.md#convertToDelta).
