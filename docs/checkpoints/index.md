# Delta Table Checkpoint

[Delta Table Checkpoint](Checkpoints.md#checkpoint) is a process of writing out a [Snapshot](../Snapshot.md) of a delta table into one or more checkpoint files for faster state reconstruction (_future replays of the log_).

Delta Table Checkpoint happens regularly at a [transaction commit](../OptimisticTransactionImpl.md#doCommit) every [checkpoint interval](../table-properties/DeltaConfigs.md#CHECKPOINT_INTERVAL) or once at a [transaction commit](../OptimisticTransactionImpl.md#updateAndCheckpoint) for the following commands:

* [CloneTableBase](../commands/clone/CloneTableBase.md)
* [ConvertToDeltaCommand](../commands/convert/ConvertToDeltaCommand.md)
* [RestoreTableCommand](../commands/restore/RestoreTableCommand.md)

Delta Table Checkpoint uses a Spark job called **Delta checkpoint** to [write out checkpoint files](Checkpoints.md#writeCheckpoint).

Delta Table Checkpoint uses the following configuration properties:

* [spark.databricks.delta.checkpoint.partSize](../configuration-properties/index.md#spark.databricks.delta.checkpoint.partSize)
