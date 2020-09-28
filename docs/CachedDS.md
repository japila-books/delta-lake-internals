# CachedDS &mdash; Cached Delta State

`CachedDS` is used when [StateCache](StateCache.md) is requested to [cacheDS](#cacheDS).

!!! note
    `CachedDS` is an internal class of `StateCache` and has access to its internals.

## Creating Instance

`CachedDS` takes the following to be created:

* <span id="ds"> `Dataset[A]`
* <span id="name"> Name

`CachedDS` is created when `StateCache` is requested to [cacheDS](#cacheDS).

== [[getDS]] `getDS` Method

[source, scala]
----
getDS: Dataset[A]
----

`getDS`...FIXME

`getDS` is used when:

* `Snapshot` is requested to [state](Snapshot.md#state)

* `DeltaSourceSnapshot` is requested to [initialFiles](DeltaSourceSnapshot.md#initialFiles)
