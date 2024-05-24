# DeltaTimeTravelSpec

## Creating Instance

`DeltaTimeTravelSpec` takes the following to be created:

* [Timestamp](#timestamp)
* [Version](#version)
* [Creation Source ID](#creationSource)

`DeltaTimeTravelSpec` asserts that either [version](#version) or [timestamp](#timestamp) is provided (and throws an `AssertionError`).

`DeltaTimeTravelSpec` is created when:

* [DeltaAnalysis](../DeltaAnalysis.md) logical resolution rule is resolving [RestoreTableStatement](../commands/restore/RestoreTableStatement.md) unary logical operator
* `DeltaTimeTravelSpec` utility is used to [resolve a path](#resolvePath)
* `DeltaDataSource` utility is used to [getTimeTravelVersion](../spark-connector/DeltaDataSource.md#getTimeTravelVersion)
* `DeltaSource` is requested to for the [getStartingVersion](../spark-connector/DeltaSource.md#getStartingVersion)

### Version

```scala
version: Option[Long]
```

`DeltaTimeTravelSpec` can be given a version when [created](#creating-instance):

* [DeltaAnalysis](../DeltaAnalysis.md) logical resolution rule is executed (to resolve a [RestoreTableStatement](../commands/restore/RestoreTableStatement.md))
* `DeltaTimeTravelSpec` utility is used to [resolve path](#resolvePath)
* `DeltaDataSource` utility is used to [getTimeTravelVersion](../spark-connector/DeltaDataSource.md#getTimeTravelVersion)

`version` is mutually exclusive with the [timestamp](#timestamp) (so only one can be specified).

### Creation Source ID { #creationSource }

`DeltaTimeTravelSpec` is given a **Creation Source ID** when [created](#creating-instance).

The Creation Source ID indicates the API used to time travel:

* [Creation Source ID](../commands/restore/TimeTravel.md#creationSource) of the [TimeTravel](../commands/restore/RestoreTableStatement.md#table) of [RestoreTableStatement](../commands/restore/RestoreTableStatement.md) unary logical operator (when [DeltaAnalysis](../DeltaAnalysis.md) logical resolution rule is executed)
* `atSyntax.path` for [DeltaTimeTravelSpec](#resolvePath)
* `dfReader` for [DeltaDataSource](../spark-connector/DeltaDataSource.md#getTimeTravelVersion)
* `deltaSource` for [DeltaSource](../spark-connector/DeltaSource.md#getStartingVersion)

## <span id="TIMESTAMP_URI_FOR_TIME_TRAVEL"><span id="VERSION_URI_FOR_TIME_TRAVEL"> Time Travel Patterns

`DeltaTimeTravelSpec` defines regular expressions for timestamp- and version-based time travel identifiers:

* Version URI: `(path)@[vV](some numbers)`
* Timestamp URI: `(path)@(yyyyMMddHHmmssSSS)`

## <span id="resolvePath"> Resolving Path

```scala
resolvePath(
  conf: SQLConf,
  identifier: String): (DeltaTimeTravelSpec, String)
```

`resolvePath`...FIXME

`resolvePath` is used when `DeltaTableUtils` utility is used to [extractIfPathContainsTimeTravel](../DeltaTableUtils.md#extractIfPathContainsTimeTravel).

## <span id="getTimestamp"> getTimestamp

```scala
getTimestamp(
  timeZone: String): Timestamp
```

`getTimestamp`...FIXME

`getTimestamp` is used when `DeltaTableUtils` utility is used to [resolveTimeTravelVersion](../DeltaTableUtils.md#resolveTimeTravelVersion).

## <span id="isApplicable"> isApplicable

```scala
isApplicable(
  conf: SQLConf,
  identifier: String): Boolean
```

`isApplicable` is `true` when all of the following hold:

* [spark.databricks.delta.timeTravel.resolveOnIdentifier.enabled](../configuration-properties/DeltaSQLConf.md#RESOLVE_TIME_TRAVEL_ON_IDENTIFIER) is `true`
* [identifierContainsTimeTravel](#identifierContainsTimeTravel) is `true`

`isApplicable` is used when `DeltaTableUtils` utility is used to [extractIfPathContainsTimeTravel](../DeltaTableUtils.md#extractIfPathContainsTimeTravel).

### identifierContainsTimeTravel { #identifierContainsTimeTravel }

```scala
identifierContainsTimeTravel(
  identifier: String): Boolean
```

`identifierContainsTimeTravel` is `true` when the given `identifier` is either [timestamp](#TIMESTAMP_URI_FOR_TIME_TRAVEL) or [version](#VERSION_URI_FOR_TIME_TRAVEL) time travel pattern.
