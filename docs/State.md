# Snapshot.State

## Creating Instance

`Snapshot.State` takes the following to be created:

* <span id="sizeInBytes"> `sizeInBytes`
* <span id="numOfSetTransactions"> `numOfSetTransactions`
* <span id="numOfFiles"> `numOfFiles`
* <span id="numOfRemoves"> `numOfRemoves`
* <span id="numOfMetadata"> `numOfMetadata`
* <span id="numOfProtocol"> `numOfProtocol`
* <span id="setTransactions"> [SetTransaction](SetTransaction.md)s
* <span id="metadata"> [Metadata](Metadata.md)
* <span id="protocol"> [Protocol](Protocol.md)
* <span id="fileSizeHistogram"> (optional) [FileSizeHistogram](data-skipping/FileSizeHistogram.md)

`Snapshot.State` is created when:

* `InitialSnapshot` is requested for an [initial state](InitialSnapshot.md#initialState)
