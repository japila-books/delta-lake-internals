# DeltaReadOptions

`DeltaReadOptions` is an extension of the [DeltaOptionParser](DeltaOptionParser.md) abstraction with the values of the read options of [DeltaOptions](DeltaOptions.md).

## excludeRegex { #excludeRegex }

```scala
excludeRegex: Option[Regex]
```

`excludeRegex` uses the [options](DeltaOptionParser.md#options) for the value of [excludeRegex](options.md#EXCLUDE_REGEX_OPTION) option and converts it to a [scala.util.matching.Regex]({{ scala.api }}/scala/util/matching/Regex.html).

`excludeRegex` is used when:

* `DeltaSource` is requested for the [excludeRegex](DeltaSource.md#excludeRegex)

## <span id="FAIL_ON_DATA_LOSS_OPTION"> failOnDataLoss { #failOnDataLoss }

```scala
failOnDataLoss: Boolean
```

`failOnDataLoss` uses the [options](DeltaOptionParser.md#options) for the value of [failOnDataLoss](options.md#FAIL_ON_DATA_LOSS_OPTION) option.

`failOnDataLoss` is `true` by default.

`failOnDataLoss` is used when:

* `DeltaSource` is requested to [getFileChanges](DeltaSource.md#getFileChanges)
* `DeltaSourceCDCSupport` is requested to [getFileChangesForCDC](../change-data-feed/DeltaSourceCDCSupport.md#getFileChangesForCDC)

## ignoreChanges { #ignoreChanges }

```scala
ignoreChanges: Boolean
```

`ignoreChanges`...FIXME

`ignoreChanges` is used when:

* FIXME

## ignoreDeletes { #ignoreDeletes }

```scala
ignoreDeletes: Boolean
```

`ignoreDeletes`...FIXME

`ignoreDeletes` is used when:

* FIXME

## ignoreFileDeletion { #ignoreFileDeletion }

```scala
ignoreFileDeletion: Boolean
```

`ignoreFileDeletion`...FIXME

`ignoreFileDeletion` is used when:

* FIXME

## maxBytesPerTrigger { #maxBytesPerTrigger }

```scala
maxBytesPerTrigger: Option[Long]
```

`maxBytesPerTrigger`...FIXME

`maxBytesPerTrigger` is used when:

* FIXME

## maxFilesPerTrigger { #maxFilesPerTrigger }

```scala
maxFilesPerTrigger: Option[Int]
```

`maxFilesPerTrigger`...FIXME

`maxFilesPerTrigger` is used when:

* FIXME

## readChangeFeed { #readChangeFeed }

```scala
readChangeFeed: Boolean
```

`readChangeFeed` uses the [options](DeltaOptionParser.md#options) for the boolean value of [readChangeFeed](options.md#CDC_READ_OPTION) option (if available or falls back to the legacy [readChangeData](options.md#readChangeData)).

!!! note "DeltaDataSource"
    Also known as [CDC_ENABLED_KEY](DeltaDataSource.md#CDC_ENABLED_KEY).

---

`readChangeFeed` is used when `DeltaSourceBase` is requested for the following:

* [checkReadIncompatibleSchemaChanges](DeltaSourceBase.md#checkReadIncompatibleSchemaChanges)
* [getFileChangesAndCreateDataFrame](DeltaSourceBase.md#getFileChangesAndCreateDataFrame) (for the `DeltaSource` to [get a streaming micro-batch dataframe](DeltaSource.md#getBatch))
* [getFileChangesWithRateLimit](DeltaSourceBase.md#getFileChangesWithRateLimit) (for `DeltaSource` to determine the [latest offset](DeltaSource.md#latestOffset))
* The [read schema](DeltaSourceBase.md#schema)

## startingTimestamp { #startingTimestamp }

```scala
startingTimestamp: Option[String]
```

`startingTimestamp`...FIXME

`startingTimestamp` is used when:

* FIXME

## startingVersion { #startingVersion }

```scala
startingVersion: Option[DeltaStartingVersion]
```

`startingVersion`...FIXME

`startingVersion` is used when:

* FIXME
