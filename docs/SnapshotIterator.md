= SnapshotIterator

`SnapshotIterator` is...FIXME

== [[iterator]] `iterator` Method

[source, scala]
----
iterator(): Iterator[IndexedFile]
----

`iterator`...FIXME

NOTE: `iterator` is used exclusively when `DeltaSource` is requested for the <<DeltaSource.md#getSnapshotAt, Snapshot by given version>>.
