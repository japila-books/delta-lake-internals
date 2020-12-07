# DeltaTimeTravelSpec

## <span id="TIMESTAMP_URI_FOR_TIME_TRAVEL"><span id="VERSION_URI_FOR_TIME_TRAVEL"> Time Travel Patterns

`DeltaTimeTravelSpec` defines regular expressions for timestamp- and version-based time travel identifiers:

* Version URI: `(path)@[vV](some numbers)`
* Timestamp URI: `(path)@(yyyyMMddHHmmssSSS)`

## Creating Instance

`DeltaTimeTravelSpec` takes the following to be created:

* <span id="timestamp"> Timestamp
* <span id="version"> Version
* <span id="creationSource"> `creationSource` identifier

`DeltaTimeTravelSpec` asserts that either [version](#version) or [timestamp](#timestamp) is provided (and throws an `AssertionError`).

`DeltaTimeTravelSpec` is created when:

* `DeltaTimeTravelSpec` utility is used to [resolve a path](#resolvePath)
* `DeltaDataSource` utility is used to [getTimeTravelVersion](DeltaDataSource.md#getTimeTravelVersion)

## <span id="resolvePath"> Resolving Path

```scala
resolvePath(
  conf: SQLConf,
  identifier: String): (DeltaTimeTravelSpec, String)
```

`resolvePath`...FIXME

`resolvePath` is used when `DeltaTableUtils` utility is used to [extractIfPathContainsTimeTravel](DeltaTableUtils.md#extractIfPathContainsTimeTravel).

## <span id="getTimestamp"> getTimestamp

```scala
getTimestamp(
  timeZone: String): Timestamp
```

`getTimestamp`...FIXME

`getTimestamp` is used when `DeltaTableUtils` utility is used to [resolveTimeTravelVersion](DeltaTableUtils.md#resolveTimeTravelVersion).

## <span id="isApplicable"> isApplicable

```scala
isApplicable(
  conf: SQLConf,
  identifier: String): Boolean
```

`isApplicable` is `true` when all of the following hold:

* [spark.databricks.delta.timeTravel.resolveOnIdentifier.enabled](DeltaSQLConf.md#RESOLVE_TIME_TRAVEL_ON_IDENTIFIER) is `true`
* [identifierContainsTimeTravel](#identifierContainsTimeTravel) is `true`

`isApplicable` is used when `DeltaTableUtils` utility is used to [extractIfPathContainsTimeTravel](DeltaTableUtils.md#extractIfPathContainsTimeTravel).

### <span id="identifierContainsTimeTravel"> identifierContainsTimeTravel

```scala
identifierContainsTimeTravel(
  identifier: String): Boolean
```

`identifierContainsTimeTravel` is `true` when the given `identifier` is either [timestamp](#TIMESTAMP_URI_FOR_TIME_TRAVEL) or [version](#VERSION_URI_FOR_TIME_TRAVEL) time travel pattern.
