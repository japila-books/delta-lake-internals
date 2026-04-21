# TableCommitCoordinatorClient

`TableCommitCoordinatorClient` is a wrapper around [CommitCoordinatorClient](#commitCoordinatorClient) that provides a more user-friendly API for committing and accessing commits to a [delta table](#logPath).

## Creating Instance

`TableCommitCoordinatorClient` takes the following to be created:

* <span id="commitCoordinatorClient"> [CommitCoordinatorClient](CommitCoordinatorClient.md)
* <span id="logPath"> Log Path (of a delta table)
* <span id="tableConf"> Table Configuration
* <span id="hadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))
* <span id="logStore"> [LogStore](../LogStore.md)

`TableCommitCoordinatorClient` is created when:

* `CatalogOwnedTableUtils` is requested to [populateTableCommitCoordinatorFromCatalog](../catalog-managed-tables/CatalogOwnedTableUtils.md#populateTableCommitCoordinatorFromCatalog)
* `CoordinatedCommitsUtils` is requested to [getTableCommitCoordinator](CoordinatedCommitsUtils.md#getTableCommitCoordinator)
* `TableCommitCoordinatorClient` factory is used to [apply](#apply)

## Create TableCommitCoordinatorClient { #apply }

```scala
apply(
  commitCoordinatorClient: CommitCoordinatorClient,
  deltaLog: DeltaLog,
  coordinatedCommitsTableConf: Map[String, String]): TableCommitCoordinatorClient
```

`apply` requests the given [DeltaLog](../DeltaLog.md) for a [newDeltaHadoopConf](../DeltaLog.md#newDeltaHadoopConf).

In the end, `apply` creates a [TableCommitCoordinatorClient](TableCommitCoordinatorClient.md).

---

`apply` is used when:

* `OptimisticTransactionImpl` is requested to [commitLarge](../OptimisticTransactionImpl.md#commitLarge) and [writeCommitFile](../OptimisticTransactionImpl.md#writeCommitFile)
