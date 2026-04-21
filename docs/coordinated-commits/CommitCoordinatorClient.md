# CommitCoordinatorClient

`CommitCoordinatorClient` is an [abstraction](#contract) of [commit coordinator clients](#implementations) that can communicate with a commit coordinator and [backfill commits](#backfillToVersion).

## Contract

### backfillToVersion { #backfillToVersion }

```java
void backfillToVersion(
  LogStore logStore,
  Configuration hadoopConf,
  TableDescriptor tableDescriptor,
  long version,
  Long lastKnownBackfilledVersion) throws IOException
```

See:

* [UCCommitCoordinatorClient](../unity-catalog/UCCommitCoordinatorClient.md#backfillToVersion)

Used when:

* `DynamoDBCommitCoordinatorClient` is requested to `commit`
* `UCCommitCoordinatorClient` is requested to [commitImpl](../unity-catalog/UCCommitCoordinatorClient.md#commitImpl) and [attemptFullBackfill](../unity-catalog/UCCommitCoordinatorClient.md#attemptFullBackfill)
* `AbstractBatchBackfillingCommitCoordinatorClient` is requested to `commit`
* `TableCommitCoordinatorClient` is requested to `backfillToVersion`

### commit { #commit }

```java
CommitResponse commit(
  LogStore logStore,
  Configuration hadoopConf,
  TableDescriptor tableDescriptor,
  long commitVersion,
  Iterator<String> actions,
  UpdatedActions updatedActions) throws CommitFailedException
```

See:

* [UCCommitCoordinatorClient](../unity-catalog/UCCommitCoordinatorClient.md#commit)

Used when:

* `TableCommitCoordinatorClient` is requested to `commit`

### getCommits { #getCommits }

```java
GetCommitsResponse getCommits(
  TableDescriptor tableDescriptor,
  Long startVersion,
  Long endVersion)
```

See:

* [UCCommitCoordinatorClient](../unity-catalog/UCCommitCoordinatorClient.md#getCommits)

Used when:

* `UCCommitCoordinatorClient` is requested to [getLastKnownBackfilledVersion](../unity-catalog/UCCommitCoordinatorClient.md#getLastKnownBackfilledVersion) and [backfillToVersion](../unity-catalog/UCCommitCoordinatorClient.md#backfillToVersion)
* `AbstractBatchBackfillingCommitCoordinatorClient` is requested to `backfillToVersion`
* `TableCommitCoordinatorClient` is requested to `getCommits`

### registerTable { #registerTable }

```java
Map<String, String> registerTable(
  Path logPath,
  Optional<TableIdentifier> tableIdentifier,
  long currentVersion,
  AbstractMetadata currentMetadata,
  AbstractProtocol currentProtocol)
```

See:

* [UCCommitCoordinatorClient](../unity-catalog/UCCommitCoordinatorClient.md#registerTable)

Used when:

* `OptimisticTransactionImpl` is requested to [registerTableForCoordinatedCommitsIfNeeded](../OptimisticTransactionImpl.md#registerTableForCoordinatedCommitsIfNeeded)

### semanticEquals { #semanticEquals }

```java
boolean semanticEquals(
  CommitCoordinatorClient other)
```

See:

* [UCCommitCoordinatorClient](../unity-catalog/UCCommitCoordinatorClient.md#semanticEquals)

Used when:

* `CommitCoordinatorClient` is requested to [semanticEquals](#semanticEquals-object)

## Implementations

* `AbstractBatchBackfillingCommitCoordinatorClient`
* `DynamoDBCommitCoordinatorClient`
* `FileSystemBasedCommitCoordinatorClient`
* [UCCommitCoordinatorClient](UCCommitCoordinatorClient.md)

## CommitCoordinatorClient.semanticEquals { #semanticEquals-object }

```scala
semanticEquals(
  commitCoordinatorClientOpt1: Option[CommitCoordinatorClient],
  commitCoordinatorClientOpt2: Option[CommitCoordinatorClient]): Boolean
```

`semanticEquals`...FIXME

---

`semanticEquals` is used when:

* `TableCommitCoordinatorClient` is requested to `semanticsEquals`
