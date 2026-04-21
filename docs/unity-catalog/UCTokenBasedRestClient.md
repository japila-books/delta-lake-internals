# UCTokenBasedRestClient

`UCTokenBasedRestClient` is an [UCClient](UCClient.md) that uses the [Unity Catalog Client API]({{ book.unity_catalog }}/client/) (with [TokenProvider](#tokenProvider)-based authentication) for managing delta table commits and metadata.

## Creating Instance

`UCTokenBasedRestClient` takes the following to be created:

* <span id="baseUri"> Base URI
* <span id="tokenProvider"> `TokenProvider`
* <span id="appVersions"> Application Version Metadata (`Map<String, String>`)

`UCTokenBasedRestClient` is created when:

* `UCTokenBasedRestClientFactory` is requested to [createUCClientWithVersions](UCTokenBasedRestClientFactory.md#createUCClientWithVersions)

### DeltaCommitsApi { #deltaCommitsApi }

### MetastoresApi { #metastoresApi }

### TablesApi { #tablesApi }
