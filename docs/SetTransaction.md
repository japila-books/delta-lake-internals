= SetTransaction

`SetTransaction` is an <<Action.md#, action>> that denotes the committed <<version, version>> for an <<appId, application>>.

`SetTransaction` is <<creating-instance, created>> when `DeltaSink` is requested to <<DeltaSink.md#addBatch, add a streaming micro-batch>> (for `STREAMING UPDATE` operation idempotence at query restart).

== [[creating-instance]] Creating SetTransaction Instance

`SetTransaction` takes the following to be created:

* [[appId]] Application ID (e.g. streaming query ID)
* [[version]] Version (e.g micro-batch ID)
* [[lastUpdated]] Last Updated (optional) (e.g. milliseconds since the epoch)

== [[wrap]] `wrap` Method

[source, scala]
----
wrap: SingleAction
----

NOTE: `wrap` is part of the <<Action.md#wrap, Action>> contract to wrap the action into a <<SingleAction.md#, SingleAction>> for serialization.

`wrap` simply creates a new <<SingleAction.md#, SingleAction>> with the `txn` field set to this `SetTransaction`.
