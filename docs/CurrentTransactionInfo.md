# CurrentTransactionInfo

`CurrentTransactionInfo` is the attributes of a transaction used for [conflict detection](ConflictChecker.md#currentTransactionInfo).

## Creating Instance

`CurrentTransactionInfo` takes the following to be created:

* <span id="txnId"> Transaction ID
* <span id="readPredicates"> `DeltaTableReadPredicate`s
* <span id="readFiles"> [AddFile](AddFile.md)s
* <span id="readWholeTable"> `readWholeTable` flag
* <span id="readAppIds"> Read App IDs
* <span id="metadata"> [Metadata](Metadata.md)
* <span id="protocol"> [Protocol](Protocol.md)
* <span id="actions"> [Action](Action.md)s
* <span id="readSnapshot"> Read [Snapshot](Snapshot.md)
* <span id="commitInfo"> Optional [CommitInfo](CommitInfo.md)
* <span id="readRowIdHighWatermark"> Read RowId High Watermark
* <span id="domainMetadata"> [DomainMetadata](DomainMetadata.md)s

`CurrentTransactionInfo` is created when:

* `OptimisticTransactionImpl` is requested to [commitImpl](OptimisticTransactionImpl.md#commitImpl)
