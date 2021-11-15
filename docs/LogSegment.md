# LogSegment

`LogSegment` are the [delta](#deltas) and [checkpoint](#checkpoint) files that all together are a given version of a delta table.

## Creating Instance

`LogSegment` takes the following to be created:

* <span id="logPath"> Log Path ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="version"> Version
* <span id="deltas"> Delta `FileStatus`es ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html))
* <span id="checkpoint"> Checkpoint `FileStatus`es ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html))
* <span id="checkpointVersion"> Checkpoint Version
* <span id="lastCommitTimestamp"> Timestamp of the Last Commit

`LogSegment` is created when:

* `SnapshotManagement` is requested for the [LogSegment at a given version](SnapshotManagement.md#getLogSegmentForVersion)
