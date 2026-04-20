# CoordinatedCommitsUtils

## getCommitsFromCommitCoordinatorWithUsageLogs { #getCommitsFromCommitCoordinatorWithUsageLogs }

```scala
getCommitsFromCommitCoordinatorWithUsageLogs(
  deltaLog: DeltaLog,
  tableCommitCoordinatorClient: TableCommitCoordinatorClient,
  catalogTableOpt: Option[CatalogTable],
  startVersion: Long,
  versionToLoad: Option[Long],
  isAsyncRequest: Boolean): GetCommitsResponse
```

`getCommitsFromCommitCoordinatorWithUsageLogs`...FIXME

---

`getCommitsFromCommitCoordinatorWithUsageLogs` is used when:

* `SnapshotManagement` is requested to [listDeltaCompactedDeltaCheckpointFilesAndLatestChecksumFile](../SnapshotManagement.md#listDeltaCompactedDeltaCheckpointFilesAndLatestChecksumFile)

## commitFilesIterator { #commitFilesIterator }

```scala
commitFilesIterator(
  deltaLog: DeltaLog,
  catalogTableOpt: Option[CatalogTable],
  startVersion: Long): Iterator[(FileStatus, Long)]
```

`commitFilesIterator`...FIXME

---

`commitFilesIterator` is used when:

* `DeltaLog` is requested to [getChangeLogFiles](../DeltaLog.md#getChangeLogFiles)

## getCommitCoordinatorClient { #getCommitCoordinatorClient }

```scala
getCommitCoordinatorClient(
  spark: SparkSession,
  deltaLog: DeltaLog, // Used for logging
  metadata: Metadata,
  protocol: Protocol,
  failIfImplUnavailable: Boolean): Option[CommitCoordinatorClient]
```

`getCommitCoordinatorClient`...FIXME

---

`getCommitCoordinatorClient` is used when:

* `OptimisticTransactionImpl` is requested to [registerTableForCoordinatedCommitsIfNeeded](../OptimisticTransactionImpl.md#registerTableForCoordinatedCommitsIfNeeded)
* `CoordinatedCommitsUtils` is requested to [getTableCommitCoordinator](#getTableCommitCoordinator)

## getTableCommitCoordinator { #getTableCommitCoordinator }

```scala
getTableCommitCoordinator(
      spark: SparkSession,
      deltaLog: DeltaLog, // Used for logging
      snapshotDescriptor: SnapshotDescriptor,
      failIfImplUnavailable: Boolean): Option[TableCommitCoordinatorClient]
```

`getTableCommitCoordinator`...FIXME

---

`getTableCommitCoordinator` is used when:

* `Snapshot` is requested for a [TableCommitCoordinatorClient](../Snapshot.md#tableCommitCoordinatorClientOpt)

## getCoordinatedCommitsConfs { #getCoordinatedCommitsConfs }

```scala
getCoordinatedCommitsConfs(
  metadata: Metadata): (Option[String], Map[String, String])
```

`getCoordinatedCommitsConfs`...FIXME

---

`getCoordinatedCommitsConfs` is used when:

* `OptimisticTransactionImpl` is requested to [registerTableForCoordinatedCommitsIfNeeded](../OptimisticTransactionImpl.md#registerTableForCoordinatedCommitsIfNeeded)

## unbackfilledCommitsPresent { #unbackfilledCommitsPresent }

```scala
unbackfilledCommitsPresent(
  snapshot: Snapshot): Boolean
```

`unbackfilledCommitsPresent` is enabled (`true`) when there are [unbackfilled delta files](../FileNames.md#UnbackfilledDeltaFile) (files in `_staged_commits` directory).

---

`unbackfilledCommitsPresent` is used when:

* `CoordinatedCommitsPreDowngradeCommand` is requested to [removeFeatureTracesIfNeeded](CoordinatedCommitsPreDowngradeCommand.md#removeFeatureTracesIfNeeded)
* `CatalogOwnedTableFeature` is requested to [validateDropInvariants](../catalog-managed-tables/CatalogOwnedTableFeature.md#validateDropInvariants)
* `CoordinatedCommitsTableFeature` is requested to [validateDropInvariants](CoordinatedCommitsTableFeature.md#validateDropInvariants)

## validateConfigurationsForCreateDeltaTableCommand { #validateConfigurationsForCreateDeltaTableCommand }

```scala
validateConfigurationsForCreateDeltaTableCommand(
  spark: SparkSession,
  tableExists: Boolean,
  query: Option[LogicalPlan],
  catalogTableProperties: Map[String, String]): Unit
```

`validateConfigurationsForCreateDeltaTableCommand` [validateConfigurationsForCreateDeltaTableCommandImpl](#validateConfigurationsForCreateDeltaTableCommandImpl).

---

`validateConfigurationsForCreateDeltaTableCommand` is used when:

* `CreateDeltaTableCommand` is requested to [run](../commands/create-table/CreateDeltaTableCommand.md#run)

### validateConfigurationsForCreateDeltaTableCommandImpl { #validateConfigurationsForCreateDeltaTableCommandImpl }

```scala
validateConfigurationsForCreateDeltaTableCommandImpl(
  spark: SparkSession,
  propertyOverrides: Map[String, String],
  tableExists: Boolean,
  command: String): Unit
```

`validateConfigurationsForCreateDeltaTableCommandImpl`...FIXME

## verifyContainsOnlyCoordinatorNameAndConf { #verifyContainsOnlyCoordinatorNameAndConf }

```scala
verifyContainsOnlyCoordinatorNameAndConf(
  properties: Map[String, String],
  command: String,
  fromDefault: Boolean): Unit
```

`verifyContainsOnlyCoordinatorNameAndConf`...FIXME

---

`verifyContainsOnlyCoordinatorNameAndConf` is used when:

* `CoordinatedCommitsUtils` is requested to [validateConfigurationsForAlterTableSetPropertiesDeltaCommand](#validateConfigurationsForAlterTableSetPropertiesDeltaCommand) and [validateConfigurationsForCreateDeltaTableCommandImpl](#validateConfigurationsForCreateDeltaTableCommandImpl)

## getExplicitCCConfigurations { #getExplicitCCConfigurations }

```scala
getExplicitCCConfigurations(
  properties: Map[String, String]): Map[String, String]
```

`getExplicitCCConfigurations` extracts the [Coordinated Commits-related entries](#TABLE_PROPERTY_KEYS) from the given `properties` map.

---

`getExplicitCCConfigurations` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataForNewTableInReplace](../OptimisticTransactionImpl.md#updateMetadataForNewTableInReplace)
* `CloneTableBase` is requested to [determineCoordinatedCommitsConfigurations](../commands/clone/CloneTableBase.md#determineCoordinatedCommitsConfigurations) and [determineTargetMetadata](../commands/clone/CloneTableBase.md#determineTargetMetadata)
* `CreateDeltaTableCommand` is requested to [filterCoordinatedCommitsProperties](../commands/create-table/CreateDeltaTableCommand.md#filterCoordinatedCommitsProperties)
* `CoordinatedCommitsUtils` is requested to [validateConfigurationsForAlterTableSetPropertiesDeltaCommand](#validateConfigurationsForAlterTableSetPropertiesDeltaCommand), [validateConfigurationsForAlterTableUnsetPropertiesDeltaCommand](#validateConfigurationsForAlterTableUnsetPropertiesDeltaCommand) and [validateConfigurationsForCreateDeltaTableCommandImpl](#validateConfigurationsForCreateDeltaTableCommandImpl)

## TABLE_PROPERTY_CONFS { #TABLE_PROPERTY_CONFS }

`TABLE_PROPERTY_CONFS` is a collection of the following [DeltaConfig](../table-properties/DeltaConfig.md)s:

* [delta.coordinatedCommits.commitCoordinator-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_NAME)
* [delta.coordinatedCommits.commitCoordinatorConf-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_CONF)
* [delta.coordinatedCommits.tableConf-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_TABLE_CONF)

---

`TABLE_PROPERTY_CONFS` is used when:

* `CoordinatedCommitsUtils` is requested to [getDefaultCCConfigurations](#getDefaultCCConfigurations) and [TABLE_PROPERTY_KEYS](#TABLE_PROPERTY_KEYS)

## TABLE_PROPERTY_KEYS { #TABLE_PROPERTY_KEYS }

```scala
TABLE_PROPERTY_KEYS: Seq[String]
```

`TABLE_PROPERTY_KEYS` is a collection of the keys of the [delta table properties](#TABLE_PROPERTY_CONFS):

* [delta.coordinatedCommits.commitCoordinator-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_NAME)
* [delta.coordinatedCommits.commitCoordinatorConf-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_COORDINATOR_CONF)
* [delta.coordinatedCommits.tableConf-preview](../table-properties/DeltaConfigs.md#COORDINATED_COMMITS_TABLE_CONF)

---

`TABLE_PROPERTY_KEYS` is used when:

* `DeltaAnalysis` is requested to [apply](../DeltaAnalysis.md#apply)
* `OptimisticTransactionImpl` is requested to [updateMetadataForNewTableInReplace](../OptimisticTransactionImpl.md#updateMetadataForNewTableInReplace)
* `CoordinatedCommitsPreDowngradeCommand` is requested to [removeFeatureTracesIfNeeded](../coordinated-commits/CoordinatedCommitsPreDowngradeCommand.md#removeFeatureTracesIfNeeded)
* `CloneTableBase` is requested to [prepareSourceMetadata](../commands/clone/CloneTableBase.md#prepareSourceMetadata)
* `CreateDeltaTableCommand` is requested to [filterCoordinatedCommitsProperties](../commands/create-table/CreateDeltaTableCommand.md#filterCoordinatedCommitsProperties)
* `CoordinatedCommitsUtils` is requested to [getExplicitCCConfigurations](#getExplicitCCConfigurations), [tablePropertiesPresent](#tablePropertiesPresent) and [validateConfigurationsForAlterTableUnsetPropertiesDeltaCommand](#validateConfigurationsForAlterTableUnsetPropertiesDeltaCommand)

## tablePropertiesPresent { #tablePropertiesPresent }

```scala
tablePropertiesPresent(
  metadata: Metadata): Boolean
```

`tablePropertiesPresent` checks if any of the [TABLE_PROPERTY_KEYS](#TABLE_PROPERTY_KEYS) is among the table properties in the [configuration](../Metadata.md#configuration) of the given [Metadata](../Metadata.md).

---

`tablePropertiesPresent` is used when:

* `CoordinatedCommitsPreDowngradeCommand` is requested to [removeFeatureTracesIfNeeded](../coordinated-commits/CoordinatedCommitsPreDowngradeCommand.md#removeFeatureTracesIfNeeded)
* `CoordinatedCommitsTableFeature` is requested to [validateDropInvariants](../coordinated-commits/CoordinatedCommitsTableFeature.md#validateDropInvariants)
