# DeltaSourceOffset

`DeltaSourceOffset` is a streaming `Offset` ([Spark Structured Streaming]({{ book.structured_streaming }}/Offset)) for [DeltaSource](DeltaSource.md).

## Creating Instance

`DeltaSourceOffset` takes the following to be created:

* <span id="sourceVersion"> [Source Version](#VERSION)
* <span id="reservoirId"> Reservoir ID (aka [Table ID](DeltaSource.md#tableId))
* <span id="reservoirVersion"> Reservoir Version
* <span id="index"> Index
* <span id="isStartingVersion"> `isStartingVersion` flag

`DeltaSourceOffset` is created (using [apply](#apply) utility) when:

* `DeltaSource` is requested for the [starting](DeltaSource.md#getStartingOffset) and [latest](DeltaSource.md#latestOffset) offsets

## <span id="apply"> Creating DeltaSourceOffset

```scala
apply(
  reservoirId: String,
  offset: Offset): DeltaSourceOffset
apply(
  reservoirId: String,
  reservoirVersion: Long,
  index: Long,
  isStartingVersion: Boolean): DeltaSourceOffset
```

`apply` creates a [DeltaSourceOffset](#creating-instance) (for the [version](#VERSION) and the given arguments) or converts a `SerializedOffset` to a `DeltaSourceOffset`.

`apply` is used when:

* `DeltaSource` is requested for the [starting](DeltaSource.md#getStartingOffset) and [latest](DeltaSource.md#latestOffset) offsets

### <span id="validateSourceVersion"> validateSourceVersion

```scala
validateSourceVersion(
  json: String): Unit
```

`validateSourceVersion`...FIXME

## <span id="VERSION"> Source Version

`DeltaSourceOffset` uses `1` for the version (and does not allow changing it).

The version is used when:

* [DeltaSourceOffset.apply](#apply) and [validateSourceVersion](#validateSourceVersion) utilities are used
