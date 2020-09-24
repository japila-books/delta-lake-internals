= StateCache

`StateCache` is...FIXME

== [[cacheDS]] Creating CachedDS Instance -- `cacheDS` Method

[source, scala]
----
cacheDS[A](
  ds: Dataset[A],
  name: String): CachedDS[A]
----

`cacheDS` simply creates a new <<CachedDS.md#, CachedDS>>.

[NOTE]
====
`cacheDS` is used when:

* <<Snapshot.md#, Snapshot>> is created (and creates a <<Snapshot.md#cachedState, cached state>>)

* `DeltaSourceSnapshot` is requested to <<DeltaSourceSnapshot.md#initialFiles, initialFiles>>
====
