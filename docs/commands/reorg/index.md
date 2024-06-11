# REORG Command

`REORG TABLE` physically deletes dropped rows and columns of a delta table.

```sql
REORG TABLE (delta.`/path/to/table` | delta_table_name)
(
    [WHERE partition_predicate] APPLY (PURGE) |
    APPLY (UPGRADE UNIFORM (ICEBERG_COMPAT_VERSION = version))
)
```

`REORG TABLE` command requires the file path or the name of a delta table.

`REORG TABLE` command is parsed into a [DeltaReorgTable](DeltaReorgTable.md) unary logical operator.

!!! note
    `REORG TABLE` is also referred to as `PURGE` command.
