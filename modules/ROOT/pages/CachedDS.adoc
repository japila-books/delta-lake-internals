= CachedDS -- Cached Delta State

`CachedDS` (of ``A``s) is <<creating-instance, created>> exclusively when <<StateCache.adoc#, StateCache>> is requested to <<cacheDS, cacheDS>>.

NOTE: `CachedDS` is an internal class of <<StateCache.adoc#, StateCache>> and has access to its internals.

== [[creating-instance]] Creating CachedDS Instance

`CachedDS` takes the following to be created:

* [[ds]] `Dataset[A]`
* [[name]] Name

== [[getDS]] `getDS` Method

[source, scala]
----
getDS: Dataset[A]
----

`getDS`...FIXME

[NOTE]
====
`getDS` is used when:

* `Snapshot` is requested to <<Snapshot.adoc#state, state>>

* `DeltaSourceSnapshot` is requested to <<DeltaSourceSnapshot.adoc#initialFiles, initialFiles>>
====

== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| dsCache
a| [[dsCache]] (`Option[Dataset[A]]`)

Used when...FIXME

| rddCache
a| [[rddCache]] (`Option[RDD[InternalRow]]`)

Used when...FIXME

|===
