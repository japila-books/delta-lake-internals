# AbstractDeltaCatalog

`AbstractDeltaCatalog` is a [DelegatingCatalogExtension](#DelegatingCatalogExtension).

`AbstractDeltaCatalog` is a [StagingTableCatalog](#StagingTableCatalog).

`AbstractDeltaCatalog` is a [SupportsPathIdentifier](SupportsPathIdentifier.md).

## DelegatingCatalogExtension { #DelegatingCatalogExtension }

`AbstractDeltaCatalog` is a `DelegatingCatalogExtension` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/DelegatingCatalogExtension/)).

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
