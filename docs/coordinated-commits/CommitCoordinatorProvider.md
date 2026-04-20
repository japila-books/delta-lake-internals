# CommitCoordinatorProvider

## getCommitCoordinatorClientOpt { #getCommitCoordinatorClientOpt }

```scala
getCommitCoordinatorClientOpt(
  name: String,
  conf: Map[String, String],
  spark: SparkSession): Option[CommitCoordinatorClient]
```

`getCommitCoordinatorClientOpt` looks up a [CommitCoordinatorBuilder](CommitCoordinatorBuilder.md) by the given `name` (in the [nameToBuilderMapping](#nameToBuilderMapping) lookup table).

If found, `getCommitCoordinatorClientOpt` requests this `CommitCoordinatorBuilder` to [build a CommitCoordinatorClient](CommitCoordinatorBuilder.md#build).

---

`getCommitCoordinatorClientOpt` is used when:

* `CommitCoordinatorProvider` is requested to [getCommitCoordinatorClient](#getCommitCoordinatorClient)
* `CoordinatedCommitsUtils` is requested to [getCommitCoordinatorClient](CoordinatedCommitsUtils.md#getCommitCoordinatorClient)
