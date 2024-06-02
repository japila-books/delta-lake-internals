# UniversalFormat

## enforceDependenciesInConfiguration { #enforceDependenciesInConfiguration }

```scala
enforceDependenciesInConfiguration(
  configuration: Map[String, String],
  snapshot: Snapshot): Map[String, String]
```

`enforceDependenciesInConfiguration`...FIXME

---

`enforceDependenciesInConfiguration` is used when:

* `CreateDeltaTableCommand` is requested to [handleCreateTable](commands/create-table/CreateDeltaTableCommand.md#handleCreateTable) and [handleCreateTableAsSelect](commands/create-table/CreateDeltaTableCommand.md#handleCreateTableAsSelect)

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

* `OptimisticTransactionImpl` is requested to [prepare a commit](OptimisticTransactionImpl.md#prepareCommit)
* `UniversalFormat` is requested to [enforceDependenciesInConfiguration](#enforceDependenciesInConfiguration)

### enforceHudiDependencies { #enforceHudiDependencies }

```scala
enforceHudiDependencies(
  newestMetadata: Metadata,
  snapshot: Snapshot): Any
```

`enforceHudiDependencies`...FIXME
