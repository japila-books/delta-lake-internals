---
hide:
  - toc
---

# Storage

Delta Lake [can now automatically load the correct LogStore](LogStoreProvider.md#createLogStore) needed for common storage systems hosting the Delta table being read or written to.

[LogStoreProvider](LogStoreProvider.md) uses [DelegatingLogStore](DelegatingLogStore.md) unless [spark.delta.logStore.class](LogStoreProvider.md#spark.delta.logStore.class) configuration property is defined.

The scheme of the Delta table path is used to [dynamically load the necessary LogStore implementation](DelegatingLogStore.md#getDelegate). This also allows the same application to simultaneously read and write to Delta tables on different cloud storage systems.

[DelegatingLogStore](DelegatingLogStore.md) allows for [custom LogStores per URI scheme](LogStore.md#logStoreSchemeConfKey) before using the [default LogStores](DelegatingLogStore.md#getDefaultLogStoreClassName).

Schemes  | Default LogStore
---------|---------
 `s3`, `s3a`, `s3n` | [S3SingleDriverLogStore](S3SingleDriverLogStore.md)
 `abfs`, `abfss`, `adl`, `wasb`, `wasbs` | `AzureLogStore`

`DelegatingLogStore` uses [HDFSLogStore](HDFSLogStore.md) as the [default LogStore](DelegatingLogStore.md#defaultLogStore).
