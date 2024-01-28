---
hide:
  - toc
---

# Log Cleanup

**Log Cleanup** (_Metadata Cleanup_) is used to remove expired metadata log files in the [transaction log](../DeltaLog.md) of a delta table.

Log Cleanup can be executed as part of [table checkpointing](../checkpoints/Checkpoints.md#doLogCleanup) when enabled using [delta.enableExpiredLogCleanup](../table-properties/DeltaConfigs.md#delta.enableExpiredLogCleanup) table property.

Expired log files are specified as older than [delta.logRetentionDuration](../table-properties/DeltaConfigs.md#logRetentionDuration) table property.
