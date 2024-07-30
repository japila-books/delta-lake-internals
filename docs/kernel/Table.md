# Table

`Table` is an [abstraction](#contract) of [delta tables](#implementations).

## Contract (Subset)

### Checkpoint

```java
checkpoint(
  Engine engine,
  long version)
```

Checkpoints the delta table (at the given version)

## Implementations

* [TableImpl](TableImpl.md)

## Create Delta Table for Path { #forPath }

```java
Table forPath(
  Engine engine,
  String path)
```

`forPath` creates a [TableImpl](TableImpl.md#forPath) for the given [Engine](Engine.md) and the `path`.
