# AbstractDeltaCatalog

`AbstractDeltaCatalog` is a [DelegatingCatalogExtension](#DelegatingCatalogExtension).

`AbstractDeltaCatalog` is a [StagingTableCatalog](#StagingTableCatalog).

`AbstractDeltaCatalog` is a [SupportsPathIdentifier](SupportsPathIdentifier.md).

## Implementations

* [DeltaCatalog](DeltaCatalog.md)
* `DeltaCatalogV1` (V1 legacy implementation)

## DelegatingCatalogExtension { #DelegatingCatalogExtension }

`AbstractDeltaCatalog` is a `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/)).

### createTable { #createTable }

??? note "DelegatingCatalogExtension"

    ```scala
    createTable(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: util.Map[String, String]): Table
    ```

    `createTable` is part of the `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/#createTable)) abstraction.

`createTable`...FIXME

### loadTable { #loadTable }

??? note "DelegatingCatalogExtension"

    ```scala
    loadTable(
      ident: Identifier): Table
    ```

    `loadTable` is part of the `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/#loadTable)) abstraction.

`loadTable` [setVariantBlockingConfigIfUC](#setVariantBlockingConfigIfUC).

`loadTable`...FIXME

## StagingTableCatalog { #StagingTableCatalog }

`AbstractDeltaCatalog` is a `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/)).

## isUnityCatalog { #isUnityCatalog }

```scala
isUnityCatalog: Boolean
```

`isUnityCatalog` is enabled (`true`) when the `delegate` field of this implementation of [DelegatingCatalogExtension](#DelegatingCatalogExtension) is a class in `io.unitycatalog.` package.

In other words, `isUnityCatalog` is `true` if the underlying catalog is a Unity Catalog implementation (e.g., [io.unitycatalog.spark.UCSingleCatalog]({{ book.unity_catalog }}/spark-connector/UCSingleCatalog/)).

??? note "Lazy Value"
    `isUnityCatalog` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## setVariantBlockingConfigIfUC { #setVariantBlockingConfigIfUC }

```scala
setVariantBlockingConfigIfUC(): Unit
```

Only when executed in [isUnityCatalog](#isUnityCatalog) mode, `setVariantBlockingConfigIfUC` sets the internal [spark.databricks.delta.variant.disableVariantTableFeatureForSpark40](./configuration-properties/index.md#variant.disableVariantTableFeatureForSpark40) configuration property to `true`.

---

`setVariantBlockingConfigIfUC` is used when:

* `AbstractDeltaCatalog` is requested to [createTable](#createTable) and [loadTable](#loadTable)
