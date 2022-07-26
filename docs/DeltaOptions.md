# DeltaOptions

`DeltaOptions` is a type-safe abstraction of the supported [write](DeltaWriteOptions.md) and [read](DeltaReadOptions.md) options.

`DeltaOptions` is used to create [WriteIntoDelta](commands/WriteIntoDelta.md) command, [DeltaSink](DeltaSink.md), and [DeltaSource](DeltaSource.md).

## Creating Instance

`DeltaOptions` takes the following to be created:

* <span id="options"> Case-Insensitive Options
* <span id="sqlConf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf))

When created, `DeltaOptions` [verifies](#verifyOptions) the [options](#options).

`DeltaOptions` is created when:

* `DeltaLog` is requested for a [relation](DeltaLog.md#createRelation) (for [DeltaDataSource](DeltaDataSource.md) as a [CreatableRelationProvider](DeltaDataSource.md#CreatableRelationProvider) and a [RelationProvider](DeltaDataSource.md#RelationProvider))
* `DeltaCatalog` is requested to [createDeltaTable](DeltaCatalog.md#createDeltaTable)
* `WriteIntoDeltaBuilder` is requested to [buildForV1Write](WriteIntoDeltaBuilder.md#buildForV1Write)
* [CreateDeltaTableCommand](commands/CreateDeltaTableCommand.md) is executed
* `DeltaDataSource` is requested for a [streaming source](DeltaDataSource.md#createSource) (to create a [DeltaSource](DeltaSource.md) for Structured Streaming), a [streaming sink](DeltaDataSource.md#createSink) (to create a [DeltaSink](DeltaSink.md) for Structured Streaming), and for an [insertable HadoopFsRelation](DeltaDataSource.md#CreatableRelationProvider-createRelation)

## <span id="verifyOptions"> Verifying Options

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

## <span id="Serializable"> Serializable

`DeltaOptions` is a `Serializable` ([Java]({{ java.api }}/java.base/java/io/Serializable.html)) (so it can be used in Spark tasks).
