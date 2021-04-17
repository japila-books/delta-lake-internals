# Vacuum Command

`Vacuum` command allows for [garbage collection of a delta table](VacuumCommand.md#gc).

`Vacuum` command can be executed as a [SQL command](../../sql/index.md#VACUUM) or [DeltaTable](../../DeltaTable.md#vacuum) operator.

## Demo

### VACUUM SQL Command

```scala
val q = sql("VACUUM delta.`/tmp/delta/t1`")
```

```text
scala> q.show
Deleted 0 files and directories in a total of 2 directories.
+------------------+
|              path|
+------------------+
|file:/tmp/delta/t1|
+------------------+
```

### DeltaTable.vacuum

```scala
import io.delta.tables.DeltaTable
DeltaTable.forPath("/tmp/delta/t1").vacuum
```

### Dry Run

Visit [Demo: Vacuum](../../demo/vacuum.md).
