# UCClientFactory

`UCClientFactory` is an [abstraction](#contract) of [factories](#implementations) that can [create UCClients](#createUCClient).

## Contract

### createUCClient { #createUCClient }

```scala
createUCClient(
  uri: String,
  authConfig: Map[String, String]): UCClient
```

See:

* [UCTokenBasedRestClientFactory](UCTokenBasedRestClientFactory.md#createUCClient)

Used when:

* `UCCommitCoordinatorBuilder` is requested to [buildForCatalog](UCCommitCoordinatorBuilder.md#buildForCatalog), [getMatchingUCClient](UCCommitCoordinatorBuilder.md#getMatchingUCClient), [getMetastoreId](UCCommitCoordinatorBuilder.md#getMetastoreId)
* `UCTokenBasedRestClientFactory` is requested to [create a Unity Catalog client](UCTokenBasedRestClientFactory.md#createUCClient)

## Implementations

* [UCTokenBasedRestClientFactory](UCTokenBasedRestClientFactory.md)
