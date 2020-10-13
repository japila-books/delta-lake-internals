# DeltaTimeTravelSpec

## <span id="TIMESTAMP_URI_FOR_TIME_TRAVEL"><span id="VERSION_URI_FOR_TIME_TRAVEL"> Time Travel Patterns

`DeltaTimeTravelSpec` defines regular expressions for timestamp- and version-based time travel identifiers:

* Version URI: `(path)@[vV](some numbers)`
* Timestamp URI: `(path)@(yyyyMMddHHmmssSSS)`

## Creating Instance

`DeltaTimeTravelSpec` takes the following to be created:

* <span id="timestamp"> Optional Timestamp Expression
* <span id="version"> Optional Version
* <span id="creationSource"> Optional `creationSource` identifier

Either [version](#version) or [timestamp](#timestamp) should be provided.

`DeltaTimeTravelSpec` is created when:

* `DeltaTimeTravelSpec` utility is used to [resolvePath](#resolvePath)
* `DeltaDataSource` utility is used to [getTimeTravelVersion](DeltaDataSource.md#getTimeTravelVersion)

## <span id="resolvePath"> resolvePath

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
