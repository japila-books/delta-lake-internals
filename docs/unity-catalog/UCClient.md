# UCClient

`UCClient` is an [abstraction](#contract) of [Unity Catalog clients](#implementations) that can [getMetastoreId](#getMetastoreId).

`UCClient` is an `AutoCloseable` ([Java]({{ java.api }}/java/lang/AutoCloseable.html)).

## Contract (Subset)

### commit { #commit }

```java
commit(
  String tableId,
  URI tableUri,
  Optional<Commit> commit,
  Optional<Long> lastKnownBackfilledVersion,
  boolean disown,
  Optional<AbstractMetadata> newMetadata,
  Optional<AbstractProtocol> newProtocol,
  Optional<UniformMetadata> uniform
) throws IOException, CommitFailedException, UCCommitCoordinatorException
```

See:

* [UCTokenBasedRestClient](UCTokenBasedRestClient.md#commit)

Used when:

* `UCCatalogManagedCommitter` is requested to [commitToUC](UCCatalogManagedCommitter.md#commitToUC)
* `UCCommitCoordinatorClient` is requested to [commitToUC](UCCommitCoordinatorClient.md#commitToUC)

### finalizeCreate { #finalizeCreate }

```java
void finalizeCreate(
  String tableName,
  String catalogName,
  String schemaName,
  String storageLocation,
  List<ColumnDef> columns,
  Map<String, String> properties)
throws CommitFailedException
```

See:

* [UCTokenBasedRestClient](UCTokenBasedRestClient.md#finalizeCreate)

Used when:

* `UCCatalogManagedCommitter` is requested to [finalizeTableInCatalog](UCCatalogManagedCommitter.md#finalizeTableInCatalog)

### getCommits { #getCommits }

```java
GetCommitsResponse getCommits(
  String tableId,
  URI tableUri,
  Optional<Long> startVersion,
  Optional<Long> endVersion)
throws IOException, UCCommitCoordinatorException
```

See:

* [UCTokenBasedRestClient](UCTokenBasedRestClient.md#getCommits)

Used when:

* `UCCatalogManagedClient` is requested to [getRatifiedCommitsFromUC](UCCatalogManagedClient.md#getRatifiedCommitsFromUC)
* `UCCommitCoordinatorClient` is requested to [getCommitsFromUCImpl](UCCommitCoordinatorClient.md#getCommitsFromUCImpl)

### getMetastoreId { #getMetastoreId }

```java
String getMetastoreId() throws IOException
```

See:

* [UCTokenBasedRestClient](UCTokenBasedRestClient.md#getMetastoreId)

Used when:

* `UCCommitCoordinatorBuilder` is requested to [getMetastoreId](UCCommitCoordinatorBuilder.md#getMetastoreId)

## Implementations

* `InMemoryUCClient`
* [UCTokenBasedRestClient](UCTokenBasedRestClient.md)
