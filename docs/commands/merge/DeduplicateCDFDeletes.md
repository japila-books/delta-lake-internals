# DeduplicateCDFDeletes

`DeduplicateCDFDeletes` supports execution of [ClassicMergeExecutor](ClassicMergeExecutor.md) to [write out all merge changes to a target delta table](ClassicMergeExecutor.md#writeAllChanges) (when [there are files to rewrite](ClassicMergeExecutor.md#findTouchedFiles)) with [Change Data Feed](../../change-data-feed/index.md) enabled.

More precisely, `DeduplicateCDFDeletes` is an input argument of [MergeOutputGeneration](MergeOutputGeneration.md)s when requested for the following:

* [deduplicateCDFDeletes](MergeOutputGeneration.md#deduplicateCDFDeletes)
* [generateCdcAndOutputRows](MergeOutputGeneration.md#generateCdcAndOutputRows)

## Creating Instance

`DeduplicateCDFDeletes` takes the following to be created:

* [enabled flag](#enabled)
* [includesInserts flag](#includesInserts)

`DeduplicateCDFDeletes` is created when:

* `ClassicMergeExecutor` is requested to [find files to rewrite](ClassicMergeExecutor.md#findTouchedFiles)

### enabled Flag { #enabled }

`DeduplicateCDFDeletes` is given an `enabled` flag when [created](#creating-instance) based on the following:

* Whether there are multiple matches (`hasMultipleMatches`)
* [enableChangeDataFeed](../../DeltaConfigs.md#enableChangeDataFeed) table property

### includesInserts Flag { #includesInserts }

`DeduplicateCDFDeletes` is given an `includesInserts` flag when [created](#creating-instance).

`includesInserts` flag is enabled (`true`) when a merge command [includes WHEN NOT MATCHED THEN INSERT clauses](MergeIntoCommandBase.md#includesInserts).
