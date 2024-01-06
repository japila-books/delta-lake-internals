# CDCVersionDiffInfo

`CDCVersionDiffInfo` is a tuple with the following:

* <span id="fileChangeDf"> The changes between some start and end versions of a delta table (as a `DataFrame`)
* <span id="numFiles"> `numFiles` metric
* <span id="numBytes"> `numBytes` metric

`CDCVersionDiffInfo` is created when:

* `CDCReaderImpl` is requested for the [changesToDF](#changesToDF)
