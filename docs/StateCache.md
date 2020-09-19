= StateCache

`StateCache` is...FIXME

== [[cacheDS]] Creating CachedDS Instance -- `cacheDS` Method

[source, scala]
----
cacheDS[A](
  ds: Dataset[A],
  name: String): CachedDS[A]
----

`cacheDS` simply creates a new <<CachedDS.adoc#, CachedDS>>.

[NOTE]
====
`cacheDS` is used when:

* <<Snapshot.adoc#, Snapshot>> is created (and creates a <<Snapshot.adoc#cachedState, cached state>>)

* `DeltaSourceSnapshot` is requested to <<DeltaSourceSnapshot.adoc#initialFiles, initialFiles>>
====
