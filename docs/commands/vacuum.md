= Vacuum Command

`Vacuum` command does...FIXME (see <<VacuumCommand.md#gc, VacuumCommand.gc>>)

`Vacuum` command can be executed as delta-sql.md#VACUUM[VACUUM] SQL command or <<DeltaTable.md#vacuum, DeltaTable.vacuum>> operator.

```
/*
spark-shell \
  --packages io.delta:delta-core_2.12:0.7.0 \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension
*/

scala> sql("VACUUM delta.`/tmp/delta/t1`").show
Deleted 0 files and directories in a total of 2 directories.
+------------------+
|              path|
+------------------+
|file:/tmp/delta/t1|
+------------------+
```
