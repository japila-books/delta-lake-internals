# Installation

Delta Lake is a Spark data source and as such installation boils down to using spark-submit's `--packages` command-line option with the following configuration properties for [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md) and [DeltaCatalog](DeltaCatalog.md):

* `spark.sql.extensions` ([Spark SQL]({{ book.spark_sql }}/StaticSQLConf/#spark.sql.extensions))
* `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog))

!!! important
    Delta Lake {{ delta.version }} supports Apache Spark 3.1.1 (cf. [delta](https://github.com/delta-io/delta/blob/e36dc6b9ca8ea8e893080dcea847978d5835125b/build.sbt#L19) repository on GitHub).

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
$ ./bin/spark-shell --version
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.1.2
      /_/

Using Scala version 2.12.10, OpenJDK 64-Bit Server VM, 11.0.13
```

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:{{ delta.version }} \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```
