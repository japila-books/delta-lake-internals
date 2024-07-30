# TableImpl

`TableImpl` is a [Table](Table.md) that can be created using [Table.forPath](Table.md#forPath) utility.

!!! note
    There is no configuration property to change the default implementation of [Table](Table.md) abstraction at the moment.

## Creating Instance

`TableImpl` takes the following to be created:

* <span id="tablePath"> Table path

`TableImpl` is created using [TableImpl.forPath](#forPath) utility.

## Create Delta Table for Path { #forPath }

```java
Table forPath(
  Engine engine,
  String path)
```

`forPath` requests the given [Engine](Engine.md) for the [getFileSystemClient](Engine.md#getFileSystemClient) to [resolvePath](FileSystemClient.md#resolvePath).

In the end, `forPath` creates a [TableImpl](TableImpl.md) with the path resolved.

---

`forPath` is used when:

* [Table.forPath](Table.md#forPath) utility is used
