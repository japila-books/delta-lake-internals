# AdmissionLimits

`AdmissionLimits` is used by [DeltaSource](DeltaSource.md) to control how much data should be processed by a [single micro-batch](DeltaSource.md#getBatch).

## Creating Instance

`AdmissionLimits` takes the following to be created:

* <span id="maxFiles"> Maximum Number of Files (based on [maxFilesPerTrigger](options/index.md#maxFilesPerTrigger) option)
* <span id="bytesToTake"> Maximum Bytes (based on [maxBytesPerTrigger](options/index.md#maxBytesPerTrigger) option)

`AdmissionLimits` is created when:

* `DeltaSource` is requested to [getChangesWithRateLimit](DeltaSource.md#getChangesWithRateLimit), [getStartingOffset](DeltaSource.md#getStartingOffset), [getDefaultReadLimit](DeltaSource.md#getDefaultReadLimit)

## <span id="apply"> Converting ReadLimit to AdmissionLimits

```scala
apply(
  limit: ReadLimit): Option[AdmissionLimits]
```

`apply` creates an `AdmissionLimits` for the given `ReadLimit` (Spark Structured Streaming).

ReadLimit | AdmissionLimits
----------|----------
 `ReadAllAvailable` | `None`
 `ReadMaxFiles` | [Maximum Number of Files](#maxFiles)
 `ReadMaxBytes` | [Maximum Bytes](#bytesToTake)
 `CompositeLimit` | [Maximum Number of Files](#maxFiles) and [Maximum Bytes](#bytesToTake)

`apply` throws an `UnsupportedOperationException` for unknown `ReadLimit`s:

```text
Unknown ReadLimit: [limit]
```

`apply` is used when:

* `DeltaSource` is requested for the [latest available offset](DeltaSource.md#latestOffset)

## <span id="admit"> Admitting AddFile

```scala
admit(
  add: Option[AddFile]): Boolean
```

`admit`...FIXME

`admit` is used when:

* `DeltaSource` is requested to [getChangesWithRateLimit](DeltaSource.md#getChangesWithRateLimit)
