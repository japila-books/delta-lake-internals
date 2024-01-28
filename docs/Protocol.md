# Protocol

`Protocol` is an [Action](Action.md).

## Creating Instance

`Protocol` takes the following to be created:

* <span id="minReaderVersion"> Minimum Reader Version Allowed (default: `1`)
* <span id="minWriterVersion"> Minimum Writer Version Allowed (default: `3`)

`Protocol` is created when:

* `DeltaTable` is requested to [upgradeTableProtocol](DeltaTable.md#upgradeTableProtocol)
* _FIXME_

## <span id="forNewTable"> forNewTable

```scala
forNewTable(
  spark: SparkSession,
  metadata: Metadata): Protocol
```

`forNewTable` creates a new [Protocol](#creating-instance) for the given `SparkSession` and [Metadata](Metadata.md).

`forNewTable` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](OptimisticTransactionImpl.md#updateMetadata) and [updateMetadataForNewTable](OptimisticTransactionImpl.md#updateMetadataForNewTable)
* `InitialSnapshot` is requested to `computedState`

### <span id="apply"> apply

```scala
apply(
  spark: SparkSession,
  metadataOpt: Option[Metadata]): Protocol
```

`apply`...FIXME

## <span id="checkProtocolRequirements"> checkProtocolRequirements

```scala
checkProtocolRequirements(
  spark: SparkSession,
  metadata: Metadata,
  current: Protocol): Option[Protocol]
```

`checkProtocolRequirements` asserts that the [table configuration](Metadata.md#configuration) does not contain [delta.minReaderVersion](#MIN_READER_VERSION_PROP) or throws an `AssertionError`:

```text
Should not have the protocol version (delta.minReaderVersion) as part of table properties
```

`checkProtocolRequirements` asserts that the [table configuration](Metadata.md#configuration) does not contain [delta.minWriterVersion](#MIN_WRITER_VERSION_PROP) or throws an `AssertionError`:

```text
Should not have the protocol version (delta.minWriterVersion) as part of table properties
```

`checkProtocolRequirements` [determines the required minimum protocol](#requiredMinimumProtocol).

`checkProtocolRequirements`...FIXME

`checkProtocolRequirements` is used when:

* `OptimisticTransactionImpl` is requested to [verify a new metadata](OptimisticTransactionImpl.md#verifyNewMetadata)

## <span id="requiredMinimumProtocol"> Required Minimum Protocol

```scala
requiredMinimumProtocol(
  spark: SparkSession,
  metadata: Metadata): (Protocol, Seq[String])
```

`requiredMinimumProtocol` creates a [Protocol](#creating-instance) with `0` for the minimum [reader](#minReaderVersion) and [writer](#minWriterVersion) versions.

```scala
Protocol(0, 0)
```

`requiredMinimumProtocol` tracks features used (in `featuresUsed`).

`requiredMinimumProtocol` determines the required minimum [Protocol](Protocol.md) checking for the following features (in order):

1. [Column-Level Invariants](#requiredMinimumProtocol-invariants)
1. [Append Only Table](#requiredMinimumProtocol-appendOnly)
1. [CHECK Constraints](#requiredMinimumProtocol-constraints)
1. [Generated Columns](#requiredMinimumProtocol-generated-columns)
1. [Change Data Feed](#requiredMinimumProtocol-change-data-feed)
1. [IDENTITY Columns (Unsupported)](#requiredMinimumProtocol-identity-columns)
1. [Column Mapping](#requiredMinimumProtocol-column-mapping)

In the end, `requiredMinimumProtocol` returns the required `Protocol` and the features used.

---

`requiredMinimumProtocol` is used when:

* `Protocol` is requested for a [new Protocol](#apply) and [checkProtocolRequirements](#checkProtocolRequirements)

### <span id="requiredMinimumProtocol-invariants"> Column Invariants

`requiredMinimumProtocol` [checks for column-level invariants](column-invariants/Invariants.md#getFromSchema) (in the [schema](Metadata.md#schema) of the given [Metadata](Metadata.md)).

If used, `requiredMinimumProtocol` sets the [minWriterVersion](#minWriterVersion) to `2`.

```scala
Protocol(0, 2)
```

### <span id="requiredMinimumProtocol-appendOnly"> Append-Only Table

`requiredMinimumProtocol` reads [appendOnly](table-properties/DeltaConfigs.md#IS_APPEND_ONLY) table property (from the [table configuration](Metadata.md#configuration) of the given [Metadata](Metadata.md)).

If set, `requiredMinimumProtocol` creates a new [Protocol](#creating-instance) with the [minWriterVersion](#minWriterVersion) to be `3`.

```scala
Protocol(0, 3)
```

### <span id="requiredMinimumProtocol-constraints"> CHECK Constraints

`requiredMinimumProtocol` [checks for CHECK constraints](constraints/Constraints.md#getCheckConstraints) (in the given [Metadata](Metadata.md)).

If used, `requiredMinimumProtocol` creates a new [Protocol](#creating-instance) with the [minWriterVersion](#minWriterVersion) to be `3`.

```scala
Protocol(0, 3)
```

### <span id="requiredMinimumProtocol-generated-columns"> Generated Columns

`requiredMinimumProtocol` [checks for generated columns](generated-columns/GeneratedColumn.md#hasGeneratedColumns) (in the [schema](Metadata.md#schema) of the given [Metadata](Metadata.md)).

If used, `requiredMinimumProtocol` creates a new [Protocol](#creating-instance) with the [minWriterVersion](#minWriterVersion) to be [4](generated-columns/GeneratedColumn.md#MIN_WRITER_VERSION).

```scala
Protocol(0, 4)
```

### <span id="requiredMinimumProtocol-change-data-feed"> Change Data Feed

`requiredMinimumProtocol` checks whether [delta.enableChangeDataFeed](table-properties/DeltaConfigs.md#CHANGE_DATA_FEED) table property is enabled (in the given [Metadata](Metadata.md)).

If enabled, `requiredMinimumProtocol` creates a new [Protocol](#creating-instance) with the [minWriterVersion](#minWriterVersion) to be `4`.

```scala
Protocol(0, 4)
```

### <span id="requiredMinimumProtocol-identity-columns"> IDENTITY Columns (Unsupported)

`requiredMinimumProtocol` [checks for identity columns](ColumnWithDefaultExprUtils.md#hasIdentityColumn) (in the [schema](Metadata.md#schema) of the given [Metadata](Metadata.md)).

If used, `requiredMinimumProtocol` creates a new [Protocol](#creating-instance) with the [minWriterVersion](#minWriterVersion) to be [6](ColumnWithDefaultExprUtils.md#IDENTITY_MIN_WRITER_VERSION).

```scala
Protocol(0, 6)
```

!!! danger "AnalysisException"
    In the end, `requiredMinimumProtocol` throws an `AnalysisException`:

    ```text
    IDENTITY column is not supported
    ```

### <span id="requiredMinimumProtocol-column-mapping"> Column Mapping

`requiredMinimumProtocol` [checks for column mapping](column-mapping/DeltaColumnMappingBase.md#requiresNewProtocol) (in the given [Metadata](Metadata.md)).

If used, `requiredMinimumProtocol` creates a new [Protocol](column-mapping/DeltaColumnMappingBase.md#MIN_PROTOCOL_VERSION).

```scala
Protocol(2, 5)
```

## extractAutomaticallyEnabledFeatures { #extractAutomaticallyEnabledFeatures }

```scala
extractAutomaticallyEnabledFeatures(
  spark: SparkSession,
  metadata: Metadata,
  protocol: Option[Protocol] = None): Set[TableFeature]
```

`extractAutomaticallyEnabledFeatures` requests the given [Protocol](Protocol.md) for the [writerFeatureNames](table-features/TableFeatureSupport.md#writerFeatureNames) (_protocol-enabled table features_).

`extractAutomaticallyEnabledFeatures` finds [FeatureAutomaticallyEnabledByMetadata](table-features/FeatureAutomaticallyEnabledByMetadata.md)s features (among the [allSupportedFeaturesMap](table-features/TableFeature.md#allSupportedFeaturesMap)) that [metadataRequiresFeatureToBeEnabled](table-features/FeatureAutomaticallyEnabledByMetadata.md#metadataRequiresFeatureToBeEnabled) for the given [Metadata](Metadata.md) (_metadata-enabled table features_)

In the end, `extractAutomaticallyEnabledFeatures` [finds the smallest set of table features](#getDependencyClosure) for the protocol- and metadata-enabled table features (incl. [their dependencies](table-features/TableFeature.md#requiredFeatures), if there are any).

---

`extractAutomaticallyEnabledFeatures` is used when:

* `DeltaLog` is requested to [assertTableFeaturesMatchMetadata](DeltaLog.md#assertTableFeaturesMatchMetadata)
* `Protocol` is requested to [minProtocolComponentsFromMetadata](#minProtocolComponentsFromMetadata) and [minProtocolComponentsFromAutomaticallyEnabledFeatures](#minProtocolComponentsFromAutomaticallyEnabledFeatures)
* `CloneConvertedSource` is requested for the [Protocol](commands/clone/CloneConvertedSource.md#protocol)

## minProtocolComponentsFromMetadata { #minProtocolComponentsFromMetadata }

```scala
minProtocolComponentsFromMetadata(
  spark: SparkSession,
  metadata: Metadata): (Int, Int, Set[TableFeature])
```

`minProtocolComponentsFromMetadata`...FIXME

---

`minProtocolComponentsFromMetadata` is used when:

* `Protocol` is requested to [forNewTable](#forNewTable)
* `CloneTableBase` is requested to [determineTargetProtocol](commands/clone/CloneTableBase.md#determineTargetProtocol)

## upgradeProtocolFromMetadataForExistingTable { #upgradeProtocolFromMetadataForExistingTable }

```scala
upgradeProtocolFromMetadataForExistingTable(
  spark: SparkSession,
  metadata: Metadata): (Int, Int, Set[TableFeature])
```

`upgradeProtocolFromMetadataForExistingTable`...FIXME

---

`upgradeProtocolFromMetadataForExistingTable` is used when:

* `OptimisticTransactionImpl` is requested to [setNewProtocolWithFeaturesEnabledByMetadata](OptimisticTransactionImpl.md#setNewProtocolWithFeaturesEnabledByMetadata)

### minProtocolComponentsFromAutomaticallyEnabledFeatures { #minProtocolComponentsFromAutomaticallyEnabledFeatures }

```scala
minProtocolComponentsFromAutomaticallyEnabledFeatures(
  spark: SparkSession,
  metadata: Metadata): (Int, Int, Set[TableFeature])
```

`minProtocolComponentsFromAutomaticallyEnabledFeatures` determines the minimum reader and writer versions based on [automatically enabled table features](#extractAutomaticallyEnabledFeatures).

## Demo

```scala
import org.apache.spark.sql.delta.actions.{Metadata, Protocol}
import org.apache.spark.sql.delta.DeltaConfigs

val configuration = Map(
  DeltaConfigs.IS_APPEND_ONLY.key -> "true") // (1)!
val metadata = Metadata(configuration = configuration)
val protocol = Protocol.forNewTable(spark, metadata)
```

1. Append-only table

```scala
assert(
  protocol.minReaderVersion == 1,
  "minReaderVersion should be the default 1")
assert(
  protocol.minWriterVersion == 2,
  "minWriterVersion should be 2 because of append-only tables")
```
