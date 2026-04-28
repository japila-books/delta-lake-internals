# DeltaV2Mode

## Creating Instance

`DeltaV2Mode` takes the following to be created:

* <span id="sqlConf"> `SQLConf` ([Spark SQL]({{ book.spark_sql }}/SQLConf/))

`DeltaV2Mode` is created when:

* `DeltaDataSource` is requested to [sourceSchema](./spark-connector/DeltaDataSource.md#sourceSchema)
* `ApplyV2Streaming` is requested to [shouldApplyV2Streaming](./ApplyV2Streaming.md#shouldApplyV2Streaming)
* `DeltaCatalog` is requested to [loadTableInternal](DeltaCatalog.md#loadTableInternal)

## Mode { #mode }

```java
String mode()
```

`mode` is the value of [spark.databricks.delta.v2.enableMode](./configuration-properties/index.md#V2_ENABLE_MODE) configuration property.

---

`mode` is used when:

* `DeltaV2Mode` is requested to [isStreamingReadsEnabled](#isStreamingReadsEnabled), [shouldCatalogReturnV2Tables](#shouldCatalogReturnV2Tables), [shouldBypassSchemaValidationForStreaming](#shouldBypassSchemaValidationForStreaming)

## shouldCatalogReturnV2Tables { #shouldCatalogReturnV2Tables }

```java
boolean shouldCatalogReturnV2Tables()
```

`shouldCatalogReturnV2Tables` is enabled (`true`) when [spark.databricks.delta.v2.enableMode](./configuration-properties/DeltaSQLConf.md#V2_ENABLE_MODE) configuration property is `STRICT`.

Otherwise, `shouldCatalogReturnV2Tables` is disabled (`false`).

---

`shouldCatalogReturnV2Tables` is used when:

* `DeltaCatalog` is requested to [load a delta table](DeltaCatalog.md#loadTableInternal)
