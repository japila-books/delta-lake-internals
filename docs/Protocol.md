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

`checkProtocolRequirements`...FIXME

`checkProtocolRequirements` is used when:

* `OptimisticTransactionImpl` is requested to [verifyNewMetadata](OptimisticTransactionImpl.md#verifyNewMetadata)

## <span id="requiredMinimumProtocol"> Required Minimum Protocol

```scala
requiredMinimumProtocol(
  spark: SparkSession,
  metadata: Metadata): (Protocol, Seq[String])
```

`requiredMinimumProtocol`...FIXME

`requiredMinimumProtocol` is used when:

* `Protocol` utility is used to [create a Protocol](#apply) and [checkProtocolRequirements](#checkProtocolRequirements)
