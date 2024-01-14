# DeltaTableV2

`DeltaTableV2` is a logical representation of a [writable](#SupportsWrite) delta [table](#Table).

## Creating Instance

`DeltaTableV2` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="path"> Path ([Hadoop HDFS]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* [CatalogTable Metadata](#catalogTable)
* <span id="tableIdentifier"> Optional Table ID
* Optional [DeltaTimeTravelSpec](#timeTravelOpt)
* [Options](#options)
* [CDC Options](#cdcOptions)

`DeltaTableV2` is created when:

* `DeltaTable` utility is used to [forPath](DeltaTable.md#forPath) and [forName](DeltaTable.md#forName)
* `DeltaCatalog` is requested to [load a table](DeltaCatalog.md#loadTable)
* `DeltaDataSource` is requested to [load a table](spark-connector/DeltaDataSource.md#getTable) or [create a table relation](spark-connector/DeltaDataSource.md#RelationProvider-createRelation)

### Table Metadata (CatalogTable) { #catalogTable }

```scala
catalogTable: Option[CatalogTable] = None
```

`DeltaTableV2` can be given `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/CatalogTable)) when [created](#creating-instance). It is undefined by default.

`catalogTable` is specified when:

* [DeltaTable.forName](DeltaTable.md#forName) is used (for a [cataloged delta table](DeltaTableUtils.md#isDeltaTable))
* `DeltaCatalog` is requested to [load a table](DeltaCatalog.md#loadTable) (that is a `V1Table` and a [cataloged delta table](DeltaTableUtils.md#isDeltaTable))

`catalogTable` is used when:

* `DeltaTableV2` is requested for the [rootPath](#rootPath) (to avoid [parsing the path](spark-connector/DeltaDataSource.md#parsePathIdentifier)), the [name](#name), the [properties](#properties) and the [CatalogTable](#v1Table) itself
* [DeltaAnalysis](DeltaAnalysis.md) logical resolution rule is requested to resolve a [RestoreTableStatement](commands/restore/RestoreTableStatement.md) (for a `TableIdentifier`)
* `DeltaRelation` utility is used to [fromV2Relation](DeltaRelation.md#fromV2Relation)
* [AlterTableSetLocationDeltaCommand](commands/alter/AlterTableSetLocationDeltaCommand.md) is executed

### CDC Options { #cdcOptions }

```scala
cdcOptions: CaseInsensitiveStringMap
```

`DeltaTableV2` can be given `cdcOptions` when [created](#creating-instance). It is empty by default (and most of the time).

`cdcOptions` is specified when:

* `DeltaDataSource` is requested to [create a relation](spark-connector/DeltaDataSource.md#RelationProvider-createRelation) (for [CDC read](change-data-feed/CDCReaderImpl.md#isCDCRead))
* `DeltaTableV2` is requested to [withOptions](#withOptions)

`cdcOptions` is used when:

* `DeltaTableV2` is requested for a [BaseRelation](#toBaseRelation)

## CDF-Aware Relation { #cdcRelation }

```scala
cdcRelation: Option[BaseRelation]
```

??? note "Lazy Value"
    `cdcRelation` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

With [CDF-aware read](change-data-feed/CDCReader.md#isCDCRead), `cdcRelation` returns a [CDF-aware relation](change-data-feed/CDCReader.md#getCDCRelation) for the following:

* [initialSnapshot](#initialSnapshot)
* [timeTravelSpec](#timeTravelSpec)

Otherwise, `cdcRelation` returns `None` (an _undefined_ value).

---

`cdcRelation` is used when:

* `DeltaTableV2` is requested for the [table schema](#tableSchema) and the [relation](#toBaseRelation)

## Options { #options }

`DeltaTableV2` can be given options (as a `Map[String, String]`). Options are empty by default.

The options are defined when `DeltaDataSource` is requested for a [relation](spark-connector/DeltaDataSource.md#RelationProvider-createRelation) with [spark.databricks.delta.loadFileSystemConfigsFromDataFrameOptions](configuration-properties/DeltaSQLConf.md#loadFileSystemConfigsFromDataFrameOptions) configuration property enabled.

The options are used for the following:

* Looking up `path` or `paths` options
* [Creating the DeltaLog](#deltaLog)

## DeltaLog { #deltaLog }

`DeltaTableV2` [creates a DeltaLog](DeltaLog.md#forTable) for the [rootPath](#rootPath) and the given [options](#options).

## Table { #Table }

`DeltaTableV2` is a `Table` ([Spark SQL]({{ book.spark_sql }}/connector/Table)).

## SupportsWrite { #SupportsWrite }

`DeltaTableV2` is a `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite)).

## V2TableWithV1Fallback { #V2TableWithV1Fallback }

`DeltaTableV2` is a `V2TableWithV1Fallback` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/V2TableWithV1Fallback)).

### v1Table { #v1Table }

??? note "V2TableWithV1Fallback"

    ```scala
    v1Table: CatalogTable
    ```

    `v1Table` is part of the `V2TableWithV1Fallback` ([Spark SQL]({{ book.spark_sql }}/connector/catalog/V2TableWithV1Fallback#v1Table)) abstraction.

`v1Table` returns the [CatalogTable](#catalogTable) (with `CatalogStatistics` removed if [DeltaTimeTravelSpec](#timeTravelSpec) has also been specified).

---

`v1Table` expects that the (optional) [CatalogTable](#catalogTable) metadata is specified or throws a `DeltaIllegalStateException`:

```text
v1Table call is not expected with path based DeltaTableV2
```

## DeltaTimeTravelSpec { #timeTravelOpt }

`DeltaTableV2` may be given a [DeltaTimeTravelSpec](time-travel/DeltaTimeTravelSpec.md) when [created](#creating-instance).

`DeltaTimeTravelSpec` is assumed not to be defined by default (`None`).

`DeltaTableV2` is given a `DeltaTimeTravelSpec` when:

* `DeltaDataSource` is requested for a [BaseRelation](spark-connector/DeltaDataSource.md#RelationProvider-createRelation)

`DeltaTimeTravelSpec` is used for [timeTravelSpec](#timeTravelSpec).

## Properties { #properties }

??? note "Table"

    ```scala
    properties(): Map[String, String]
    ```

    `properties` is part of the `Table` ([Spark SQL]({{ book.spark_sql }}/connector/Table#properties)) abstraction.

`properties` requests the [Snapshot](#snapshot) for the [table properties](Snapshot.md#getProperties) and adds the following:

Name        | Value
------------|----------
 `provider` | `delta`
 `location` | [path](#path)
 `comment`  | [description](Metadata.md#description) (of the [Metadata](Snapshot.md#metadata)) if available
 `Type`     | table type of the [CatalogTable](#catalogTable) if available

## Table Capabilities { #capabilities }

??? note "Table"

    ```scala
    capabilities(): Set[TableCapability]
    ```

    `capabilities` is part of the `Table` ([Spark SQL]({{ book.spark_sql }}/connector/Table#capabilities)) abstraction.

`capabilities` is the following:

* `ACCEPT_ANY_SCHEMA` ([Spark SQL]({{ book.spark_sql }}/connector/TableCapability#ACCEPT_ANY_SCHEMA))
* `BATCH_READ` ([Spark SQL]({{ book.spark_sql }}/connector/TableCapability#BATCH_READ))
* `V1_BATCH_WRITE` ([Spark SQL]({{ book.spark_sql }}/connector/TableCapability#V1_BATCH_WRITE))
* `OVERWRITE_BY_FILTER` ([Spark SQL]({{ book.spark_sql }}/connector/TableCapability#OVERWRITE_BY_FILTER))
* `TRUNCATE` ([Spark SQL]({{ book.spark_sql }}/connector/TableCapability#TRUNCATE))

## Creating WriteBuilder { #newWriteBuilder }

??? note "SupportsWrite"

    ```scala
    newWriteBuilder(
    info: LogicalWriteInfo): WriteBuilder
    ```

    `newWriteBuilder` is part of the `SupportsWrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsWrite#newWriteBuilder)) abstraction.

`newWriteBuilder` creates a [WriteIntoDeltaBuilder](WriteIntoDeltaBuilder.md) (for the [DeltaLog](#deltaLog) and the options from the `LogicalWriteInfo`).

## Snapshot { #snapshot }

```scala
snapshot: Snapshot
```

`DeltaTableV2` has a [Snapshot](Snapshot.md). In other words, `DeltaTableV2` represents a Delta table at a specific version.

??? note "Lazy Value"
    `snapshot` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`DeltaTableV2` uses the [DeltaLog](#deltaLog) to [load it at a given version](#getSnapshotAt) (based on the optional [timeTravelSpec](#timeTravelSpec)) or [update to the latest version](#update).

---

`snapshot` is used when:

* `DeltaTableV2` is requested for the [schema](#schema), [partitioning](#partitioning) and [properties](#properties)

## DeltaTimeTravelSpec { #timeTravelSpec }

```scala
timeTravelSpec: Option[DeltaTimeTravelSpec]
```

`DeltaTableV2` may have a [DeltaTimeTravelSpec](time-travel/DeltaTimeTravelSpec.md) specified that is either [given](#timeTravelOpt) or [extracted from the path](DeltaTableUtils.md#extractIfPathContainsTimeTravel) (for [timeTravelByPath](#timeTravelByPath)).

`timeTravelSpec` throws an `AnalysisException` when [timeTravelOpt](#timeTravelOpt) and [timeTravelByPath](#timeTravelByPath) are both defined:

```text
Cannot specify time travel in multiple formats.
```

---

`timeTravelSpec` is used when:

* `DeltaTableV2` is requested for a [Snapshot](#snapshot) and [BaseRelation](#toBaseRelation)

## DeltaTimeTravelSpec by Path { #timeTravelByPath }

```scala
timeTravelByPath: Option[DeltaTimeTravelSpec]
```

!!! note "Scala lazy value"
    `timeTravelByPath` is a Scala lazy value and is initialized once when first accessed. Once computed it stays unchanged.

`timeTravelByPath` is undefined when [CatalogTable](#catalogTable) is defined.

With no [CatalogTable](#catalogTable) defined, `DeltaTableV2` [parses](spark-connector/DeltaDataSource.md#parsePathIdentifier) the given [Path](#path) for the `timeTravelByPath` (that [resolvePath](time-travel/DeltaTimeTravelSpec.md#resolvePath) under the covers).

## Converting to Insertable HadoopFsRelation { #toBaseRelation }

```scala
toBaseRelation: BaseRelation
```

`toBaseRelation` [verifyAndCreatePartitionFilters](spark-connector/DeltaDataSource.md#verifyAndCreatePartitionFilters) for the [Path](#path), the [current Snapshot](SnapshotManagement.md#snapshot) and [partitionFilters](#partitionFilters).

In the end, `toBaseRelation` requests the [DeltaLog](#deltaLog) for an [insertable HadoopFsRelation](DeltaLog.md#createRelation).

---

`toBaseRelation` is used when:

* `DeltaDataSource` is requested to [create a relation](spark-connector/DeltaDataSource.md#RelationProvider-createRelation) (for a table scan)
* `DeltaRelation` is requested to [fromV2Relation](DeltaRelation.md#fromV2Relation)
