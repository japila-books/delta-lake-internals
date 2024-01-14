# DeltaOptions

`DeltaOptions` is a type-safe abstraction of the supported [write](DeltaWriteOptions.md) and [read](DeltaReadOptions.md) options.

`DeltaOptions` is used to create [WriteIntoDelta](../commands/WriteIntoDelta.md) command, [DeltaSink](DeltaSink.md), and [DeltaSource](DeltaSource.md).

```scala
import org.apache.spark.sql.delta.DeltaOptions

assert(DeltaOptions.OVERWRITE_SCHEMA_OPTION == "overwriteSchema")

val options = new DeltaOptions(Map.empty[String, String], spark.sessionState.conf)
assert(options.failOnDataLoss, "failOnDataLoss should be enabled by default")

val options = new DeltaOptions(
  Map(DeltaOptions.OVERWRITE_SCHEMA_OPTION -> true.toString),
  spark.sessionState.conf)
assert(
  options.canOverwriteSchema,
  s"${DeltaOptions.OVERWRITE_SCHEMA_OPTION} should be enabled")
```

## Creating Instance

`DeltaOptions` takes the following to be created:

* <span id="options"> Case-Insensitive Options
* <span id="sqlConf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf))

When created, `DeltaOptions` [verifies](#verifyOptions) the [options](#options).

## Verifying Options { #verifyOptions }

```scala
verifyOptions(
  options: CaseInsensitiveMap[String]): Unit
```

`verifyOptions` finds invalid options among the input `options`.

!!! note
    In the open-source version `verifyOptions` does really nothing. The underlying objects (`recordDeltaEvent` and the others) are no-ops.

`verifyOptions` is used when:

* `DeltaOptions` is [created](#creating-instance)
* `DeltaDataSource` is requested for a [relation (for loading data in batch queries)](DeltaDataSource.md#RelationProvider-createRelation)

## Serializable { #Serializable }

`DeltaOptions` is a `Serializable` ([Java]({{ java.api }}/java/io/Serializable.html)) (so it can be used in Spark tasks).
