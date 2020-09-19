# Installation

Delta Lake is a Spark data source and as such installation boils down to using spark-submit's `--packages` command-line option.

Delta Lake also requires [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md) and [DeltaCatalog](DeltaCatalog.md) to be registered (using respective configuration properties).

## <span id="application"> Spark SQL Application

```scala
import org.apache.spark.sql.SparkSession
val spark = SparkSession
  .builder()
  .appName("...")
  .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
  .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
  .getOrCreate
```

## <span id="spark-shell"> Spark Shell

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```
