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

`requiredMinimumProtocol` [checks for invariants](constraints/Invariants.md#getFromSchema) in the [schema](Metadata.md#schema). If used, `requiredMinimumProtocol` sets the [minWriterVersion](#minWriterVersion) to `2`.

```scala
Protocol(0, 2)
```

`requiredMinimumProtocol`...FIXME

`requiredMinimumProtocol` is used when:

* `Protocol` utility is used to [create a Protocol](#apply) and [checkProtocolRequirements](#checkProtocolRequirements)

## <span id="demo"> Demo

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
