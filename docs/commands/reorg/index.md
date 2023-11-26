# REORG Command

`REORG` physically deletes dropped rows and columns of a delta table.

```sql
REORG TABLE (delta.`/path/to/table` | delta_table_name)
[WHERE partition_predicate] APPLY (PURGE)
```

`REORG` command requires the file path or the name of a delta table.

`REORG` command is parsed into a [DeltaReorgTable](DeltaReorgTable.md) unary logical operator.
