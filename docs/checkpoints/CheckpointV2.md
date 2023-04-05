# CheckpointV2

## Extracting Partition Values { #extractPartitionValues }

```scala
extractPartitionValues(
  partitionSchema: StructType,
  partitionValuesColName: String): Option[Column]
```

??? note "Noop for no `partitionSchema`"
    For no `partitionSchema`, `extractPartitionValues` does nothing and returns `None` (an undefined value).

For every field in the given `partitionSchema`, `extractPartitionValues` [getPhysicalName](../column-mapping/DeltaColumnMappingBase.md#getPhysicalName) and creates a `Column` with _an expression_.

??? note "FIXME Elaborate on 'an expression' 🙏"

In the end, `extractPartitionValues` creates a `struct` of the extracted partition values as [partitionValues_parsed](#PARTITIONS_COL_NAME) column name.

---

`extractPartitionValues` is used when:

* `Checkpoints` is requested to [buildCheckpoint](Checkpoints.md#buildCheckpoint)

## <span id="PARTITIONS_COL_NAME"> partitionValues_parsed Column Name { #partitionValues_parsed }

`CheckpointV2` defines `partitionValues_parsed` as the name of the `struct` column when [extracting partition values](#extractPartitionValues).
