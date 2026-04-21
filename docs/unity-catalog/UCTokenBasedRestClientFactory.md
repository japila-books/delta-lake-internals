# UCTokenBasedRestClientFactory

`UCTokenBasedRestClientFactory` is a [UCClientFactory](UCClientFactory.md) to [create a UCTokenBasedRestClient](#createUCClientWithVersions).

## createUCClient { #createUCClient }

??? note "UCClientFactory"

    ```scala
    createUCClient(
      uri: String,
      authConfig: Map[String, String]): UCClient
    ```

    `createUCClient` is part of the [UCClientFactory](UCClientFactory.md#createUCClient) abstraction.

`createUCClient` [createUCClientWithVersions](#createUCClientWithVersions).

## createUCClientWithVersions { #createUCClientWithVersions }

```scala
createUCClientWithVersions(
  uri: String,
  authConfig: Map[String, String],
  appVersions: Map[String, String]): UCClient
```

`createUCClientWithVersions` creates a `TokenProvider` ([Unity Catalog]({{ book.unity_catalog }}/client/TokenProvider/)) for the given `authConfig`.

In the end, `createUCClientWithVersions` creates a [UCTokenBasedRestClient](UCTokenBasedRestClient.md) for the given `uri` (with the `TokenProvider` and `appVersions`).

---

`createUCClientWithVersions` is used when:

* `UCTokenBasedRestClientFactory` is requested to [createUCClient](#createUCClient) and [createUCClientWithVersions](#createUCClientWithVersions)
