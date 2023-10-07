# DeletionVectorUtils

## deletionVectorsWritable { #deletionVectorsWritable }

```scala
deletionVectorsWritable(
  snapshot: SnapshotDescriptor,
  newProtocol: Option[Protocol] = None,
  newMetadata: Option[Metadata] = None): Boolean
deletionVectorsWritable(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`deletionVectorsWritable` is enabled (`true`) when the following all hold:

1. [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the given [Protocol](../Protocol.md)
1. [delta.enableDeletionVectors](../DeltaConfigs.md#ENABLE_DELETION_VECTORS_CREATION) is enabled in the table metadata (in the given [Metadata](../Metadata.md))

---

`deletionVectorsWritable` is used when:

* `OptimisticTransactionImpl` is requested to [getAssertDeletionVectorWellFormedFunc](../OptimisticTransactionImpl.md#getAssertDeletionVectorWellFormedFunc)
* [DeleteCommand](../commands/delete/index.md) is executed (and requested to [shouldWritePersistentDeletionVectors](../commands/delete/DeleteCommand.md#shouldWritePersistentDeletionVectors))
