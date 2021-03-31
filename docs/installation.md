# Installation

Delta Lake is a Spark data source and as such installation boils down to using spark-submit's `--packages` command-line option with the following configuration properties for [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md) and [DeltaCatalog](DeltaCatalog.md):

* `spark.sql.extensions` ([Spark SQL]({{ book.spark_sql }}/StaticSQLConf/#spark.sql.extensions))
* `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog))

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
