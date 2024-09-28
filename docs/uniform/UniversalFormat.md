# UniversalFormat

## hudiEnabled

```scala
hudiEnabled(
  metadata: Metadata): Boolean
```

`hudiEnabled` is enabled (`true`) when `hudi` is listed in [delta.universalFormat.enabledFormats](../table-properties/DeltaConfigs.md#universalFormat.enabledFormats) table property (in the given [Metadata](../Metadata.md)).

---

`hudiEnabled` is used when:

* `HudiConverter` is requested to [convertSnapshot](HudiConverter.md#convertSnapshot), [enqueueSnapshotForConversion](HudiConverter.md#enqueueSnapshotForConversion)
* `UniversalFormat` is requested to [enforceHudiDependencies](#enforceHudiDependencies)
* `CreateDeltaTableCommand` is requested to [runPostCommitUpdates](../commands/create-table/CreateDeltaTableCommand.md#runPostCommitUpdates)
* `HudiConverterHook` post-commit hook is [executed](HudiConverterHook.md#run)

## icebergEnabled { #icebergEnabled }

```scala
icebergEnabled(
  metadata: Metadata): Boolean
icebergEnabled(
  properties: Map[String, String]): Boolean
```

`icebergEnabled` is enabled (`true`) when `iceberg` is listed in [delta.universalFormat.enabledFormats](../table-properties/DeltaConfigs.md#universalFormat.enabledFormats) table property (in the given [Metadata](../Metadata.md) or the properties).

---

`icebergEnabled` is used when:

* `CreateDeltaTableCommand` is requested to [runPostCommitUpdates](../commands/create-table/CreateDeltaTableCommand.md#runPostCommitUpdates)
* `IcebergConverter` is requested to [enqueueSnapshotForConversion](IcebergConverter.md#enqueueSnapshotForConversion)
* `IcebergConverterHook` post-commit hook is [executed](IcebergConverterHook.md#run)
* `UniversalFormat` is requested to [enforceIcebergInvariantsAndDependencies](#enforceIcebergInvariantsAndDependencies), [enforceSupportInCatalog](#enforceSupportInCatalog)
* `ReorgTableForUpgradeUniformHelper` is requested to [doRewrite](../commands/reorg/ReorgTableForUpgradeUniformHelper.md#doRewrite)

## enforceIcebergInvariantsAndDependencies { #enforceIcebergInvariantsAndDependencies }

```scala
enforceIcebergInvariantsAndDependencies(
  snapshot: Snapshot,
  newestProtocol: Protocol,
  newestMetadata: Metadata,
  isCreatingOrReorg: Boolean,
  actions: Seq[Action]): (Option[Protocol], Option[Metadata])
```

`enforceIcebergInvariantsAndDependencies`...FIXME

---

`enforceIcebergInvariantsAndDependencies` is used when:

* `UniversalFormat` is requested to [enforceInvariantsAndDependencies](#enforceInvariantsAndDependencies)

## enforceDependenciesInConfiguration { #enforceDependenciesInConfiguration }

```scala
enforceDependenciesInConfiguration(
  configuration: Map[String, String],
  snapshot: Snapshot): Map[String, String]
```

`enforceDependenciesInConfiguration`...FIXME

---

`enforceDependenciesInConfiguration` is used when:

* `CreateDeltaTableCommand` is requested to [handleCreateTable](../commands/create-table/CreateDeltaTableCommand.md#handleCreateTable) and [handleCreateTableAsSelect](../commands/create-table/CreateDeltaTableCommand.md#handleCreateTableAsSelect)

## enforceInvariantsAndDependencies { #enforceInvariantsAndDependencies }

```scala
enforceInvariantsAndDependencies(
  snapshot: Snapshot,
  newestProtocol: Protocol,
  newestMetadata: Metadata,
  isCreatingOrReorgTable: Boolean,
  actions: Seq[Action]): (Option[Protocol], Option[Metadata])
```

`enforceInvariantsAndDependencies`...FIXME

---

`enforceInvariantsAndDependencies` is used when:

* `OptimisticTransactionImpl` is requested to [prepare a commit](../OptimisticTransactionImpl.md#prepareCommit)
* `UniversalFormat` is requested to [enforceDependenciesInConfiguration](#enforceDependenciesInConfiguration)

### enforceHudiDependencies { #enforceHudiDependencies }

```scala
enforceHudiDependencies(
  newestMetadata: Metadata,
  snapshot: Snapshot): Any
```

`enforceHudiDependencies`...FIXME
