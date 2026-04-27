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

`AbstractDeltaCatalog` is a `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/)) that creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (for [delta data source](spark-connector/DeltaSourceUtils.md#isDeltaDataSourceName)) or a `BestEffortStagedTable`.

### stageCreate { #stageCreate }

??? note "StagingTableCatalog"

    ```scala
    stageCreate(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: util.Map[String, String]): StagedTable
    ```

    `stageCreate` is part of the `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/#stageCreate)) abstraction.

`stageCreate` creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (with `TableCreationModes.Create` operation) for [delta data source](spark-connector/DeltaSourceUtils.md#isDeltaDataSourceName) only (based on the given `properties` or [spark.sql.sources.default](#getProvider) configuration property).

Otherwise, `stageCreate` creates a `BestEffortStagedTable` (requesting the parent `TableCatalog` to create a table).

### stageCreateOrReplace { #stageCreateOrReplace }

??? note "StagingTableCatalog"

    ```scala
    stageCreateOrReplace(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: util.Map[String, String]): StagedTable
    ```

    `stageCreateOrReplace` is part of the `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/#stageCreateOrReplace)) abstraction.

`stageCreateOrReplace` creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (with `TableCreationModes.CreateOrReplace` operation) for [delta data source](spark-connector/DeltaSourceUtils.md#isDeltaDataSourceName) only (based on the given `properties` or [spark.sql.sources.default](#getProvider) configuration property).

Otherwise, `stageCreateOrReplace` requests the parent `TableCatalog` to drop the table first and then creates a `BestEffortStagedTable` (requesting the parent `TableCatalog` to create the table).

### stageReplace { #stageReplace }

??? note "StagingTableCatalog"

    ```scala
    stageReplace(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: util.Map[String, String]): StagedTable
    ```

    `stageReplace` is part of the `StagingTableCatalog` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/StagingTableCatalog/#stageReplace)) abstraction.

`stageReplace` creates a [StagedDeltaTableV2](StagedDeltaTableV2.md) (with `TableCreationModes.Replace` operation) for [delta data source](spark-connector/DeltaSourceUtils.md#isDeltaDataSourceName) only (based on the given `properties` or [spark.sql.sources.default](#getProvider) configuration property).

Otherwise, `stageReplace` requests the parent `TableCatalog` to drop the table first and then creates a `BestEffortStagedTable` (requesting the parent `TableCatalog` to create the table).

## Unity Catalog Execution Mode { #isUnityCatalog }

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

## getTablePropsAndWriteOptions { #getTablePropsAndWriteOptions }

```scala
getTablePropsAndWriteOptions(
  properties: JMap[String, String]): (JMap[String, String], Map[String, String])
```

`getTablePropsAndWriteOptions`...FIXME

---

`getTablePropsAndWriteOptions` is used when:

* `AbstractDeltaCatalog` is requested to [createTable](#createTable)
* `StagedDeltaTableV2` is requested to [commitStagedChanges](StagedDeltaTableV2.md#commitStagedChanges)
