# Installation

Installation of Delta Lake boils down to using spark-submit's `--packages` command-line option with the following configuration properties for [DeltaSparkSessionExtension](DeltaSparkSessionExtension.md) and [DeltaCatalog](DeltaCatalog.md):

* `spark.sql.extensions` ([Spark SQL]({{ book.spark_sql }}/StaticSQLConf/#spark.sql.extensions))
* `spark.sql.catalog.spark_catalog` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.catalog.spark_catalog))

Make sure that the version of Scala in Apache Spark should match Delta Lake's.

## <span id="application"> Spark SQL Application

```scala
import org.apache.spark.sql.SparkSession
val spark = SparkSession
  .builder
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
   /___/ .__/\_,_/_/ /_/\_\   version 3.2.1
      /_/

Using Scala version 2.12.15, OpenJDK 64-Bit Server VM, 11.0.14
```

```text
./bin/spark-shell \
  --packages io.delta:delta-core_2.12:1.2.0 \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog
```

## <span id="VERSION"> Version

`io.delta.VERSION` can be used to show the version of Delta Lake installed.

```text
scala> println(io.delta.VERSION)
1.2.0
```

It is also possible to use [DESCRIBE HISTORY](sql/index.md#DESCRIBE-HISTORY) and check out the [engineInfo](CommitInfo.md#engineInfo) column.
