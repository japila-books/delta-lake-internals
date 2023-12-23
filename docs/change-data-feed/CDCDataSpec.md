# CDCDataSpec

## Creating Instance

`CDCDataSpec` takes the following to be created:

* <span id="version"> Version
* <span id="timestamp"> Timestamp
* <span id="actions"> [FileAction](../FileAction.md)s
* <span id="commitInfo"> [CommitInfo](../CommitInfo.md)

`CDCDataSpec` is created when:

* `CDCReaderImpl` is requested for the [changesToDF](CDCReaderImpl.md#changesToDF) (and, more specifically, [buildCDCDataSpecSeq](CDCReaderImpl.md#buildCDCDataSpecSeq) and [processDeletionVectorActions](CDCReaderImpl.md#processDeletionVectorActions))
